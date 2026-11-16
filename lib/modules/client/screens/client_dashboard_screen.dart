import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routing/app_router.dart';
import '../providers/client_project_provider.dart';
import '../../auth/settings_screen.dart';
import 'client_projects_screen.dart';

class ClientDashboardScreen extends ConsumerStatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  ConsumerState<ClientDashboardScreen> createState() =>
      _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends ConsumerState<ClientDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: _currentIndex == 3
          ? null
          : AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                    ),
            ),
            Text(
              'Bienvenue sur votre espace',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.createProject),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person_outline_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHome(),
            const ClientProjectsScreen(),
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
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder_rounded),
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

  Widget _buildHome() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    'Trouvez le bon professionnel\npour votre projet.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─────────────────────────────────────
                  // MAIN ACTION
                  // ─────────────────────────────────────
                  Card(
                    elevation: 0,
                    color: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.add_home_work_outlined,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Vous avez un projet ?',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Décrivez votre besoin et recevez des propositions de professionnels.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.75),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _openCreateProject,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Créer un projet'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─────────────────────────────────────
                  // QUICK ACTIONS
                  // ─────────────────────────────────────
                  Text(
                    'Actions rapides',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.search_rounded,
                          title: 'Trouver un artisan',
                          onTap: () => setState(() {
                            _currentIndex = 1;
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.folder_outlined,
                          title: 'Mes projets',
                          onTap: () => setState(() {
                            _currentIndex = 1;
                          }),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ─────────────────────────────────────
                  // PROJECTS
                  // ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mes projets',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Voir tout'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 42,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun projet pour le moment',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Créez votre premier projet pour commencer.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
  }

  Widget _buildMessages() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Messages',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vos échanges avec les professionnels apparaîtront ici.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateProject() async {
    final created =
        await Navigator.of(context).pushNamed(AppRoutes.createProject);
    if (created == true) {
      ref.invalidate(clientProjectsProvider);
    }
  }

}

class _EmptyProjectsCard extends StatelessWidget {
  const _EmptyProjectsCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Column(
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 42,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun projet pour le moment',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// ACTION CARD
// ═══════════════════════════════════════════════

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
