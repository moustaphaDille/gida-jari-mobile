import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';
import '../../core/network/api_exception.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../shared/models/user_profile.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  final Map<String, TextEditingController> _controllers = {};

  static const _fields = <ProfileType, List<String>>{
    ProfileType.client: ['nom', 'prenom', 'adresse', 'typeClient'],
    ProfileType.artisan: [
      'nom',
      'prenom',
      'corpsDeMetier',
      'zoneIntervention',
      'tarifJournalierFcfa',
      'disponibilite',
      'badge',
    ],
    ProfileType.architecteIngenieur: [
      'nom',
      'prenom',
      'specialite',
      'numeroOrdre',
      'agrementMinisteriel',
      'grilleTarifaireJson',
    ],
    ProfileType.entrepriseBtp: [
      'nomCommercial',
      'nif',
      'rccm',
      'domaineActivite',
      'effectif',
    ],
    ProfileType.fournisseurMateriaux: [
      'nomBoutique',
      'nif',
      'categories',
      'zonesLivraison',
      'fraisLivraisonFcfa',
    ],
    ProfileType.ongInstitution: [
      'raisonSociale',
      'nifOuRccm',
      'typeOrganisation',
      'statutLegal',
      'oddCible',
      'logoUrl',
    ],
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _label(String value) {
    return value
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}')
        .replaceAll('Fcfa', 'FCFA')
        .replaceFirst(value[0], value[0].toUpperCase());
  }

  Future<void> _submit(ProfileType type) async {
    final body = <String, dynamic>{};
    for (final field in _fields[type] ?? const []) {
      final value = _controllers[field]?.text.trim() ?? '';
      if (value.isEmpty) continue;
      body[field] = switch (field) {
        'effectif' ||
        'tarifJournalierFcfa' ||
        'fraisLivraisonFcfa' =>
          int.tryParse(value),
        _ => value,
      };
    }
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Renseignez au moins un champ.')),
      );
      return;
    }

    await ref.read(currentProfileProvider.notifier).complete(
          profileType: type,
          body: body,
        );
    if (!mounted) return;
    final result = ref.read(currentProfileProvider);
    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage(result.error!))),
      );
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Compléter mon profil')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(errorMessage(error))),
        data: (data) {
          final type = data.profileType;
          if (type == null) {
            return const Center(child: Text('Type de profil inconnu.'));
          }
          final fields = _fields[type] ?? const <String>[];
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                'Ajoutez les informations de votre compte.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final field in fields) ...[
                TextField(
                  controller: _controllers.putIfAbsent(
                    field,
                    () => TextEditingController(
                      text: data.values[field]?.toString() ?? '',
                    ),
                  ),
                  keyboardType: field.contains('Fcfa') || field == 'effectif'
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(labelText: _label(field)),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              ElevatedButton(
                onPressed: profile.isLoading ? null : () => _submit(type),
                child: profile.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Enregistrer mon profil'),
              ),
            ],
          );
        },
      ),
    );
  }
}
