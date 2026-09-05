import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/dashboard_widgets.dart';
import '../../../shared/widgets/profile_score_circle.dart';

/// Dashboard Artisan — statut de disponibilité en tête, score de profil,
/// opportunités dans la zone, jalons à soumettre (Design System V3, Profil 02).
class ArtisanDashboardScreen extends StatefulWidget {
  const ArtisanDashboardScreen({super.key});

  @override
  State<ArtisanDashboardScreen> createState() => _ArtisanDashboardScreenState();
}

class _ArtisanDashboardScreenState extends State<ArtisanDashboardScreen> {
  int _navIndex = 0;
  AvailabilityStatus _availability = AvailabilityStatus.availableNow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.artisanColor,
        foregroundColor: Colors.white,
        title: const Text('Mon espace Artisan'),
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
          // Statut de disponibilité — donnée la plus consultée par les clients
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Votre disponibilité', style: AppTextStyles.labelStrong),
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
              const ProfileScoreCircle(score: 30),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Complétez votre profil', style: AppTextStyles.labelStrong),
                    const SizedBox(height: 4),
                    Text(
                      'Ajoutez une photo et une réalisation pour doubler vos contacts.',
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
                KpiCard(icon: Icons.assignment_outlined, label: 'Missions actives', value: '0', color: AppColors.artisanColor),
                KpiCard(icon: Icons.payments_outlined, label: 'Revenus du mois', value: '0 FCFA', color: AppColors.artisanColor),
                KpiCard(icon: Icons.star_border_rounded, label: 'Note moyenne', value: '—', color: AppColors.artisanColor),
                KpiCard(icon: Icons.account_balance_wallet_outlined, label: 'Solde à recevoir', value: '0 FCFA', color: AppColors.artisanColor),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Opportunités dans ma zone'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              'Aucune opportunité pour le moment. Complétez votre profil pour être visible.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        selectedItemColor: AppColors.artisanColor,
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
