import 'package:flutter/material.dart';
import 'package:gida_jari_mobile/modules/onboarding/screens/otp_send_screen.dart';
import 'package:gida_jari_mobile/modules/partner/screens/entreprise_dashboard_screen.dart';
import 'package:gida_jari_mobile/modules/partner/screens/professional_dashboard_screen.dart';
import 'package:gida_jari_mobile/modules/partner/screens/partner_dashboard_screen.dart';
import '../../shared/models/user_profile.dart';
import '../../modules/auth/forgot_password_screen.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/auth/profile_selection_screen.dart';
import '../../modules/auth/registration_screen.dart';
import '../../modules/auth/complete_profile_screen.dart';
import '../../modules/auth/change_password_screen.dart';
import '../../modules/auth/profile_screen.dart';
import '../../modules/onboarding/screens/splash_screen.dart';
import '../../modules/onboarding/screens/welcome_screen.dart';
import '../../modules/onboarding/screens/otp_verification_screen.dart';
import '../../modules/client/screens/client_dashboard_screen.dart';
import '../../modules/client/screens/create_project_screen.dart';
import '../../modules/client/screens/open_projects_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
  static const completeProfile = '/auth/complete-profile';
  static const changePassword = '/auth/change-password';
  static const profile = '/auth/profile';
  static const welcome = '/onboarding/welcome';
  static const categorySelection = '/onboarding/category';
  static const profileSelection = '/onboarding/profile';
  static const contactVerification = '/onboarding/contact';
  static const otpVerification = '/onboarding/otp';
  static const registration = '/auth/registration';
  static const clientDashboard = '/client/dashboard';
  static const createProject = '/client/projects/create';
  static const openProjects = '/projects/open';
  static const projectDetails = '/projects/detail';
  static const artisanDashboard = '/artisan/dashboard';
  static const architecteDashboard = '/architecte/dashboard';
  static const professionalDashboard = '/professional/dashboard';
  static const entrepriseDashboard = '/entreprise/dashboard';

  /// Destination provisoire pour Entreprise BTP / Fournisseur / ONG en
  /// attendant leurs dashboards dédiés.
  static const partnerDashboard = '/partner/dashboard';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen());

      case AppRoutes.login:
        return _page(const LoginScreen());

      // La route garde le nom "register" (utilisé par WelcomeScreen),
      // mais ouvre maintenant l'écran de choix du profil.
      case AppRoutes.register:
        return _page(const ProfileSelectionScreen());

      case AppRoutes.forgotPassword:
        return _page(const ForgotPasswordScreen());

      case AppRoutes.completeProfile:
        return _page(const CompleteProfileScreen());

      case AppRoutes.changePassword:
        return _page(const ChangePasswordScreen());

      case AppRoutes.profile:
        return _page(const ProfileScreen());

      case AppRoutes.welcome:
        return _page(const WelcomeScreen());

      // case AppRoutes.categorySelection:
      //   return _page(const CategorySelectionScreen());

      // case AppRoutes.profileSelection:
      //   final category = settings.arguments as OnboardingCategory;
      //   return _page(ProfileSelectionScreen(category: category));

      case AppRoutes.professionalDashboard:
        return _page(const ProfessionalDashboardScreen());

      case AppRoutes.entrepriseDashboard:
        return _page(const EntrepriseDashboardScreen());

      case AppRoutes.contactVerification:
        final profileType = settings.arguments as ProfileType;
        return _page(OtpSendScreen(profileType: profileType));

      case AppRoutes.otpVerification:
        final args = settings.arguments as OtpVerificationArgs;
        return _page(OtpVerificationScreen(args: args));

      case AppRoutes.registration:
        final args = settings.arguments as OtpVerificationArgs;
        return _page(RegistrationScreen(
            phone: args.phone, profileType: args.profileType));

      case AppRoutes.clientDashboard:
        return _page(const ClientDashboardScreen());

      case AppRoutes.createProject:
        return _page(const CreateProjectScreen());

      case AppRoutes.openProjects:
        return _page(const OpenProjectsScreen());

      case AppRoutes.projectDetails:
        final projectId = settings.arguments as String;
        return _page(ProjectDetailScreen(projectId: projectId));

      // case AppRoutes.artisanDashboard:
      //   return _page(const ArtisanDashboardScreen());

      // case AppRoutes.architecteDashboard:
      //   return _page(const ArchitecteDashboardScreen());

      case AppRoutes.partnerDashboard:
        return _page(const PartnerDashboardScreen());

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

/// Placeholder en attendant les dashboards Entreprise/Fournisseur/ONG.
class _PartnerDashboardPlaceholder extends StatelessWidget {
  const _PartnerDashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Compte créé — dashboard à venir')),
    );
  }
}

enum OnboardingCategory { seekProfessional, independentProfessional }

/// Comment le code OTP est envoyé.
enum ContactMethod { phone, email }

class OtpVerificationArgs {
  /// Le numéro (+22790123456) ou l'email, selon [method].
  final String contact;
  final ContactMethod method;
  final ProfileType profileType;

  const OtpVerificationArgs({
    required this.contact,
    required this.method,
    required this.profileType,
  });

  /// TEMPORAIRE : pour que OtpVerificationScreen et RegistrationScreen
  /// compilent enapp sans les modifier. À supprimer quand ils utiliseront
  /// `contact` et `method`.
  String get phone => contact;
}
