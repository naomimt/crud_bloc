import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? image;
  final String? username;
  final String? phone;
  final Map<String, dynamic> extraFields;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    this.username,
    this.phone,
    this.extraFields = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final extra = Map<String, dynamic>.from(json)
      ..remove('id')
      ..remove('firstName')
      ..remove('lastName')
      ..remove('email')
      ..remove('image')
      ..remove('username')
      ..remove('phone');

    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      username: json['username'],
      phone: json['phone'],
      extraFields: extra,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...extraFields,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'username': username,
      'phone': phone,
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? username,
    String? phone,
    Map<String, dynamic>? extraFields,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      extraFields: extraFields ?? this.extraFields,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, image, username, phone, extraFields];
}
