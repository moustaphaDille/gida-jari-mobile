class ResetPasswordRequest {
  final String phone;
  final String code;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequest({
    required this.phone,
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}
