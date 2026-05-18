import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {}
class CreateUser extends UserEvent { final User user; const CreateUser(this.user); @override List<Object?> get props => [user]; }
class UpdateUser extends UserEvent { final User user; const UpdateUser(this.user); @override List<Object?> get props => [user]; }
class DeleteUser extends UserEvent { final int id; const DeleteUser(this.id); @override List<Object?> get props => [id]; }

// States
abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState { 
  final List<User> users; 
  const UserLoaded(this.users); 
  @override List<Object?> get props => [users]; 
}
class UserError extends UserState { final String message; const UserError(this.message); @override List<Object?> get props => [message]; }
class UserSuccess extends UserLoaded { 
  final String message; 
  const UserSuccess(this.message, List<User> users) : super(users); 
  @override List<Object?> get props => [message, users]; 
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  List<User> _users = [];

  UserBloc(this.repository) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        _users = await repository.getUsers();
        emit(UserLoaded(List.from(_users)));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<CreateUser>((event, emit) async {
      emit(UserLoading());
      try {
        final newUser = await repository.createUser(event.user);
        _users.insert(0, newUser);
        emit(UserSuccess('User created successfully', List.from(_users)));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(UserLoading());
      try {
        final updatedUser = await repository.updateUser(event.user);
        final index = _users.indexWhere((u) => u.id == event.user.id);
        if (index != -1) {
          _users[index] = updatedUser;
        }
        emit(UserSuccess('User updated successfully', List.from(_users)));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<DeleteUser>((event, emit) async {
      emit(UserLoading());
      try {
        await repository.deleteUser(event.id);
        _users.removeWhere((u) => u.id == event.id);
        emit(UserSuccess('User deleted successfully', List.from(_users)));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
