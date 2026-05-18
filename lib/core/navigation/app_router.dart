import 'package:go_router/go_router.dart';
import '../../features/users/data/models/user.dart';
import '../../features/users/presentation/screens/user_list_screen.dart';
import '../../features/users/presentation/screens/user_detail_screen.dart';
import '../../features/users/presentation/screens/user_form_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const UserListScreen(),
        routes: [
          GoRoute(
            path: 'details/:id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return UserDetailScreen(userId: id);
            },
          ),
          GoRoute(
            path: 'form',
            builder: (context, state) {
              final user = state.extra as User?;
              return UserFormScreen(user: user);
            },
          ),
        ],
      ),
    ],
  );
}
