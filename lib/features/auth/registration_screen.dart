import 'package:flutter/material.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/models/user_profile.dart';

const _corpsDeMetier = [
  'Maçonnerie',
  'Plomberie',
  'Électricité',
  'Carrelage',
  'Peinture',
  'Charpente',
  'Soudure',
  'Menuiserie',
];

enum _ProjectType { construction, renovation, amenagement, autre }

enum _Specialite {
  architecte,
  ingenieurGenieCivil,
  ingenieurMep,
  ingenieurVrd,
  autre
}

class RegistrationScreen extends StatefulWidget {
  final String phone;
  final ProfileType profileType;

  const RegistrationScreen(
      {super.key, required this.phone, required this.profileType});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final Set<String> _selectedMetiers = {};
  int _step = 0;
  _ProjectType? _projectType;
  _Specialite? _specialite;
  bool _diplomeUploaded = false;
  double _amount = 5000000;

  bool get _isClient => widget.profileType == ProfileType.client;
  bool get _isArtisan => widget.profileType == ProfileType.artisan;
  Color get _accentColor => widget.profileType.color;
  String get _title => widget.profileType.label;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      return;
    }

    final dashboard = switch (widget.profileType) {
      ProfileType.client => AppRoutes.clientDashboard,
      ProfileType.artisan => AppRoutes.artisanDashboard,
      ProfileType.architecteIngenieur => AppRoutes.architecteDashboard,
    };
    Navigator.of(context).pushReplacementNamed(dashboard);
  }

  bool _canContinue() {
    switch (_step) {
      case 0:
        return _nameController.text.trim().isNotEmpty &&
            _cityController.text.trim().isNotEmpty;
      case 1:
        if (_isClient) return _projectType != null;
        if (_isArtisan) return _selectedMetiers.isNotEmpty;
        return _specialite != null;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription $_title')),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_step + 1) / 4,
            color: _accentColor,
            backgroundColor: AppColors.borderNeutral,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _identityStep(),
                _profileStep(),
                _preferencesStep(),
                _summaryStep()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _accentColor),
                onPressed: _canContinue() ? _next : null,
                child: Text(_step == 3 ? 'Créer mon profil' : 'Continuer'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepWrapper(
      {required String title, String? subtitle, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h2),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.caption),
          ],
          const SizedBox(height: AppSpacing.lg),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _identityStep() {
    return _stepWrapper(
      title:
          _isClient ? 'Faisons connaissance' : 'Votre identité professionnelle',
      child: Column(
        children: [
          TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(labelText: 'Prénom et nom')),
          const SizedBox(height: AppSpacing.md),
          TextField(
              controller: _cityController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(labelText: 'Ville / commune')),
        ],
      ),
    );
  }

  Widget _profileStep() {
    if (_isClient) return _projectTypeStep();
    if (_isArtisan) return _metierStep();
    return _specialiteStep();
  }

  Widget _projectTypeStep() {
    return _stepWrapper(
      title: 'Quel est votre projet ?',
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.3,
        children: _ProjectType.values.map((type) {
          final selected = _projectType == type;
          return _choiceTile(_projectLabel(type), selected,
              () => setState(() => _projectType = type));
        }).toList(),
      ),
    );
  }

  Widget _metierStep() {
    return _stepWrapper(
      title: 'Vos corps de métier',
      subtitle: 'Sélectionnez-en un ou plusieurs',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: _corpsDeMetier.map((metier) {
          final selected = _selectedMetiers.contains(metier);
          return FilterChip(
            label: Text(metier),
            selected: selected,
            selectedColor: AppColors.warningOrangeBg,
            checkmarkColor: _accentColor,
            onSelected: (value) => setState(() => value
                ? _selectedMetiers.add(metier)
                : _selectedMetiers.remove(metier)),
          );
        }).toList(),
      ),
    );
  }

  Widget _specialiteStep() {
    final labels = {
      _Specialite.architecte: 'Architecte',
      _Specialite.ingenieurGenieCivil: 'Ingénieur Génie Civil',
      _Specialite.ingenieurMep: 'Ingénieur MEP',
      _Specialite.ingenieurVrd: 'Ingénieur VRD',
      _Specialite.autre: 'Autre spécialité',
    };
    return _stepWrapper(
      title: 'Votre spécialité',
      child: Column(
        children: labels.entries
            .map((entry) => RadioListTile<_Specialite>(
                  value: entry.key,
                  groupValue: _specialite,
                  activeColor: _accentColor,
                  title: Text(entry.value, style: AppTextStyles.bodyLarge),
                  onChanged: (value) => setState(() => _specialite = value),
                ))
            .toList(),
      ),
    );
  }

  Widget _preferencesStep() {
    if (_isClient) {
      _amount = _amount.clamp(500000, 50000000);
      return _stepWrapper(
        title: 'Budget indicatif',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_amount.round()} FCFA',
                style: AppTextStyles.amount.copyWith(fontSize: 28)),
            Slider(
                value: _amount,
                min: 500000,
                max: 50000000,
                divisions: 99,
                activeColor: _accentColor,
                onChanged: (value) => setState(() => _amount = value)),
            Text(
                'Cette estimation nous aide à vous proposer les bons prestataires.',
                style: AppTextStyles.caption),
          ],
        ),
      );
    }
    if (_isArtisan) {
      _amount = _amount.clamp(2000, 50000);
      return _stepWrapper(
        title: 'Votre tarif journalier indicatif',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_amount.round()} FCFA / jour',
                style: AppTextStyles.amount.copyWith(fontSize: 24)),
            Slider(
                value: _amount,
                min: 2000,
                max: 50000,
                divisions: 96,
                activeColor: _accentColor,
                onChanged: (value) => setState(() => _amount = value)),
          ],
        ),
      );
    }
    return _stepWrapper(
      title: 'Diplôme ou agrément',
      subtitle:
          'Ajoutez votre document pour obtenir le badge « Diplômé Vérifié »',
      child: Center(
        child: OutlinedButton.icon(
          onPressed: () => setState(() => _diplomeUploaded = true),
          icon: Icon(_diplomeUploaded
              ? Icons.check_circle
              : Icons.upload_file_outlined),
          label: Text(
              _diplomeUploaded ? 'Document ajouté' : 'Uploader mon diplôme'),
          style: OutlinedButton.styleFrom(
              foregroundColor:
                  _diplomeUploaded ? AppColors.successGreen : _accentColor),
        ),
      ),
    );
  }

  Widget _summaryStep() {
    return _stepWrapper(
      title: 'Tout est prêt !',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow('Nom', _nameController.text),
          _summaryRow('Ville', _cityController.text),
          _summaryRow('Profil', _title),
          Text(
              'Vous pourrez compléter votre profil et ajouter vos documents depuis votre dashboard.',
              style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 90, child: Text(label, style: AppTextStyles.caption)),
        Expanded(child: Text(value, style: AppTextStyles.labelStrong))
      ]),
    );
  }

  Widget _choiceTile(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? _accentColor.withValues(alpha: 0.08) : Colors.white,
          border: Border.all(
              color: selected ? _accentColor : AppColors.borderNeutral,
              width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(child: Text(label, style: AppTextStyles.labelStrong)),
      ),
    );
  }

  String _projectLabel(_ProjectType type) {
    return switch (type) {
      _ProjectType.construction => 'Construction',
      _ProjectType.renovation => 'Rénovation',
      _ProjectType.amenagement => 'Aménagement',
      _ProjectType.autre => 'Autre',
    };
  }
}
