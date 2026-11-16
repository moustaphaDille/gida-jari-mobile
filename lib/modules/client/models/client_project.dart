class ClientProject {
  const ClientProject({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.budgetFcfa,
    required this.published,
    required this.milestones,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final String location;
  final int budgetFcfa;
  final bool published;
  final List<ProjectMilestone> milestones;
  final DateTime? createdAt;

  factory ClientProject.fromJson(Map<String, dynamic> json) {
    return ClientProject(
      id: _string(json['id']),
      title: _string(json['titre']),
      description: _string(json['description']),
      type: _string(json['typeProjet']),
      location: _string(json['localisation']),
      budgetFcfa: _integer(json['budgetEstimeFcfa']),
      published: json['publie'] == true,
      milestones: (json['jalons'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ProjectMilestone.fromJson)
          .toList(),
      createdAt: DateTime.tryParse(_string(json['createdAt'])),
    );
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static int _integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse(_string(value)) ?? 0;
}

class ProjectMilestone {
  const ProjectMilestone({
    required this.label,
    required this.amountFcfa,
    this.status,
  });

  final String label;
  final int amountFcfa;
  final String? status;

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    final amount = json['montantFcfa'];
    return ProjectMilestone(
      label: json['libelle']?.toString() ?? '',
      amountFcfa: amount is num ? amount.toInt() : int.tryParse('$amount') ?? 0,
      status: json['statut']?.toString(),
    );
  }
}

class ProjectDetails {
  const ProjectDetails({required this.project, this.escrow});

  final ClientProject project;
  final Map<String, dynamic>? escrow;

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    final projectJson = json['projet'];
    return ProjectDetails(
      project: ClientProject.fromJson(
        projectJson is Map<String, dynamic> ? projectJson : json,
      ),
      escrow: json['escrow'] is Map<String, dynamic>
          ? json['escrow'] as Map<String, dynamic>
          : null,
    );
  }
}
