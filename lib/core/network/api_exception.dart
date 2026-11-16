class ApiException implements Exception {
  final String message; // texte pour l'utilisateur
  final String? code; // ex: OTP_INVALIDE, UTILISATEUR_INTROUVABLE
  final int? statusCode;

  ApiException(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;
}

/// Texte à afficher dans l'UI (SnackBar, texte d'erreur…)
String errorMessage(Object error) {
  if (error is ApiException) return error.message;
  return error.toString();
}
