import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/network/dio_provider.dart';
import 'features/users/data/datasources/user_remote_datasource.dart';
import 'features/users/data/repositories/user_repository.dart';
import 'features/users/presentation/blocs/user_bloc.dart';
import 'features/users/presentation/screens/user_list_screen.dart';
import 'features/users/presentation/screens/user_form_screen.dart';
import 'features/users/presentation/screens/user_detail_screen.dart';
import 'features/users/data/models/user.dart';

void main() {
  final dio = DioProvider.instance;
  final remoteDataSource = UserRemoteDataSource(dio);
  final repository = UserRepository(remoteDataSource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final UserRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const UserListScreen()),
        GoRoute(
          path: '/form',
          builder: (context, state) {
            final extra = state.extra;
            final user = extra is User ? extra : null;
            return UserFormScreen(user: user);
          },
        ),
        GoRoute(
          path: '/details/:id',
          builder: (context, state) {
            final idStr = state.pathParameters['id'];
            final id = int.tryParse(idStr ?? '0') ?? 0;
            return UserDetailScreen(userId: id);
          },
        ),
      ],
    );

    return BlocProvider(
      create: (_) => UserBloc(repository)..add(FetchUsers()),
      child: MaterialApp.router(
        title: 'Minimalist CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        routerConfig: router,
      ),
    );
  }
}
