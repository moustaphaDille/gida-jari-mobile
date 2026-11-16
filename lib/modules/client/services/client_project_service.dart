import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/client_project.dart';

class ClientProjectService {
  ClientProjectService(this._api);

  final ApiClient _api;

  Future<List<ClientProject>> getOpenProjects() async {
    final projects = await _api.getList(ApiEndpoints.openProjects, auth: true);
    return projects
        .whereType<Map<String, dynamic>>()
        .map(ClientProject.fromJson)
        .toList();
  }

  Future<List<ClientProject>> getClientProjects() async {
    final items =
        await _api.getList(ApiEndpoints.clientProjects, auth: true);
    return items
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final project = item['projet'];
          return project is Map<String, dynamic>
              ? ClientProject.fromJson(project)
              : ClientProject.fromJson(item);
        })
        .toList();
  }

  Future<ProjectDetails> getProjectDetails(String projectId) async {
    final json = await _api.get(ApiEndpoints.project(projectId), auth: true);
    return ProjectDetails.fromJson(json);
  }

  Future<Map<String, dynamic>> createProject({
    required String titre,
    required String description,
    required String typeProjet,
    required String localisation,
    required int budgetEstimeFcfa,
    required List<Map<String, dynamic>> jalons,
  }) {
    return _api.post(
      ApiEndpoints.clientProjects,
      auth: true,
      body: {
        'titre': titre,
        'description': description,
        'typeProjet': typeProjet,
        'localisation': localisation,
        'budgetEstimeFcfa': budgetEstimeFcfa,
        'jalons': jalons,
      },
    );
  }

  Future<Map<String, dynamic>> publishProject(String projectId) {
    final normalizedId = projectId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(projectId, 'projectId', 'ne peut pas être vide');
    }

    return _api.post(
      ApiEndpoints.publishClientProject(normalizedId),
      auth: true,
    );
  }
}
