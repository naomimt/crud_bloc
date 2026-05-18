import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_provider.dart';
import 'features/users/data/datasources/user_remote_datasource.dart';
import 'features/users/data/repositories/user_repository.dart';
import 'features/users/presentation/blocs/user_bloc.dart';
import 'core/navigation/app_router.dart';

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
    return BlocProvider(
      create: (_) => UserBloc(repository)..add(FetchUsers()),
      child: MaterialApp.router(
        title: 'Minimalist CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
