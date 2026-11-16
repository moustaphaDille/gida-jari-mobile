import '../../shared/models/user_profile.dart';

class ApiEndpoints {
  static const baseUrl = 'https://gida-backend-lav2.onrender.com';

  static const sendOtp = '/api/auth/send-otp';
  static const verifyOtp = '/api/auth/verify-otp';
  static const register = '/api/auth/register';
  static const login = '/api/auth/login';
  static const refresh = '/api/auth/refresh';
  static const changePassword = '/api/auth/change-password';
  static const clientProjects = '/api/clients/projets';
  static const openProjects = '/api/projets/ouverts';

  static String publishClientProject(String projectId) =>
      '/api/clients/projets/$projectId/publier';

  static String project(String projectId) => '/api/projets/$projectId';

  // à implémenter plus tard
  static const forgotPassword = '/api/auth/forgot-password';
  static const resetPassword = '/api/auth/reset-password';

  static String profilePath(ProfileType type, String id) {
    return switch (type) {
      ProfileType.client => '/api/clients/$id',
      ProfileType.artisan => '/api/artisans/$id',
      ProfileType.architecteIngenieur => '/api/experts/$id',
      ProfileType.entrepriseBtp => '/api/entreprises-btp/$id',
      ProfileType.fournisseurMateriaux => '/api/fournisseurs/$id',
      ProfileType.ongInstitution => '/api/ong-institutions/$id',
    };
  }

  static String completeProfilePath(ProfileType type) {
    return switch (type) {
      ProfileType.client => '/api/clients/complete-profile',
      ProfileType.artisan => '/api/artisans/complete-profile',
      ProfileType.architecteIngenieur => '/api/experts/complete-profile',
      ProfileType.entrepriseBtp => '/api/entreprises-btp/complete-profile',
      ProfileType.fournisseurMateriaux => '/api/fournisseurs/complete-profile',
      ProfileType.ongInstitution => '/api/ong-institutions/complete-profile',
    };
  }
}
