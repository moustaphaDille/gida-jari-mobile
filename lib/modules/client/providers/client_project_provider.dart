import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/providers/auth_providers.dart';
import '../services/client_project_service.dart';
import '../models/client_project.dart';

final clientProjectServiceProvider = Provider<ClientProjectService>(
  (ref) => ClientProjectService(ref.watch(apiClientProvider)),
);

final openProjectsProvider = FutureProvider<List<ClientProject>>(
  (ref) => ref.watch(clientProjectServiceProvider).getOpenProjects(),
);

final clientProjectsProvider = FutureProvider<List<ClientProject>>(
  (ref) => ref.watch(clientProjectServiceProvider).getClientProjects(),
);

final projectDetailsProvider =
    FutureProvider.family<ProjectDetails, String>((ref, projectId) {
  return ref.watch(clientProjectServiceProvider).getProjectDetails(projectId);
});
