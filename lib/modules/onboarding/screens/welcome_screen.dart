import 'package:flutter/material.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';

class _AppLanguage {
  final String code;
  final String label;
  const _AppLanguage(this.code, this.label);
}

const _languages = [
  _AppLanguage('FR', 'Français'),
  _AppLanguage('HA', 'Hausa'),
];

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  _AppLanguage _selectedLanguage = _languages.first;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLanguageSelected(_AppLanguage language) {
    setState(() => _selectedLanguage = language);
    // TODO: brancher ici ton vrai changement de langue
    // (provider Riverpod, Locale, etc.)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                /// Sélecteur de langue (en haut à droite)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _LanguageSelector(
                      selected: _selectedLanguage,
                      onSelected: _onLanguageSelected,
                    ),
                  ),
                ),

                /// Contenu central
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: _buildContent(),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Boutons en bas
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: _buildActions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/gida-jari.jpeg',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 28),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.h1.copyWith(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
            children: const [
              TextSpan(
                text: 'Bienvenue chez\n',
                style: TextStyle(color: Colors.black87),
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
        const SizedBox(height: 12),
        Text(
          'La Maison de Demain',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.successGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Trouvez facilement les meilleurs professionnels du bâtiment '
          'pour concrétiser vos projets.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyRegular.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Action principale
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.register),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: shape,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Commencer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        /// Action secondaire
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.login,
              arguments: ProfileType.client,
            ),
            icon: const Icon(Icons.login_rounded, size: 20),
            label: const Text(
              "J'ai déjà un compte",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              side: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.2,
              ),
              shape: shape,
            ),
          ),
        ),
      ],
    );
  }
}

/// Petit menu déroulant pour la langue
class _LanguageSelector extends StatelessWidget {
  final _AppLanguage selected;
  final ValueChanged<_AppLanguage> onSelected;

  const _LanguageSelector({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AppLanguage>(
      onSelected: onSelected,
      tooltip: 'Langue',
      offset: const Offset(0, 44),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) => _languages.map((lang) {
        final isSelected = lang.code == selected.code;
        return PopupMenuItem<_AppLanguage>(
          value: lang,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  lang.label,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: AppColors.primaryBlue,
                ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFD5DAE5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              size: 18,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 6),
            Text(
              selected.code,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}