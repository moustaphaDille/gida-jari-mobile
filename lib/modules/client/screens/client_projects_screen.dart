import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gida_jari_mobile/modules/client/screens/open_projects_screen.dart';
import 'package:intl/intl.dart';

import '../../../app/routing/app_router.dart';
import '../../../core/network/api_exception.dart';
import '../models/client_project.dart';
import '../providers/client_project_provider.dart';

class ClientProjectsScreen extends ConsumerWidget {
  const ClientProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(clientProjectsProvider);
    return Scaffold(
      body: projects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: errorMessage(error),
          onRetry: () => ref.invalidate(clientProjectsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucun projet pour le moment.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(clientProjectsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _ClientProjectCard(
                project: items[index],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: () async {
              final created = await Navigator.of(context)
                  .pushNamed(AppRoutes.createProject);
              if (created == true) {
                ref.invalidate(clientProjectsProvider);
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Ajouter un projet'),
          ),
        ),
      ),
    );
  }
}

class _ClientProjectCard extends StatelessWidget {
  const _ClientProjectCard({required this.project});

  final ClientProject project;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(projectId: project.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Icon(
                    project.published
                        ? Icons.public_rounded
                        : Icons.lock_outline_rounded,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Expanded(child: Text(project.location)),
                  Text(_formatAmount(project.budgetFcfa)),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailScreen(projectId: project.id),
                    ),
                  ),
                  child: const Text('Voir le détail'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

String _formatAmount(int amount) =>
    '${NumberFormat.decimalPattern('fr_FR').format(amount)} FCFA';
