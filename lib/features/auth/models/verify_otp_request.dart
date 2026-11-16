import 'package:gida_jari_mobile/shared/models/user_profile.dart';

import 'profile_type_api.dart';

class VerifyOtpRequest {
  final String phone;
  final String code;
  final ProfileType profileType;

  const VerifyOtpRequest({
    required this.phone,
    required this.code,
    required this.profileType,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
        'profileType': profileType.apiValue,
      };
}
