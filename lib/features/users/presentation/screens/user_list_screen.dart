import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/user_bloc.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return const Center(child: CircularProgressIndicator());
          if (state is UserError) return Center(child: Text(state.message));
          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(user.image ?? '')),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  onTap: () => context.push('/details', extra: user),
                );
              },
            );
          }
          return const Center(child: Text('No users'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
