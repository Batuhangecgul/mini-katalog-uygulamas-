import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductRepository {
  static final Uri _productsUri = Uri.parse('https://fakestoreapi.com/products');

  Future<List<Product>> loadProducts() async {
    final response = await http
        .get(_productsUri)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Urunler yuklenemedi. Kod: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
