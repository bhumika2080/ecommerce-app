import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_repository.dart';
import '../domain/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

final productDetailProvider =
    FutureProvider.family<Product, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProduct(id);
});
