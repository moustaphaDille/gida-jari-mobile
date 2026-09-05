import 'package:flutter/material.dart';
import '../../shared/models/user_profile.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/registration_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/category_selection_screen.dart';
import '../../features/onboarding/screens/profile_selection_screen.dart';
import '../../features/onboarding/screens/phone_number_screen.dart';
import '../../features/onboarding/screens/otp_verification_screen.dart';
import '../../features/client/screens/client_dashboard_screen.dart';
import '../../features/artisan/screens/artisan_dashboard_screen.dart';
import '../../features/architecte/screens/architecte_dashboard_screen.dart';

/// Noms de routes centralisés — évite les chaînes de caractères éparpillées.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
  static const welcome = '/onboarding/welcome';
  static const categorySelection = '/onboarding/category';
  static const profileSelection = '/onboarding/profile';
  static const phoneNumber = '/onboarding/phone';
  static const otpVerification = '/onboarding/otp';

  static const registration = '/auth/registration';
  static const clientDashboard = '/client/dashboard';

  static const artisanDashboard = '/artisan/dashboard';

  static const architecteDashboard = '/architecte/dashboard';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen());

      case AppRoutes.login:
        return _page(const LoginScreen());

      case AppRoutes.register:
        return _page(const RegisterScreen());

      case AppRoutes.forgotPassword:
        return _page(const ForgotPasswordScreen());

      case AppRoutes.welcome:
        return _page(const WelcomeScreen());

      case AppRoutes.categorySelection:
        return _page(const CategorySelectionScreen());

      case AppRoutes.profileSelection:
        final category = settings.arguments as OnboardingCategory;
        return _page(ProfileSelectionScreen(category: category));

      case AppRoutes.phoneNumber:
        final profileType = settings.arguments as ProfileType;
        return _page(PhoneNumberScreen(profileType: profileType));

      case AppRoutes.otpVerification:
        final args = settings.arguments as OtpVerificationArgs;
        return _page(OtpVerificationScreen(args: args));

      case AppRoutes.registration:
        final args = settings.arguments as OtpVerificationArgs;
        return _page(RegistrationScreen(
            phone: args.phone, profileType: args.profileType));
      case AppRoutes.clientDashboard:
        return _page(const ClientDashboardScreen(), fullscreenDialog: false);

      case AppRoutes.artisanDashboard:
        return _page(const ArtisanDashboardScreen());

      case AppRoutes.architecteDashboard:
        return _page(const ArchitecteDashboardScreen());

      default:
        return _page(Scaffold(
          body: Center(child: Text('Route inconnue : ${settings.name}')),
        ));
    }
  }

  static MaterialPageRoute _page(Widget child,
      {bool fullscreenDialog = false}) {
    return MaterialPageRoute(
        builder: (_) => child, fullscreenDialog: fullscreenDialog);
  }
}

/// Les 2 catégories d'entrée pertinentes pour ce parcours (Client vs
/// Professionnel indépendant). Les 2 autres catégories du cahier des
/// charges (Fournis biens/services, Institutionnel) restent hors périmètre.
enum OnboardingCategory { seekProfessional, independentProfessional }

class OtpVerificationArgs {
  final String phone;
  final ProfileType profileType;

  const OtpVerificationArgs({required this.phone, required this.profileType});
}
