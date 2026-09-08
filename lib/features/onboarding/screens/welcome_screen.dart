import 'package:flutter/material.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F8FF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              /// Background Decorations
              Positioned(
                top: -120,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withValues(alpha: .06),
                  ),
                ),
              ),

              Positioned(
                bottom: -100,
                left: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.successGreen.withValues(alpha: .08),
                  ),
                ),
              ),

              /// Top Indicator
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 6,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 6,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      40,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          /// Image
                          Container(
                            width: 200,
                            height: 200,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue
                                      .withOpacity(.15),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/gida-jari.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Title
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.h1.copyWith(
                                fontSize: 34,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Bienvenue chez\n',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: 'GIDA JARI',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            'La Maison de Demain',
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'Trouvez facilement les meilleurs professionnels du bâtiment pour concrétiser vos projets de construction, rénovation et aménagement.',
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.7,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 50),

                          /// Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.register,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                              ),
                              label: const Text(
                                "Commencer",
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                shadowColor: AppColors.primaryBlue
                                    .withOpacity(.35),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.login,
                                  arguments:
                                      ProfileType.client,
                                );
                              },
                              icon: const Icon(
                                Icons.login_rounded,
                              ),
                              label: const Text(
                                "Se connecter",
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.primaryBlue
                                      .withValues(alpha: .30),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: .04),
                                  blurRadius: 12,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.successGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Une expérience simple, rapide et fiable pour tous vos projets BTP.',
                                    textAlign:
                                        TextAlign.center,
                                    style: AppTextStyles.caption
                                        .copyWith(
                                      color: AppColors
                                          .textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}