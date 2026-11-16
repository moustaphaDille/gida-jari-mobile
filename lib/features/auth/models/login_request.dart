class LoginRequest {
  final String? phone;
  final String? email;
  final String password;

  const LoginRequest({this.phone, this.email, required this.password});

  Map<String, dynamic> toJson() => {
        // on n'envoie que ce qui est rempli
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
        if (email != null && email!.isNotEmpty) 'email': email,
        'password': password,
      };
}
