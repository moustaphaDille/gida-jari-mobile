import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gida_jari_mobile/shared/models/user_profile.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';
import '../models/change_password_request.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/profile_type_api.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_request.dart';
import '../models/verify_otp_response.dart';
import '../services/auth_service.dart';

// ---- dépendances ----
final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(tokenStorageProvider)),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(apiClientProvider)),
);

// ---- type de profil choisi (1er écran) ----
class SelectedProfileTypeNotifier extends Notifier<ProfileType?> {
  @override
  ProfileType? build() => null;

  void select(ProfileType type) => state = type;
}

final selectedProfileTypeProvider =
    NotifierProvider<SelectedProfileTypeNotifier, ProfileType?>(
  SelectedProfileTypeNotifier.new,
);

// ---- send-otp ----
class SendOtpNotifier extends Notifier<AsyncValue<SendOtpResponse?>> {
  // Gardés pour pouvoir renvoyer le code sans tout redemander
  String? _lastPhone;
  String? _lastEmail;

  @override
  AsyncValue<SendOtpResponse?> build() => const AsyncData(null);

  String? get lastPhone => _lastPhone;

  Future<void> send({required String phone, required String email}) async {
    _lastPhone = phone;
    _lastEmail = email;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authServiceProvider)
          .sendOtp(SendOtpRequest(phone: phone, email: email)),
    );
  }

  Future<void> resend() async {
    final phone = _lastPhone;
    final email = _lastEmail;
    if (phone == null || email == null) return;
    await send(phone: phone, email: email);
  }
}

final sendOtpProvider =
    NotifierProvider<SendOtpNotifier, AsyncValue<SendOtpResponse?>>(
  SendOtpNotifier.new,
);

// ---- verify-otp (garde le temporaryToken) ----
class VerifyOtpNotifier extends Notifier<AsyncValue<VerifyOtpResponse?>> {
  @override
  AsyncValue<VerifyOtpResponse?> build() => const AsyncData(null);

  Future<void> verify({required String code}) async {
    final type = ref.read(selectedProfileTypeProvider);
    final phone = ref.read(sendOtpProvider.notifier).lastPhone;
    if (type == null) {
      state = AsyncError('Choisis un type de profil', StackTrace.current);
      return;
    }
    if (phone == null || phone.isEmpty) {
      state = AsyncError(
        'Session OTP expirée, recommence la vérification du téléphone',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).verifyOtp(
            VerifyOtpRequest(
              phone: phone,
              code: code,
              profileType: type,
            ),
          ),
    );
  }
}

final verifyOtpProvider =
    NotifierProvider<VerifyOtpNotifier, AsyncValue<VerifyOtpResponse?>>(
  VerifyOtpNotifier.new,
);

// ---- register (sauvegarde les tokens) ----
class RegisterNotifier extends Notifier<AsyncValue<AuthResponse?>> {
  @override
  AsyncValue<AuthResponse?> build() => const AsyncData(null);

  Future<void> register({
    required String nom,
    required String prenom,
    required String adresse,
    required String password,
    required String confirmPassword,
  }) async {
    final type = ref.read(selectedProfileTypeProvider);
    final tempToken = ref.read(verifyOtpProvider).value?.temporaryToken;

    if (type == null || tempToken == null || tempToken.trim().isEmpty) {
      state = AsyncError(
        'Session expirée, recommence la vérification du téléphone',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = await ref.read(authServiceProvider).register(
            RegisterRequest(
              temporaryToken: tempToken,
              profileType: type,
              nom: nom,
              prenom: prenom,
              adresse: adresse,
              password: password,
              confirmPassword: confirmPassword,
            ),
          );

      await ref.read(tokenStorageProvider).saveTokens(
            accessToken: auth.accessToken,
            refreshToken: auth.refreshToken,
          );
      await ref.read(tokenStorageProvider).saveSessionProfile(
            userId: auth.userId,
            profileType: auth.profileType.apiValue,
          );
      return auth;
    });
  }
}

final registerProvider =
    NotifierProvider<RegisterNotifier, AsyncValue<AuthResponse?>>(
  RegisterNotifier.new,
);

// ---- login (sauvegarde les tokens) ----
class LoginNotifier extends Notifier<AsyncValue<AuthResponse?>> {
  @override
  AsyncValue<AuthResponse?> build() => const AsyncData(null);

  Future<void> login({
    String? phone,
    String? email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = await ref.read(authServiceProvider).login(
            LoginRequest(phone: phone, email: email, password: password),
          );

      await ref.read(tokenStorageProvider).saveTokens(
            accessToken: auth.accessToken,
            refreshToken: auth.refreshToken,
          );
      await ref.read(tokenStorageProvider).saveSessionProfile(
            userId: auth.userId,
            profileType: auth.profileType.apiValue,
          );
      return auth;
    });
  }
}

final loginProvider =
    NotifierProvider<LoginNotifier, AsyncValue<AuthResponse?>>(
  LoginNotifier.new,
);

class ForgotPasswordNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  Future<void> send({required String phone}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).forgotPassword(
            ForgotPasswordRequest(phone: phone),
          );
      return true;
    });
  }
}

final forgotPasswordProvider =
    NotifierProvider<ForgotPasswordNotifier, AsyncValue<bool>>(
  ForgotPasswordNotifier.new,
);

class ResetPasswordNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  Future<void> reset({
    required String phone,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      state = AsyncError(
        'Les deux mots de passe ne correspondent pas',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).resetPassword(
            ResetPasswordRequest(
              phone: phone,
              code: code,
              newPassword: newPassword,
              confirmPassword: confirmPassword,
            ),
          );
      return true;
    });
  }
}

final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, AsyncValue<bool>>(
  ResetPasswordNotifier.new,
);

// ---- change-password (utilisateur connecté) ----
// state : false = pas encore fait, true = mot de passe changé
class ChangePasswordNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  Future<void> change({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Vérif locale : évite un appel réseau pour rien
    if (newPassword != confirmPassword) {
      state = AsyncError(
        'Les deux mots de passe ne correspondent pas',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).changePassword(
            ChangePasswordRequest(
              oldPassword: oldPassword,
              newPassword: newPassword,
              confirmPassword: confirmPassword,
            ),
          );
      return true;
    });
  }
}

final changePasswordProvider =
    NotifierProvider<ChangePasswordNotifier, AsyncValue<bool>>(
  ChangePasswordNotifier.new,
);
