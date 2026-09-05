import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/dashboard_widgets.dart';

/// Dashboard Client — cf. Design System V3, Section 8, Profil 01.
/// KPIs : projets actifs, paiements en attente, messages, solde wallet.
class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonjour 👋'),
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
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                KpiCard(icon: Icons.home_work_outlined, label: 'Projets actifs', value: '1'),
                KpiCard(icon: Icons.payments_outlined, label: 'Paiements en attente', value: '0'),
                KpiCard(icon: Icons.chat_bubble_outline, label: 'Messages', value: '0'),
                KpiCard(icon: Icons.account_balance_wallet_outlined, label: 'Solde wallet', value: '0 FCFA'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Actions rapides'),
          Row(
            children: [
              QuickActionButton(
                icon: Icons.search_rounded,
                label: 'Trouver un artisan',
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.sm),
              QuickActionButton(
                icon: Icons.add_circle_outline,
                label: 'Nouveau projet',
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.sm),
              QuickActionButton(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Mon wallet',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Mes chantiers'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                Icon(Icons.home_work_outlined, size: 40, color: AppColors.textSecondary),
                const SizedBox(height: AppSpacing.sm),
                Text('Votre prochain chantier commence ici', style: AppTextStyles.labelStrong),
                const SizedBox(height: 4),
                Text(
                  'Publiez un projet pour recevoir des devis de prestataires vérifiés.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_open_rounded), label: 'Projets'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
