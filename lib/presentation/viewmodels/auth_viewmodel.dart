import 'package:flutter/foundation.dart';
import '../../core/errors/failure.dart';
import '../../core/state/app_state.dart';
import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel {
  final AuthRepository repository;

  final ValueNotifier<AppState<UserSession>?> state = ValueNotifier(null);
  final ValueNotifier<String?> usernameError = ValueNotifier(null);
  final ValueNotifier<String?> passwordError = ValueNotifier(null);

  AuthViewModel(this.repository);

  bool _validate(String username, String password) {
    usernameError.value =
        username.trim().isEmpty ? 'Usuário obrigatório' : null;
    passwordError.value = password.isEmpty ? 'Senha obrigatória' : null;
    return usernameError.value == null && passwordError.value == null;
  }

  Future<void> login(String username, String password) async {
    if (!_validate(username, password)) return;
    state.value = Loading();
    try {
      final session = await repository.login(
        username: username.trim(),
        password: password,
      );
      state.value = Success(session);
    } on Failure catch (e) {
      state.value = ErrorState(e.message);
    } on Exception {
      state.value = ErrorState('Erro inesperado. Tente novamente.');
    }
  }
}
