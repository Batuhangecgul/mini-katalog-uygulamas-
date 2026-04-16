import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_repository.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository _repository = ProductRepository();

  List<Product> _allProducts = [];
  String _searchText = '';
  final Set<int> _cartProductIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _repository.loadProducts();
    setState(() {
      _allProducts = products;
      _isLoading = false;
    });
  }

  List<Product> get _filteredProducts {
    if (_searchText.trim().isEmpty) {
      return _allProducts;
    }

    final query = _searchText.toLowerCase();
    return _allProducts.where((product) {
      return product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  List<Product> get _cartProducts {
    return _allProducts
        .where((product) => _cartProductIds.contains(product.id))
        .toList();
  }

  void _addToCart(Product product) {
    setState(() {
      _cartProductIds.add(product.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} sepete eklendi.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  Future<void> _openDetail(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );

    if (result == true) {
      _addToCart(product);
    }
  }

  Future<void> _openCart() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CartScreen(products: _cartProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog Uygulamasi'),
        actions: [
          IconButton(
            onPressed: _openCart,
            tooltip: 'Sepeti ac',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (_cartProductIds.isNotEmpty)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.teal,
                      child: Text(
                        _cartProductIds.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://wantapi.com/assets/banner.png',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        color: const Color(0xFFEDEDED),
                        alignment: Alignment.center,
                        child: const Text('Banner yuklenemedi'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() => _searchText = value),
                    decoration: InputDecoration(
                      hintText: 'Urun veya kategori ara',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _filteredProducts.isEmpty
                        ? const Center(child: Text('Sonuc bulunamadi.'))
                        : GridView.builder(
                            itemCount: _filteredProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.62,
                            ),
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onTap: () => _openDetail(product),
                                onAddToCart: () => _addToCart(product),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
