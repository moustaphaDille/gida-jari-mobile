class SendOtpResponse {
  final String phone;
  final bool nouvelUtilisateur;
  final String canal;
  final bool emailRequis;
  final String? emailMasque;

  const SendOtpResponse({
    required this.phone,
    required this.nouvelUtilisateur,
    required this.canal,
    required this.emailRequis,
    this.emailMasque,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      phone: json['phone'] as String,
      nouvelUtilisateur: json['nouvelUtilisateur'] as bool? ?? false,
      canal: json['canal'] as String? ?? '',
      emailRequis: json['emailRequis'] as bool? ?? false,
      emailMasque: json['emailMasque'] as String?,
    );
  }
}
