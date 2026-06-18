import 'package:flutter/foundation.dart';
import '../../core/errors/failure.dart';
import '../../core/state/app_state.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductDetailViewModel {
  final ProductRepository repository;

  final ValueNotifier<AppState<Product>> product = ValueNotifier(Loading());

  ProductDetailViewModel(this.repository);

  Future<void> loadProduct(int id) async {
    product.value = Loading();
    try {
      final result = await repository.getProductById(id);
      product.value = Success(result);
    } on Failure catch (e) {
      product.value = ErrorState(e.message);
    } on Exception {
      product.value = ErrorState('Erro inesperado. Tente novamente.');
    }
  }
}
