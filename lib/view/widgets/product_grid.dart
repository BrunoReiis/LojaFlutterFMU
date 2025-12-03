import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/models/product.dart';
import 'package:lojaflutter/view/product_details_screen.dart';
import 'package:lojaflutter/view/widgets/product_card.dart';
import 'package:lojaflutter/controllers/cart_controller.dart';

class ProductGrid extends StatelessWidget {
  final String? categoryFilter;

  const ProductGrid({super.key, this.categoryFilter});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    
    // Filtrar produtos por categoria se fornecida
    final filteredProducts = categoryFilter == null || categoryFilter == 'All'
        ? products
        : products.where((p) => p.category == categoryFilter).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                product: product,
              ),
            ),
          ),
          child: Obx(() => ProductCard(
            product: product,
            isInWishlist: cartController.isInWishlist(product.id),
            onWishlistTap: () => cartController.toggleWishlist(product),
            onAddToCart: () {
              cartController.addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} adicionado ao carrinho'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          )),
        );
      },
    );
  }
}

