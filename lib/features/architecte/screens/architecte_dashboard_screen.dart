import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/dashboard_widgets.dart';
import '../../../shared/widgets/profile_score_circle.dart';

/// Dashboard Architecte/Ingénieur — missions actives, honoraires en attente,
/// portfolio, demandes de devis (Design System V3, Profil 05).
class ArchitecteDashboardScreen extends StatefulWidget {
  const ArchitecteDashboardScreen({super.key});

  @override
  State<ArchitecteDashboardScreen> createState() => _ArchitecteDashboardScreenState();
}

class _ArchitecteDashboardScreenState extends State<ArchitecteDashboardScreen> {
  int _navIndex = 0;
  AvailabilityStatus _availability = AvailabilityStatus.availableNow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.architecteColor,
        foregroundColor: Colors.white,
        title: const Text('Mon espace Professionnel'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Votre disponibilité', style: AppTextStyles.labelStrong),
                const SizedBox(height: AppSpacing.sm),
                AvailabilitySelector(
                  current: _availability,
                  onChanged: (v) => setState(() => _availability = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileScoreCircle(score: 25),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Complétez votre profil', style: AppTextStyles.labelStrong),
                    const SizedBox(height: 4),
                    const Text(
                      'Ajoutez votre diplôme et un projet pour débloquer le badge Diplômé Vérifié.',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(onPressed: () {}, child: const Text('Compléter maintenant')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                KpiCard(icon: Icons.assignment_outlined, label: 'Missions actives', value: '0', color: AppColors.architecteColor),
                KpiCard(icon: Icons.payments_outlined, label: 'Honoraires du mois', value: '0 FCFA', color: AppColors.architecteColor),
                KpiCard(icon: Icons.mail_outline_rounded, label: 'Demandes reçues', value: '0', color: AppColors.architecteColor),
                KpiCard(icon: Icons.account_balance_wallet_outlined, label: 'Solde wallet', value: '0 FCFA', color: AppColors.architecteColor),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Portfolio'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Text(
              'Votre portfolio est vide. Ajoutez vos premières réalisations.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        selectedItemColor: AppColors.architecteColor,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline_rounded), label: 'Missions'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
