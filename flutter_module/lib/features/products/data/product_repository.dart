import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network.dart';
import '../domain/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(dioProvider));
});

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
