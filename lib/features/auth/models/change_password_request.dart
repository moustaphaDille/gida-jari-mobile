class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}
