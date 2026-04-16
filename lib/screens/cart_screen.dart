import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_style.dart';

class CartScreen extends StatefulWidget {
  final List<Product> products;
  final Map<int, int> quantities;
  final ValueChanged<int> onIncrease;
  final ValueChanged<int> onDecrease;
  final ValueChanged<int> onRemove;

  const CartScreen({
    super.key,
    required this.products,
    required this.quantities,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _quantityOf(Product product) => widget.quantities[product.id] ?? 0;

  List<Product> get _visibleProducts {
    return widget.products
        .where((product) => _quantityOf(product) > 0)
        .toList(growable: false);
  }

  double get _totalPrice {
    return _visibleProducts.fold(0, (sum, product) {
      return sum + (product.price * _quantityOf(product));
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Sepetim')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyle.pageGradient),
        child: SafeArea(
          child: products.isEmpty
              ? const Center(
                  child: Text(
                    'Sepetinizde urun yok.',
                    style: TextStyle(
                      color: AppStyle.muted,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final quantity = _quantityOf(product);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppStyle.softShadow,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 62,
                                    height: 62,
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const ColoredBox(
                                          color: Color(0xFFEDEDED),
                                          child: Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppStyle.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${product.price.toStringAsFixed(2)} TL x $quantity',
                                        style: const TextStyle(
                                          color: AppStyle.muted,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          _qtyButton(
                                            icon: Icons.remove,
                                            onTap: () {
                                              widget.onDecrease(product.id);
                                              setState(() {});
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                            child: Center(
                                              child: Text(
                                                quantity.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ),
                                          _qtyButton(
                                            icon: Icons.add,
                                            onTap: () {
                                              widget.onIncrease(product.id);
                                              setState(() {});
                                            },
                                          ),
                                          const Spacer(),
                                          TextButton.icon(
                                            onPressed: () {
                                              widget.onRemove(product.id);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              size: 16,
                                            ),
                                            label: const Text('Cikar'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppStyle.ink,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Toplam',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_totalPrice.toStringAsFixed(2)} TL',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, size: 16, color: AppStyle.ink),
        ),
      ),
    );
  }
}