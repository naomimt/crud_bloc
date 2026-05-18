import 'package:dio/dio.dart';
import '../models/user.dart';
import '../../../../core/constants/api_constants.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<List<User>> getUsers() async {
    final response = await dio.get(ApiConstants.usersEndpoint);
    return (response.data['users'] as List)
        .map((json) => User.fromJson(json))
        .toList();
  }

  Future<User> createUser(User user) async {
    final response = await dio.post('${ApiConstants.usersEndpoint}/add', data: user.toJson());
    return User.fromJson(response.data);
  }

  Future<User> updateUser(User user) async {
    final response = await dio.put('${ApiConstants.usersEndpoint}/${user.id}', data: user.toJson());
    return User.fromJson(response.data);
  }

  Future<void> deleteUser(int id) async {
    await dio.delete('${ApiConstants.usersEndpoint}/$id');
  }
}
