import 'package:flutter/foundation.dart';
import '../../core/errors/failure.dart';
import '../../core/state/app_state.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<AppState<List<Product>>> products =
      ValueNotifier(Loading());

  ProductViewModel(this.repository) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    products.value = Loading();
    try {
      final result = await repository.getProducts();
      products.value = Success(result);
    } on Failure catch (e) {
      products.value = ErrorState(e.message);
    } on Exception {
      products.value = ErrorState('Erro inesperado. Tente novamente.');
    }
  }
}
