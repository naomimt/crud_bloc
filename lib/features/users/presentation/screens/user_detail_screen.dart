import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user.dart';
import '../blocs/user_bloc.dart';
import 'user_form_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.of(context).pop();
        }
        if (state is UserError) {
          if (mounted)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('User details')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading && (state is! UserLoaded)) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = state is UserLoaded ? state.users : <User>[];
            final matching = users.where((u) => u.id == widget.userId).toList();
            if (matching.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, size: 48),
                          const SizedBox(height: 12),
                          const Text(
                            'User not found',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: () =>
                                context.read<UserBloc>().add(FetchUsers()),
                            child: const Text('Refresh list'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final user = matching.first;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 54,
                            backgroundImage: user.image != null
                                ? NetworkImage(user.image!)
                                : null,
                            child: user.image == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile details',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow('First name', user.firstName),
                            _buildInfoRow('Last name', user.lastName),
                            _buildInfoRow('Email', user.email),
                            _buildInfoRow('Phone', user.phone ?? ''),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Edit'),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            UserFormScreen(user: user),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Delete'),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete user'),
                                          content: const Text('Are you sure?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                context,
                                              ).pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true &&
                                          context.mounted) {
                                        try {
                                          context.read<UserBloc>().add(
                                            DeleteUser(user.id),
                                          );
                                        } catch (e) {
                                          if (context.mounted)
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Error: $e'),
                                              ),
                                            );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
