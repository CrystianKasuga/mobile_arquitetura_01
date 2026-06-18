import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/product_detail_viewmodel.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final ProductDetailViewModel viewModel;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.viewModel,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadProduct(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favorites, _) {
              final isFav = favorites.isFavorite(widget.product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () => favorites.toggleFavorite(widget.product),
                tooltip: isFav ? 'Remover favorito' : 'Favoritar',
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<AppState<Product>>(
        valueListenable: widget.viewModel.product,
        builder: (context, state, _) {
          return switch (state) {
            Loading() => const Center(child: CircularProgressIndicator()),
            ErrorState(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          widget.viewModel.loadProduct(widget.product.id),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            Success(:final data) => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        data.image,
                        height: 240,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 80),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${data.price.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.green[700]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
