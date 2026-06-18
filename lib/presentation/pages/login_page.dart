import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  final AuthViewModel viewModel;

  const LoginPage({super.key, required this.viewModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.state.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final state = widget.viewModel.state.value;
    if (state is Success) {
      Navigator.pushReplacementNamed(context, '/products');
    }
  }

  @override
  void dispose() {
    widget.viewModel.state.removeListener(_onStateChanged);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.viewModel.login(
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 72),
                const SizedBox(height: 16),
                Text(
                  'Entrar',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<String?>(
                  valueListenable: widget.viewModel.usernameError,
                  builder: (context, error, _) {
                    return TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        border: const OutlineInputBorder(),
                        errorText: error,
                      ),
                      textInputAction: TextInputAction.next,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<String?>(
                  valueListenable: widget.viewModel.passwordError,
                  builder: (context, error, _) {
                    return TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        errorText: error,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder(
                  valueListenable: widget.viewModel.state,
                  builder: (context, state, _) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state is ErrorState)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              (state as ErrorState).message,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Entrar'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Credenciais de teste: emilys / emilyspass',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
