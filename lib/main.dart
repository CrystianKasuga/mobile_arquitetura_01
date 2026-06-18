import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth/session_manager.dart';
import 'core/network/http_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/product_local_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/favorites_viewmodel.dart';
import 'presentation/viewmodels/product_detail_viewmodel.dart';
import 'presentation/viewmodels/product_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionManager = SessionManager();
  final client = AppHttpClient();

  final authRepo = AuthRepositoryImpl(
    AuthRemoteDatasource(client),
    sessionManager,
  );
  final authViewModel = AuthViewModel(authRepo);

  final productRepo = ProductRepositoryImpl(
    ProductRemoteDatasource(client),
    ProductLocalDatasource(),
  );
  final productViewModel = ProductViewModel(productRepo);
  final productDetailViewModel = ProductDetailViewModel(productRepo);

  final favoritesViewModel = FavoritesViewModel();

  final isLoggedIn = await sessionManager.isLoggedIn();

  runApp(
    MyApp(
      initialRoute: isLoggedIn ? '/products' : '/login',
      authViewModel: authViewModel,
      productViewModel: productViewModel,
      productDetailViewModel: productDetailViewModel,
      favoritesViewModel: favoritesViewModel,
      sessionManager: sessionManager,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final AuthViewModel authViewModel;
  final ProductViewModel productViewModel;
  final ProductDetailViewModel productDetailViewModel;
  final FavoritesViewModel favoritesViewModel;
  final SessionManager sessionManager;

  const MyApp({
    super.key,
    required this.initialRoute,
    required this.authViewModel,
    required this.productViewModel,
    required this.productDetailViewModel,
    required this.favoritesViewModel,
    required this.sessionManager,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoritesViewModel>.value(
      value: favoritesViewModel,
      child: MaterialApp(
        title: 'Product App',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/login': (_) => LoginPage(viewModel: authViewModel),
          '/products': (_) => ProductPage(
                viewModel: productViewModel,
                detailViewModel: productDetailViewModel,
                sessionManager: sessionManager,
              ),
        },
      ),
    );
  }
}
