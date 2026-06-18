import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';

class FavoritesViewModel extends ChangeNotifier {
  final Set<int> _favoriteIds = {};

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }

  List<int> get favoriteIds => List.unmodifiable(_favoriteIds);
}
