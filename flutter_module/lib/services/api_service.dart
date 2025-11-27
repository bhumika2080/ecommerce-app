import 'package:dio/dio.dart';
import 'package:flutter_module/models/product.dart';

class ApiService {
  final Dio _dio;
  final String uuid;

  ApiService(this.uuid)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://fakestoreapi.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['X-UUID'] = uuid;
        print('API Request:\n ${options.method} ${options.uri}');
        print('Headers:\n ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'API Response:\n ${response.statusCode} ${response.requestOptions.uri}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('API Error:\n ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      print('Error fetching product: $e');
      rethrow;
    }
  }
}
