import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/projects/presentation/projects_page.dart';
import '../../features/projects/presentation/subtypes_page.dart';
import '../../features/checklist/presentation/checklist_page.dart';
import '../../features/ai_processing/presentation/ai_page.dart';
import '../../features/annotation/presentation/annotation_page.dart';
import '../../features/profile/presentation/profile_page.dart';

// ── Auth-aware router ─────────────────────────────────────────────────────────

/// A [ChangeNotifier] that bridges the Riverpod [authProvider] state into
/// go_router's refresh mechanism.
class _AuthNotifierAdapter extends ChangeNotifier {
  _AuthNotifierAdapter(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
  AuthState get authState => _ref.read(authProvider);
}

final routerProvider = Provider<GoRouter>((ref) {
  final adapter = _AuthNotifierAdapter(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: adapter,

    // ── Auth redirect ─────────────────────────────────────────────────────
    redirect: (context, state) {
      final auth = adapter.authState;
      final isLoading = auth.status == AuthStatus.loading ||
          auth.status == AuthStatus.idle;
      final isAuthenticated = auth.status == AuthStatus.authenticated;
      final isOnLogin = state.matchedLocation == '/';

      // While restoring session, stay where we are.
      if (isLoading) return null;

      // Not authenticated → send to login (unless already there).
      if (!isAuthenticated && !isOnLogin) return '/';

      // Authenticated → skip login, go to home.
      if (isAuthenticated && isOnLogin) return '/home';

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const ProjectsPage(),
        routes: [
          GoRoute(
            path: 'subtypes',
            name: 'subtypes',
            builder: (context, state) {
              final extra = state.extra;
              String projectId = 's1';
              String projectName = 'Skyline Towers — Block A';
              if (extra is Map<String, dynamic>) {
                projectId = extra['projectId'] as String? ?? 's1';
                projectName = extra['projectName'] as String? ?? 'Skyline Towers — Block A';
              } else if (extra is String) {
                projectName = extra;
              }
              return SubtypesPage(projectId: projectId, projectName: projectName);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/checklist',
        name: 'checklist',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return ChecklistPage(
            formTypeId: args?['formTypeId'] as String? ?? 'form_ad44f4b73992',
            checklistName: args?['checklistName'] as String? ?? 'Concrete Pouring Audit',
            subtypeName: args?['subtypeName'] as String? ?? 'Civil Works',
          );
        },
      ),
      GoRoute(
        path: '/ai',
        name: 'ai',
        builder: (context, state) => const AiPage(),
      ),
      GoRoute(
        path: '/annotation',
        name: 'annotation',
        builder: (context, state) => const AnnotationPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});
