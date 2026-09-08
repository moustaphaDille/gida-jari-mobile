import 'package:flutter/material.dart';
import '../../../shared/models/user_profile.dart';

class PartnerDashboardScreen extends StatefulWidget {
  const PartnerDashboardScreen({super.key});

  @override
  State<PartnerDashboardScreen> createState() =>
      _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  int _currentIndex = 0;

  AvailabilityStatus _availability =
      AvailabilityStatus.availableNow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ═══════════════════════════════════════════════
      // APP BAR
      // ═══════════════════════════════════════════════

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour 👋',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Votre espace professionnel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor:
                  colorScheme.primaryContainer,
              child: Icon(
                Icons.person_outline_rounded,
                size: 20,
                color:
                    colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),

      // ═══════════════════════════════════════════════
      // BODY
      // ═══════════════════════════════════════════════

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            24,
          ),
          children: [

            // ─────────────────────────────────────────
            // HEADER
            // ─────────────────────────────────────────

            Text(
              'Développez votre activité\navec de nouveaux clients.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────────────────
            // DISPONIBILITÉ
            // ─────────────────────────────────────────

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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons
                                .event_available_outlined,
                            color: colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SegmentedButton<AvailabilityStatus>(
                      segments: const [
                        ButtonSegment(
                          value:
                              AvailabilityStatus.availableNow,
                          label: Text('Disponible'),
                          icon: Icon(
                            Icons.check_circle_outline,
                          ),
                        ),
                        ButtonSegment(
                          value:
                              AvailabilityStatus.availableNow,
                          label: Text('Occupé'),
                          icon: Icon(
                            Icons.schedule_rounded,
                          ),
                        ),
                        ButtonSegment(
                          value:
                              AvailabilityStatus.unavailable,
                          label: Text('Indisponible'),
                          icon: Icon(
                            Icons.block_outlined,
                          ),
                        ),
                      ],
                      selected: {
                        _availability,
                      },
                      onSelectionChanged: (selection) {
                        setState(() {
                          _availability =
                              selection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────
            // PROFIL
            // ─────────────────────────────────────────

            Card(
              elevation: 0,
              color: colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [

                    // Score
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.30,
                            strokeWidth: 6,
                            backgroundColor: colorScheme
                                .onPrimaryContainer
                                .withValues(alpha: 0.12),
                            valueColor:
                                AlwaysStoppedAnimation(
                              colorScheme.primary,
                            ),
                          ),
                          Text(
                            '30%',
                            style: theme
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.w700,
                                  color: colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Complétez votre profil',
                            style: theme
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.w700,
                                  color: colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Ajoutez vos réalisations et vos informations pour gagner en visibilité.',
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: colorScheme
                                      .onPrimaryContainer
                                      .withValues(
                                        alpha: 0.75,
                                      ),
                                  height: 1.4,
                                ),
                          ),

                          const SizedBox(height: 10),

                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding:
                                  EdgeInsets.zero,
                              minimumSize:
                                  const Size(0, 36),
                              tapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap,
                            ),
                            child: const Text(
                              'Compléter mon profil →',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ─────────────────────────────────────────
            // ACTION PRINCIPALE
            // ─────────────────────────────────────────

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'À faire maintenant',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        colorScheme.primaryContainer,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.work_outline_rounded,
                    color: colorScheme
                        .onPrimaryContainer,
                  ),
                ),

                title: Text(
                  'Découvrir les missions',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                subtitle: Text(
                  'Consultez les projets disponibles dans votre zone.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color:
                        colorScheme.onSurfaceVariant,
                  ),
                ),

                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color:
                      colorScheme.onSurfaceVariant,
                ),

                onTap: () {},
              ),
            ),

            const SizedBox(height: 28),

            // ─────────────────────────────────────────
            // MISSIONS
            // ─────────────────────────────────────────

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mes missions',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
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
                      Icons.work_outline_rounded,
                      size: 42,
                      color:
                          colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Aucune mission en cours',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Les nouvelles opportunités apparaîtront ici.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color:
                            colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Voir les opportunités',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ═══════════════════════════════════════════════
      // MATERIAL 3 NAVIGATION
      // ═══════════════════════════════════════════════

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
            selectedIcon:
                Icon(Icons.home_rounded),
            label: 'Accueil',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.work_outline_rounded,
            ),
            selectedIcon:
                Icon(Icons.work_rounded),
            label: 'Missions',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
            ),
            selectedIcon:
                Icon(
              Icons.chat_bubble_rounded,
            ),
            label: 'Messages',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon:
                Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

