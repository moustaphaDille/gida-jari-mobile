import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../providers/client_project_provider.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _MilestoneFields {
  final libelle = TextEditingController();
  final montant = TextEditingController();

  void dispose() {
    libelle.dispose();
    montant.dispose();
  }
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titre = TextEditingController();
  final _description = TextEditingController();
  final _typeProjet = TextEditingController();
  final _localisation = TextEditingController();
  final _budget = TextEditingController();
  final _milestones = <_MilestoneFields>[_MilestoneFields()];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titre.dispose();
    _description.dispose();
    _typeProjet.dispose();
    _localisation.dispose();
    _budget.dispose();
    for (final milestone in _milestones) {
      milestone.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(clientProjectServiceProvider).createProject(
        titre: _titre.text.trim(),
        description: _description.text.trim(),
        typeProjet: _typeProjet.text.trim(),
        localisation: _localisation.text.trim(),
        budgetEstimeFcfa: int.parse(_budget.text.trim()),
        jalons: [
          for (final milestone in _milestones)
            {
              'libelle': milestone.libelle.text.trim(),
              'montantFcfa': int.parse(milestone.montant.text.trim()),
            },
        ],
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage(error))),
      );
      return;
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Projet créé avec succès.')),
    );
    Navigator.of(context).pop(true);
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label est requis.';
    return null;
  }

  String? _amount(String? value, String label) {
    final required = _required(value, label);
    if (required != null) return required;
    if (int.tryParse(value!.trim()) == null) {
      return '$label doit être un nombre entier.';
    }
    return null;
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType:
            maxLines > 1 ? TextInputType.multiline : keyboardType,
        textInputAction:
            maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
        decoration: InputDecoration(labelText: label),
        validator: validator ?? (value) => _required(value, label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un projet')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _textField('Titre', _titre),
            _textField('Description', _description, maxLines: 4),
            _textField('Type de projet', _typeProjet),
            _textField('Localisation', _localisation),
            _textField(
              'Budget estimé (FCFA)',
              _budget,
              keyboardType: TextInputType.number,
              validator: (value) => _amount(value, 'Le budget'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jalons',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _milestones.add(_MilestoneFields())),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var index = 0; index < _milestones.length; index++)
              _buildMilestone(index),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Créer le projet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestone(int index) {
    final milestone = _milestones[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Jalon ${index + 1}')),
                if (_milestones.length > 1)
                  IconButton(
                    tooltip: 'Supprimer le jalon',
                    onPressed: () => setState(() {
                      final removed = _milestones.removeAt(index);
                      removed.dispose();
                    }),
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            _textField('Libellé', milestone.libelle),
            _textField(
              'Montant (FCFA)',
              milestone.montant,
              keyboardType: TextInputType.number,
              validator: (value) => _amount(value, 'Le montant'),
            ),
          ],
        ),
      ),
    );
  }
}
