import '../../domain/entities/user_session.dart';

class AuthModel {
  final String accessToken;
  final String username;
  final String firstName;

  AuthModel({
    required this.accessToken,
    required this.username,
    required this.firstName,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['accessToken'],
      username: json['username'],
      firstName: json['firstName'],
    );
  }

  UserSession toEntity() => UserSession(
        token: accessToken,
        username: username,
        firstName: firstName,
      );
}
