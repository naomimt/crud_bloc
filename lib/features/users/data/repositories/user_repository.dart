import '../datasources/user_remote_datasource.dart';
import '../models/user.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<List<User>> getUsers() => remoteDataSource.getUsers();
  Future<User> createUser(User user) => remoteDataSource.createUser(user);
  Future<User> updateUser(User user) => remoteDataSource.updateUser(user);
  Future<void> deleteUser(int id) => remoteDataSource.deleteUser(id);
}
