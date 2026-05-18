import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/user.dart';
import '../blocs/user_bloc.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${user.firstName} ${user.lastName}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  context.read<UserBloc>().add(DeleteUser(user.id)),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.image ?? ''),
              ),
              const SizedBox(height: 20),
              Text(user.email, style: const TextStyle(fontSize: 18)),
              Text(user.phone ?? '', style: const TextStyle(fontSize: 16)),
              Text(user.username ?? '', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.edit),
          onPressed: () => context.push('/form', extra: user),
        ),
      ),
    );
  }
}
