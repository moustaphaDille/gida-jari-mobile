import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/auth_response.dart';
import '../models/change_password_request.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_request.dart';
import '../models/verify_otp_response.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  Future<SendOtpResponse> sendOtp(SendOtpRequest request) async {
    final json = await _api.post(ApiEndpoints.sendOtp, body: request.toJson());
    return SendOtpResponse.fromJson(json);
  }

  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    final json = await _api.post(ApiEndpoints.verifyOtp, body: request.toJson());
    return VerifyOtpResponse.fromJson(json);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final json = await _api.post(ApiEndpoints.register, body: request.toJson());
    return AuthResponse.fromJson(json);
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final json = await _api.post(ApiEndpoints.login, body: request.toJson());
    return AuthResponse.fromJson(json);
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    await _api.post(ApiEndpoints.forgotPassword, body: request.toJson());
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _api.post(ApiEndpoints.resetPassword, body: request.toJson());
  }

  // Protégé : le Bearer est ajouté par ApiClient (auth: true)
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _api.post(
      ApiEndpoints.changePassword,
      body: request.toJson(),
      auth: true,
    );
  }
}
