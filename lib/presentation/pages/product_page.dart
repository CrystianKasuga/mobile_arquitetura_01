import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth/session_manager.dart';
import '../../core/state/app_state.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/product_detail_viewmodel.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final ProductDetailViewModel detailViewModel;
  final SessionManager sessionManager;

  const ProductPage({
    super.key,
    required this.viewModel,
    required this.detailViewModel,
    required this.sessionManager,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await widget.sessionManager.getFirstName();
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _username = name);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await widget.sessionManager.clearSession();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _openDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: product,
          viewModel: widget.detailViewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _username.isNotEmpty
            ? Text('Olá, $_username')
            : const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<AppState<List<Product>>>(
        valueListenable: widget.viewModel.products,
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
                      onPressed: widget.viewModel.loadProducts,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            Success(:final data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final product = data[index];
                  return Consumer<FavoritesViewModel>(
                    builder: (context, favorites, _) {
                      final isFav = favorites.isFavorite(product.id);
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(product.title),
                        subtitle: Text(
                          'R\$ ${product.price.toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ),
                          onPressed: () => favorites.toggleFavorite(product),
                        ),
                        onTap: () => _openDetail(context, product),
                      );
                    },
                  );
                },
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.viewModel.loadProducts,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
