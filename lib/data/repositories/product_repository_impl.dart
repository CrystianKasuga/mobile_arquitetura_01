import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  final ProductLocalDatasource localDatasource;

  ProductRepositoryImpl(this.remoteDatasource, this.localDatasource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remoteDatasource.getProducts();
      await localDatasource.saveProducts(models);
      return models.map(_toEntity).toList();
    } on Exception {
      final cached = await localDatasource.getProducts();
      if (cached.isEmpty) {
        throw Failure('Sem conexão e sem cache disponível.');
      }
      return cached.map(_toEntity).toList();
    }
  }

  Product _toEntity(ProductModel m) => Product(
        id: m.id,
        title: m.title,
        price: m.price,
        image: m.image,
      );
}
