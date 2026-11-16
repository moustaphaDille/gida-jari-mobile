import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/settings_view.dart';
import '../../auth/settings_screen.dart';

class EntrepriseDashboardScreen extends ConsumerStatefulWidget {
  const EntrepriseDashboardScreen({super.key});

  @override
  ConsumerState<EntrepriseDashboardScreen> createState() =>
      _EntrepriseDashboardScreenState();
}

class _EntrepriseDashboardScreenState
    extends ConsumerState<EntrepriseDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHome(),
            _buildProjects(),
            _buildMessages(),
            const SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_center_outlined),
            selectedIcon: Icon(Icons.business_center_rounded),
            label: 'Projets',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACCUEIL
  // ===========================================================================

  Widget _buildHome() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildHeader(),
                const SizedBox(height: AppSpacing.lg),
                _buildVerificationCard(),
                const SizedBox(height: AppSpacing.lg),
                _buildStatistics(),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionHeader(
                  title: 'Mes projets',
                  action: 'Voir tout',
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildProjectCard(
                  title: 'Construction d’une villa',
                  client: 'Client : Abdou Ibrahim',
                  progress: 0.65,
                  status: 'En cours',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildProjectCard(
                  title: 'Rénovation de bureau',
                  client: 'Client : Entreprise ABC',
                  progress: 0.30,
                  status: 'En cours',
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionHeader(
                  title: 'Demandes récentes',
                  action: 'Voir tout',
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildRequestCard(
                  title: 'Construction maison',
                  location: 'Niamey • Lazaret',
                  budget: 'À négocier',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildRequestCard(
                  title: 'Travaux de rénovation',
                  location: 'Niamey • Plateau',
                  budget: '500 000 FCFA',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.technicalPurple.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Icon(
            Icons.business_rounded,
            color: AppColors.technicalPurple,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BTP Niger SARL',
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 2),
              Text(
                'Entreprise BTP',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  // ===========================================================================
  // VÉRIFICATION
  // ===========================================================================

  Widget _buildVerificationCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.successGreen.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: AppColors.successGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entreprise en cours de vérification',
                  style: AppTextStyles.labelStrong,
                ),
                SizedBox(height: 3),
                Text(
                  'Complétez vos documents pour obtenir le badge vérifié.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.successGreen,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STATISTIQUES
  // ===========================================================================

  Widget _buildStatistics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CompanyStatCard(
                icon: Icons.business_center_outlined,
                value: '4',
                label: 'Projets actifs',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _CompanyStatCard(
                icon: Icons.request_quote_outlined,
                value: '12',
                label: 'Demandes',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _CompanyStatCard(
                icon: Icons.description_outlined,
                value: '5',
                label: 'Devis en attente',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _CompanyStatCard(
                icon: Icons.check_circle_outline_rounded,
                value: '28',
                label: 'Projets terminés',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // PROJETS
  // ===========================================================================

  Widget _buildProjects() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes projets',
                    style: AppTextStyles.h1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Suivez l’avancement de vos projets.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: AppColors.primaryBlue,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildProjectCard(
          title: 'Construction d’une villa',
          client: 'Client : Abdou Ibrahim',
          progress: 0.65,
          status: 'En cours',
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildProjectCard(
          title: 'Rénovation de bureau',
          client: 'Client : Entreprise ABC',
          progress: 0.30,
          status: 'En cours',
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildProjectCard(
          title: 'Construction clôture',
          client: 'Client : Mariam',
          progress: 1.0,
          status: 'Terminé',
        ),
      ],
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String client,
    required double progress,
    required String status,
  }) {
    final isCompleted = progress >= 1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.technicalPurple.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.construction_outlined,
                  color: AppColors.technicalPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelStrong,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      client,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.successGreen.withValues(alpha: 0.10)
                      : AppColors.primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? AppColors.successGreen
                        : AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Text(
                'Avancement',
                style: AppTextStyles.caption,
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation(
                isCompleted ? AppColors.successGreen : AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Voir le projet'),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // DEMANDES
  // ===========================================================================

  Widget _buildRequestCard({
    required String title,
    required String location,
    required String budget,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelStrong,
                ),
                const SizedBox(height: 3),
                Text(
                  location,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 3),
                Text(
                  budget,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MESSAGES
  // ===========================================================================

  Widget _buildMessages() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Text(
          'Messages',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildMessageTile(
          name: 'Abdou Ibrahim',
          message: 'Bonjour, je voudrais un devis.',
          time: '10:32',
          unread: true,
        ),
        _buildMessageTile(
          name: 'Mariam',
          message: 'Le chantier peut commencer lundi.',
          time: 'Hier',
          unread: false,
        ),
        _buildMessageTile(
          name: 'Issoufou',
          message: 'Avez-vous reçu les documents ?',
          time: 'Lun.',
          unread: false,
        ),
      ],
    );
  }

  Widget _buildMessageTile({
    required String name,
    required String message,
    required String time,
    required bool unread,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.10),
        child: const Icon(
          Icons.person_outline_rounded,
          color: AppColors.primaryBlue,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: AppTextStyles.caption,
          ),
          if (unread) ...[
            const SizedBox(height: 5),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // PROFIL ENTREPRISE
  // ===========================================================================

  Widget _buildCompanyProfile() {
    return SettingsView(
      onViewProfile: () => Navigator.of(context).pushNamed(AppRoutes.profile),
      onCompleteProfile: () =>
          Navigator.of(context).pushNamed(AppRoutes.completeProfile),
      onChangePassword: () =>
          Navigator.of(context).pushNamed(AppRoutes.changePassword),
    );
  }

  // ===========================================================================
  // SECTION HEADER
  // ===========================================================================

  Widget _buildSectionHeader({
    required String title,
    required String action,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h2,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(action),
        ),
      ],
    );
  }
}

// =============================================================================
// STAT CARD ENTREPRISE
// =============================================================================

class _CompanyStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _CompanyStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.technicalPurple.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              icon,
              size: 21,
              color: AppColors.technicalPurple,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// MENU ENTREPRISE
// =============================================================================

class _CompanyMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CompanyMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.technicalPurple,
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
