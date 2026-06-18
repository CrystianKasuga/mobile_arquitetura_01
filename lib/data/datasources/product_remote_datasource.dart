import '../../core/network/http_client.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  static const _base = 'https://dummyjson.com';

  final AppHttpClient client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final map = await client.getMap('$_base/products');
    final list = map['products'] as List<dynamic>;
    return list.map((j) => ProductModel.fromJson(j)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final map = await client.getMap('$_base/products/$id');
    return ProductModel.fromJson(map);
  }
}
