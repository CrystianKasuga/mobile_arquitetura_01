import '../../core/network/http_client.dart';
import '../models/auth_model.dart';

class AuthRemoteDatasource {
  static const _base = 'https://dummyjson.com';

  final AppHttpClient client;

  AuthRemoteDatasource(this.client);

  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    final map = await client.post(
      '$_base/auth/login',
      {'username': username, 'password': password},
    );
    return AuthModel.fromJson(map);
  }
}
