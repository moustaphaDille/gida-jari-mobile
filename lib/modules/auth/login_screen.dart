import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../core/network/api_exception.dart';
import '../../../shared/models/user_profile.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    if (identifier.isEmpty || password.isEmpty) {
      _showError('Renseignez votre identifiant et votre mot de passe.');
      return;
    }

    setState(() => _isLoading = true);

    await ref.read(loginProvider.notifier).login(
          email: identifier.contains('@') ? identifier : null,
          phone: identifier.contains('@') ? null : identifier,
          password: password,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    final result = ref.read(loginProvider);
    if (result.hasError) {
      _showError(errorMessage(result.error!));
      return;
    }

    final auth = result.value;
    if (auth == null) return;

    final route = switch (auth.profileType) {
      ProfileType.client => AppRoutes.clientDashboard,
      ProfileType.entrepriseBtp => AppRoutes.entrepriseDashboard,
      ProfileType.artisan ||
      ProfileType.architecteIngenieur ||
      ProfileType.fournisseurMateriaux ||
      ProfileType.ongInstitution =>
        AppRoutes.professionalDashboard,
    };

    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // hasScrollBody: false => le contenu prend toute la hauteur de
            // l'écran (donc Center peut le centrer), et ça scrolle seulement
            // si le clavier ou un petit écran manque de place.
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildForm(),
                        const SizedBox(height: AppSpacing.md),
                        _buildRegisterLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            'assets/gida-jari.jpeg',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Connexion',
          style: AppTextStyles.h2.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _identifierController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            autofillHints: const [AutofillHints.username],
            decoration: InputDecoration(
              labelText: 'Email ou téléphone',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              enabledBorder: _border(AppColors.borderNeutral, 1),
              focusedBorder: _border(AppColors.primaryBlue, 2),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) {
              if (!_isLoading) _submit();
            },
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscurePassword
                    ? 'Afficher le mot de passe'
                    : 'Masquer le mot de passe',
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              enabledBorder: _border(AppColors.borderNeutral, 1),
              focusedBorder: _border(AppColors.primaryBlue, 2),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
              child: const Text('Mot de passe oublié ?'),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Se connecter',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Nouveau sur Gida Jari ?',
          style: AppTextStyles.bodyRegular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.successGreen,
          ),
          child: const Text(
            'Créer un compte',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../app/routing/app_router.dart';
// import '../../../app/theme/app_colors.dart';
// import '../../../app/theme/app_text_styles.dart';
// import '../../../app/theme/app_theme.dart';
// import '../../../shared/widgets/gj_auth_scaffold.dart';
// import '../../../features/auth/providers/auth_providers.dart';
// import '../../../core/network/api_exception.dart';
// import '../../../shared/models/user_profile.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _identifierController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   Future<void> _submit() async {
//     FocusScope.of(context).unfocus();

//     final identifier = _identifierController.text.trim();
//     final password = _passwordController.text;
//     if (identifier.isEmpty || password.isEmpty) {
//       _showError('Renseignez votre identifiant et votre mot de passe.');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     await ref.read(loginProvider.notifier).login(
//           email: identifier.contains('@') ? identifier : null,
//           phone: identifier.contains('@') ? null : identifier,
//           password: password,
//         );

//     if (!mounted) return;

//     setState(() {
//       _isLoading = false;
//     });

//     final result = ref.read(loginProvider);
//     if (result.hasError) {
//       _showError(errorMessage(result.error!));
//       return;
//     }

//     final auth = result.value;
//     if (auth == null) return;
//     final route = switch (auth.profileType) {
//       ProfileType.client => AppRoutes.clientDashboard,
//       ProfileType.entrepriseBtp => AppRoutes.entrepriseDashboard,
//       ProfileType.artisan ||
//       ProfileType.architecteIngenieur ||
//       ProfileType.fournisseurMateriaux ||
//       ProfileType.ongInstitution =>
//         AppRoutes.professionalDashboard,
//     };
//     if (mounted) {
//       Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   void dispose() {
//     _identifierController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GjAuthScaffold(
//       showBrandHeader: false,
//       child: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(
//             vertical: AppSpacing.lg,
//           ),
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 430,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildBrand(),
//                 const SizedBox(height: AppSpacing.xl),
//                 _buildWelcome(),
//                 const SizedBox(height: AppSpacing.xl),
//                 _buildLoginForm(),
//                 const SizedBox(height: AppSpacing.lg),
//                 _buildRegisterLink(),
//                 const SizedBox(height: AppSpacing.lg),
//                 _buildSecurityInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBrand() {
//     return Column(
//       children: [
//         Container(
//           width: 88,
//           height: 88,
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(26),
//             border: Border.all(
//               color: AppColors.primaryBlue.withValues(
//                 alpha: 0.10,
//               ),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.primaryBlue.withValues(
//                   alpha: 0.10,
//                 ),
//                 blurRadius: 24,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(21),
//             child: Image.asset(
//               'assets/gida-jari.jpeg',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: AppSpacing.sm),
//         Text(
//           'GIDA JARI',
//           style: AppTextStyles.labelStrong.copyWith(
//             color: AppColors.primaryBlue,
//             fontSize: 14,
//             letterSpacing: 1.5,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWelcome() {
//     return Column(
//       children: [
//         const Text(
//           'Bon retour parmi nous',
//           textAlign: TextAlign.center,
//           style: AppTextStyles.h2,
//         ),
//         const SizedBox(height: AppSpacing.sm),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSpacing.md,
//           ),
//           child: Text(
//             'Connectez-vous pour retrouver votre espace '
//             'et suivre vos projets.',
//             textAlign: TextAlign.center,
//             style: AppTextStyles.bodyRegular.copyWith(
//               color: AppColors.textSecondary,
//               height: 1.45,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLoginForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         _buildFieldLabel('Email ou numéro de téléphone'),
//         const SizedBox(height: 7),
//         TextField(
//           controller: _identifierController,
//           keyboardType: TextInputType.emailAddress,
//           textInputAction: TextInputAction.next,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(
//               Icons.person_outline_rounded,
//             ),
//             hintText: 'Email ou numéro de téléphone',
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(
//                 AppRadius.md,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: AppSpacing.md),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Mot de passe',
//               style: AppTextStyles.caption,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(
//                   AppRoutes.forgotPassword,
//                 );
//               },
//               child: Text(
//                 'Mot de passe oublié ?',
//                 style: AppTextStyles.caption.copyWith(
//                   color: AppColors.primaryBlue,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 7),
//         TextField(
//           controller: _passwordController,
//           obscureText: _obscurePassword,
//           textInputAction: TextInputAction.done,
//           onSubmitted: (_) {
//             if (!_isLoading) {
//               _submit();
//             }
//           },
//           decoration: InputDecoration(
//             prefixIcon: const Icon(
//               Icons.lock_outline_rounded,
//             ),
//             suffixIcon: IconButton(
//               tooltip: _obscurePassword
//                   ? 'Afficher le mot de passe'
//                   : 'Masquer le mot de passe',
//               icon: Icon(
//                 _obscurePassword
//                     ? Icons.visibility_outlined
//                     : Icons.visibility_off_outlined,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             ),
//             hintText: 'Votre mot de passe',
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(
//                 AppRadius.md,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: AppSpacing.lg),
//         SizedBox(
//           height: 54,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryBlue,
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: AppColors.primaryBlue.withValues(
//                 alpha: 0.55,
//               ),
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(
//                   AppRadius.md,
//                 ),
//               ),
//             ),
//             onPressed: _isLoading ? null : _submit,
//             child: AnimatedSwitcher(
//               duration: const Duration(
//                 milliseconds: 180,
//               ),
//               child: _isLoading
//                   ? const SizedBox(
//                       key: ValueKey('loading'),
//                       width: 21,
//                       height: 21,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : const Row(
//                       key: ValueKey('login'),
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Se connecter',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Icon(
//                           Icons.arrow_forward_rounded,
//                           size: 20,
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFieldLabel(String label) {
//     return Text(
//       label,
//       style: AppTextStyles.caption.copyWith(
//         fontWeight: FontWeight.w600,
//         color: AppColors.textPrimary,
//       ),
//     );
//   }

//   Widget _buildRegisterLink() {
//     return Center(
//       child: RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(
//           style: AppTextStyles.bodyRegular.copyWith(
//             color: AppColors.textSecondary,
//           ),
//           children: [
//             const TextSpan(
//               text: 'Nouveau sur Gida Jari ? ',
//             ),
//             TextSpan(
//               text: 'Créer un compte',
//               style: const TextStyle(
//                 color: AppColors.successGreen,
//                 fontWeight: FontWeight.w700,
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   Navigator.of(context).pushNamed(
//                     AppRoutes.register,
//                   );
//                 },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSecurityInfo() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppSpacing.md,
//         vertical: AppSpacing.sm,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.primaryBlue.withValues(
//           alpha: 0.05,
//         ),
//         borderRadius: BorderRadius.circular(
//           AppRadius.md,
//         ),
//         border: Border.all(
//           color: AppColors.primaryBlue.withValues(
//             alpha: 0.08,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: AppColors.successGreen.withValues(
//                 alpha: 0.10,
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.lock_outline_rounded,
//               size: 17,
//               color: AppColors.successGreen,
//             ),
//           ),
//           const SizedBox(width: AppSpacing.sm),
//           Expanded(
//             child: Text(
//               'Vos informations sont protégées et sécurisées.',
//               style: AppTextStyles.caption.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
