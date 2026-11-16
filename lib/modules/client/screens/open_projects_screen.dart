import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_exception.dart';
import '../models/client_project.dart';
import '../providers/client_project_provider.dart';

class OpenProjectsScreen extends StatelessWidget {
  const OpenProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _ProjectsAppBar(),
      body: OpenProjectsView(),
    );
  }
}

class OpenProjectsView extends ConsumerWidget {
  const OpenProjectsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(openProjectsProvider);
    return projects.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorView(
        message: errorMessage(error),
        onRetry: () => ref.invalidate(openProjectsProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Aucun projet ouvert pour le moment.'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(openProjectsProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) => _ProjectCard(project: items[index]),
          ),
        );
      },
    );
  }
}

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(projectDetailsProvider(projectId));
    return Scaffold(
      appBar: AppBar(title: const Text('Détail du projet')),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: errorMessage(error),
          onRetry: () => ref.invalidate(projectDetailsProvider(projectId)),
        ),
        data: (value) => _ProjectDetails(project: value.project),
      ),
    );
  }
}

class _ProjectDetails extends StatelessWidget {
  const _ProjectDetails({required this.project});

  final ClientProject project;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          project.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(project.description),
        const SizedBox(height: 20),
        _InfoTile(
          icon: Icons.category_outlined,
          label: 'Type',
          value: project.type,
        ),
        _InfoTile(
          icon: Icons.location_on_outlined,
          label: 'Localisation',
          value: project.location,
        ),
        _InfoTile(
          icon: Icons.payments_outlined,
          label: 'Budget estimé',
          value: _formatAmount(project.budgetFcfa),
        ),
        if (project.milestones.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Jalons',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          for (final milestone in project.milestones)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.flag_outlined),
              title: Text(milestone.label),
              subtitle: milestone.status == null ? null : Text(milestone.status!),
              trailing: Text(_formatAmount(milestone.amountFcfa)),
            ),
        ],
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

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
              Text(
                project.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

class _ProjectsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProjectsAppBar();

  @override
  Widget build(BuildContext context) => AppBar(title: const Text('Projets ouverts'));

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
