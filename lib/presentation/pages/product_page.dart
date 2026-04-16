import 'package:flutter/material.dart';
import '../../core/state/app_state.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductPage extends StatelessWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<AppState<List<Product>>>(
        valueListenable: viewModel.products,
        builder: (context, state, _) {
          return switch (state) {
            Loading() => const Center(child: CircularProgressIndicator()),
            Success(:final data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final product = data[index];
                  return ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.title),
                    subtitle: Text("\$${product.price}"),
                  );
                },
              ),
            ErrorState(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.loadProducts,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.loadProducts,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
