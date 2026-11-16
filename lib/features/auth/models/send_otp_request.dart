class SendOtpRequest {
  final String phone;
  final String email;

  const SendOtpRequest({required this.phone, required this.email});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'email': email,
      };
}
