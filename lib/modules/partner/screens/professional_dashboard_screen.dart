import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routing/app_router.dart';
import '../../auth/settings_screen.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/settings_view.dart';
import '../../client/screens/open_projects_screen.dart';

class ProfessionalDashboardScreen extends ConsumerStatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  ConsumerState<ProfessionalDashboardScreen> createState() =>
      _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState
    extends ConsumerState<ProfessionalDashboardScreen> {
  int _currentIndex = 0;
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHome(),
            const OpenProjectsView(),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Missions',
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
                _buildAvailabilityCard(),
                const SizedBox(height: AppSpacing.lg),
                _buildProfileScore(),
                const SizedBox(height: AppSpacing.lg),
                _buildStatistics(),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionHeader(
                  title: 'Opportunités près de vous',
                  action: 'Voir tout',
                  onPressed: () => setState(() => _currentIndex = 1),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildMissionCard(
                  icon: Icons.home_work_outlined,
                  title: 'Construction d’une villa',
                  location: 'Niamey • Yantala',
                  budget: '250 000 FCFA',
                  category: 'Maçonnerie',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildMissionCard(
                  icon: Icons.handyman_outlined,
                  title: 'Rénovation d’une maison',
                  location: 'Niamey • Plateau',
                  budget: '150 000 FCFA',
                  category: 'Rénovation',
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionHeader(
                  title: 'Votre activité',
                  action: 'Voir le profil',
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildActivityCard(),
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
            color: AppColors.primaryBlue.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, Moussa 👋',
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 2),
              Text(
                'Professionnel indépendant',
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
  // DISPONIBILITÉ
  // ===========================================================================

  Widget _buildAvailabilityCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _isAvailable
            ? AppColors.successGreen.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: _isAvailable
              ? AppColors.successGreen.withValues(alpha: 0.25)
              : Colors.grey.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _isAvailable
                  ? AppColors.successGreen.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              _isAvailable
                  ? Icons.check_circle_outline_rounded
                  : Icons.pause_circle_outline_rounded,
              color: _isAvailable
                  ? AppColors.successGreen
                  : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Votre disponibilité',
                  style: AppTextStyles.labelStrong,
                ),
                SizedBox(height: 3),
                Text(
                  'Les clients peuvent vous contacter',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SCORE PROFIL
  // ===========================================================================

  Widget _buildProfileScore() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.85,
                  strokeWidth: 7,
                  backgroundColor:
                      AppColors.primaryBlue.withValues(alpha: 0.10),
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.primaryBlue,
                  ),
                ),
                const Text(
                  '85%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil complété à 85 %',
                  style: AppTextStyles.labelStrong,
                ),
                SizedBox(height: 4),
                Text(
                  'Ajoutez vos réalisations pour améliorer votre visibilité auprès des clients.',
                  style: AppTextStyles.caption,
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
  // STATISTIQUES
  // ===========================================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.assignment_rounded,
            value: '12',
            label: 'Missions',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            value: '4.8',
            label: 'Note',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            value: '28',
            label: 'Terminées',
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MISSIONS
  // ===========================================================================

  Widget _buildMissions() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const Text(
                  'Missions',
                  style: AppTextStyles.h1,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Découvrez les opportunités adaptées à votre activité.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterChips(),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 190,
                  child: OpenProjectsView(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Toutes',
            selected: true,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'À proximité',
            selected: false,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Récentes',
            selected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard({
    required IconData icon,
    required String title,
    required String location,
    required String budget,
    required String category,
  }) {
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
                  color: AppColors.primaryBlue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
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
                  ],
                ),
              ),
              Text(
                budget,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Voir'),
              ),
            ],
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
          message: 'Bonjour, êtes-vous disponible pour...',
          time: '10:32',
          unread: true,
        ),
        _buildMessageTile(
          name: 'Mariam Construction',
          message: 'Merci pour votre devis.',
          time: 'Hier',
          unread: false,
        ),
        _buildMessageTile(
          name: 'Issoufou',
          message: 'Pouvez-vous passer demain ?',
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
  // PROFIL
  // ===========================================================================

  Widget _buildProfile() {
    return SettingsView(
      onViewProfile: () => Navigator.of(context).pushNamed(AppRoutes.profile),
      onCompleteProfile: () =>
          Navigator.of(context).pushNamed(AppRoutes.completeProfile),
      onChangePassword: () =>
          Navigator.of(context).pushNamed(AppRoutes.changePassword),
    );
  }

  // ===========================================================================
  // ACTIVITÉ
  // ===========================================================================

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: const Column(
        children: [
          _ActivityRow(
            icon: Icons.check_circle_outline_rounded,
            title: 'Mission terminée',
            subtitle: 'Rénovation maison',
            time: 'Aujourd’hui',
          ),
          Divider(),
          _ActivityRow(
            icon: Icons.star_outline_rounded,
            title: 'Nouvel avis reçu',
            subtitle: '5 étoiles',
            time: 'Hier',
          ),
          Divider(),
          _ActivityRow(
            icon: Icons.assignment_outlined,
            title: 'Nouvelle opportunité',
            subtitle: 'Construction villa',
            time: 'Hier',
          ),
        ],
      ),
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
// STAT CARD
// =============================================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 22,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// FILTER CHIP
// =============================================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryBlue.withValues(alpha: 0.12),
      checkmarkColor: AppColors.primaryBlue,
    );
  }
}

// =============================================================================
// PROFILE MENU
// =============================================================================

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
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
          color: AppColors.primaryBlue,
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

// =============================================================================
// ACTIVITY ROW
// =============================================================================

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.successGreen,
          size: 24,
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
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        Text(
          time,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}