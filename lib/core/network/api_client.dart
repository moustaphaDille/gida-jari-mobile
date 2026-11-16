import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._tokenStorage, {http.Client? client})
      : _client = client ?? http.Client();

  final TokenStorage _tokenStorage;
  final http.Client _client;

  // Render (offre gratuite) peut mettre ~50s à se réveiller
  static const _timeout = Duration(seconds: 60);

  // Refresh en cours (partagé entre requêtes simultanées)
  Future<bool>? _refreshing;

  /// [auth] = true : envoie le Bearer access token, et tente un refresh
  /// automatique (1 fois) si le serveur répond 401.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      var response = await _send(path, body, auth: auth);

      if (auth && response.statusCode == 401) {
        final refreshed = await _refreshTokens();
        if (!refreshed) throw _sessionExpired();
        response = await _send(path, body, auth: auth);
      }

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on TimeoutException {
      throw ApiException('Le serveur met trop de temps à répondre');
    } on http.ClientException {
      throw ApiException('Erreur réseau, réessaie');
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool auth = false,
  }) async {
    return _requestWithMethod('GET', path, auth: auth);
  }

  Future<List<dynamic>> getList(
    String path, {
    bool auth = false,
  }) async {
    try {
      String? token;
      if (auth) {
        token = await _tokenStorage.readAccessToken();
        if (token == null) throw _sessionExpired();
      }

      var response = await _client.get(
        Uri.parse('${ApiEndpoints.baseUrl}$path'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': '******',
        },
      ).timeout(_timeout);

      if (auth && response.statusCode == 401) {
        final refreshed = await _refreshTokens();
        if (!refreshed) throw _sessionExpired();
        return getList(path, auth: auth);
      }

      return _handleListResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on TimeoutException {
      throw ApiException('Le serveur met trop de temps à répondre');
    } on http.ClientException {
      throw ApiException('Erreur réseau, réessaie');
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    return _requestWithMethod('PATCH', path, body: body, auth: auth);
  }

  Future<Map<String, dynamic>> _requestWithMethod(
    String method,
    String path, {
    Map<String, dynamic>? body,
    required bool auth,
  }) async {
    try {
      String? token;
      if (auth) {
        token = await _tokenStorage.readAccessToken();
        if (token == null) throw _sessionExpired();
      }

      final request = http.Request(
        method,
        Uri.parse('${ApiEndpoints.baseUrl}$path'),
      )
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        })
        ..body = jsonEncode(body ?? {});
      var response = await http.Response.fromStream(
          await _client.send(request).timeout(_timeout));

      if (auth && response.statusCode == 401) {
        final refreshed = await _refreshTokens();
        if (!refreshed) throw _sessionExpired();
        return await _requestWithMethod(method, path, body: body, auth: auth);
      }

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    } on TimeoutException {
      throw ApiException('Le serveur met trop de temps à répondre');
    } on http.ClientException {
      throw ApiException('Erreur réseau, réessaie');
    }
  }

  Future<http.Response> _send(
    String path,
    Map<String, dynamic>? body, {
    required bool auth,
  }) async {
    String? token;
    if (auth) {
      token = await _tokenStorage.readAccessToken();
      if (token == null) throw _sessionExpired();
    }

    return _client
        .post(
          Uri.parse('${ApiEndpoints.baseUrl}$path'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body ?? {}),
        )
        .timeout(_timeout);
  }

  Future<bool> _refreshTokens() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _client
          .post(
            Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.refresh}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final json =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        await _tokenStorage.saveTokens(
          accessToken: json['accessToken'] as String,
          refreshToken: json['refreshToken'] as String,
        );
        return true;
      }

      // Refresh token refusé : la session est vraiment finie
      if (response.statusCode == 401 || response.statusCode == 403) {
        await _tokenStorage.clear();
      }
      return false;
    } catch (_) {
      // Problème réseau : on garde les tokens, l'utilisateur peut réessayer
      return false;
    }
  }

  ApiException _sessionExpired() => ApiException(
        'Session expirée, reconnecte-toi',
        code: 'SESSION_EXPIRED',
        statusCode: 401,
      );

  Map<String, dynamic> _handleResponse(http.Response response) {
    final raw = utf8.decode(response.bodyBytes);
    Map<String, dynamic> json = {};

    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) json = decoded;
      } catch (_) {
        // corps non JSON : on laisse json vide
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }

    throw ApiException(
      (json['message'] ?? 'Erreur ${response.statusCode}').toString(),
      code: json['erreur']?.toString(),
      statusCode: response.statusCode,
    );
  }

  List<dynamic> _handleListResponse(http.Response response) {
    final raw = utf8.decode(response.bodyBytes);
    dynamic decoded;

    if (raw.isNotEmpty) {
      try {
        decoded = jsonDecode(raw);
      } catch (_) {
        decoded = null;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is List<dynamic>) return decoded;
      throw ApiException('Réponse serveur invalide');
    }

    final json =
        decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    throw ApiException(
      (json['message'] ?? 'Erreur ${response.statusCode}').toString(),
      code: json['erreur']?.toString(),
      statusCode: response.statusCode,
    );
  }
}
