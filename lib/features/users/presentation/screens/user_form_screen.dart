import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/user.dart';
import '../blocs/user_bloc.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstController;
  late TextEditingController _lastController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstController = TextEditingController(text: widget.user?.firstName);
    _lastController = TextEditingController(text: widget.user?.lastName);
    _emailController = TextEditingController(text: widget.user?.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.user == null ? 'Add User' : 'Edit User')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: _firstController, decoration: const InputDecoration(labelText: 'First Name')),
                TextFormField(controller: _lastController, decoration: const InputDecoration(labelText: 'Last Name')),
                TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (widget.user == null) {
                      final user = User(
                        id: 0,
                        firstName: _firstController.text,
                        lastName: _lastController.text,
                        email: _emailController.text,
                      );
                      context.read<UserBloc>().add(CreateUser(user));
                    } else {
                      final updatedUser = widget.user!.copyWith(
                        firstName: _firstController.text,
                        lastName: _lastController.text,
                        email: _emailController.text,
                      );
                      context.read<UserBloc>().add(UpdateUser(updatedUser));
                    }
                  },
                  child: Text(widget.user == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
