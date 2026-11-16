class VerifyOtpResponse {
  final String temporaryToken;
  final String phone;
  final String? email; // masqué par le backend (b***e@gmail.com)

  const VerifyOtpResponse({
    required this.temporaryToken,
    required this.phone,
    this.email,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      temporaryToken: json['temporaryToken'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );
  }
}
