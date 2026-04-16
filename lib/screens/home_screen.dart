import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_repository.dart';
import '../theme/app_style.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _allCategoriesLabel = 'Tum kategoriler';

  final ProductRepository _repository = ProductRepository();

  List<Product> _allProducts = [];
  String _searchText = '';
  String _selectedCategory = _allCategoriesLabel;
  final Map<int, int> _cartProductQuantities = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _repository.loadProducts();
      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _allProducts = [];
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fake Store API baglantisi basarisiz.'),
        ),
      );
    }
  }

  List<Product> get _filteredProducts {
    final query = _searchText.toLowerCase();

    return _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == _allCategoriesLabel ||
              product.category == _selectedCategory;
      final matchesQuery = query.trim().isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<String> get _categories {
    final categories = _allProducts
        .map((product) => product.category)
        .toSet()
        .toList()
      ..sort();

    return [_allCategoriesLabel, ...categories];
  }

  List<Product> get _cartProducts {
    return _allProducts
        .where((product) => _cartProductQuantities.containsKey(product.id))
        .toList();
  }

  int get _totalCartItemCount {
    return _cartProductQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  void _addToCart(Product product) {
    setState(() {
      final current = _cartProductQuantities[product.id] ?? 0;
      _cartProductQuantities[product.id] = current + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} sepete eklendi.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _increaseQuantity(int productId) {
    setState(() {
      final current = _cartProductQuantities[productId] ?? 0;
      _cartProductQuantities[productId] = current + 1;
    });
  }

  void _decreaseQuantity(int productId) {
    setState(() {
      final current = _cartProductQuantities[productId] ?? 0;
      if (current <= 1) {
        _cartProductQuantities.remove(productId);
      } else {
        _cartProductQuantities[productId] = current - 1;
      }
    });
  }

  void _removeFromCart(int productId) {
    setState(() {
      _cartProductQuantities.remove(productId);
    });
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
        builder: (_) => CartScreen(
          products: _cartProducts,
          quantities: _cartProductQuantities,
          onIncrease: _increaseQuantity,
          onDecrease: _decreaseQuantity,
          onRemove: _removeFromCart,
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: AppStyle.heroGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppStyle.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trend Urunler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kategorilere gore kesfet, sepete tek dokunusla ekle.',
            style: TextStyle(
              color: Color(0xFFFDEBD2),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statChip(
                icon: Icons.grid_view_rounded,
                label: '${_allProducts.length} urun',
              ),
              const SizedBox(width: 8),
              _statChip(
                icon: Icons.shopping_bag_outlined,
                label: '$_totalCartItemCount sepette',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = _categories;

    if (categories.length <= 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppStyle.ink,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: AppStyle.primary,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE6EAF0)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Vitrin'),
        actions: [
          IconButton(
            onPressed: _openCart,
            tooltip: 'Sepeti ac',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (_totalCartItemCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: AppStyle.secondary,
                      child: Text(
                        _totalCartItemCount.toString(),
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
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyle.pageGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: Column(
                    children: [
                      _buildHeroHeader(),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (value) =>
                            setState(() => _searchText = value),
                        decoration: const InputDecoration(
                          hintText: 'Urun veya kategori ara',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCategoryFilters(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _filteredProducts.isEmpty
                            ? Center(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Aradigin kriterde urun bulunamadi.',
                                    style: TextStyle(color: AppStyle.muted),
                                  ),
                                ),
                              )
                            : GridView.builder(
                                itemCount: _filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.60,
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
        ),
      ),
    );
  }
}
