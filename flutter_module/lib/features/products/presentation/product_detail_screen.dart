import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import '../domain/product.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: productAsync.when(
        data: (product) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  product.image,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(product.description),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handlePay(product),
                  child: const Text('Pay'),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _handlePay(Product product) {
    // Return to native with payload
    const platform = MethodChannel('com.kotlin.kotlinapp/flutter');
    try {
      platform.invokeMethod('pay', product.toJson());
    } on PlatformException catch (e) {
      debugPrint("Failed to invoke pay: '${e.message}'.");
    }
  }
}
