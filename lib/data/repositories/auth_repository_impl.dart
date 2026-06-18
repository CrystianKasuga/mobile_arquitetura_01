import '../../core/auth/session_manager.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final SessionManager sessionManager;

  AuthRepositoryImpl(this.remoteDatasource, this.sessionManager);

  @override
  Future<UserSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await remoteDatasource.login(
        username: username,
        password: password,
      );
      final session = model.toEntity();
      await sessionManager.saveSession(
        token: session.token,
        username: session.username,
        firstName: session.firstName,
      );
      return session;
    } on Failure {
      rethrow;
    } on Exception {
      throw Failure('Credenciais inválidas. Verifique usuário e senha.');
    }
  }
}
