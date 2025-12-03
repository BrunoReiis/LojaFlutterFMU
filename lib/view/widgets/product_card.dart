import 'package:flutter/material.dart';
import 'package:lojaflutter/models/product.dart';
import 'package:lojaflutter/utils/app_textstyles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isInWishlist;
  final VoidCallback onWishlistTap;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.isInWishlist = false,
    required this.onWishlistTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Image.asset(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // favorite button
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: onWishlistTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist
                          ? Colors.red
                          : Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                ),
              ),
              if (product.oldPrice != null)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${calculateDiscount(product.price, product.oldPrice!)}% OFF',
                      style: AppTextStyle.withColor(
                        AppTextStyle.withWeight(
                          AppTextStyle.bodySmall,
                          FontWeight.bold,
                        ),
                        Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // product details
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyle.withColor(
                    AppTextStyle.withWeight(AppTextStyle.h3, FontWeight.bold),
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  product.category,
                  style: AppTextStyle.withColor(
                    AppTextStyle.bodySmall,
                    isDark ? Colors.grey[400]! : Colors.grey[600]!,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: AppTextStyle.withColor(
                        AppTextStyle.withWeight(
                          AppTextStyle.bodyMedium,
                          FontWeight.bold,
                        ),
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    if (product.oldPrice != null) ...[
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        'R\$ ${product.oldPrice!.toStringAsFixed(2)}',
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall,
                          isDark ? Colors.grey[400]! : Colors.grey[600]!,
                        ).copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Adicionar',
                      style: AppTextStyle.withColor(
                        AppTextStyle.bodySmall,
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calculate discount
  int calculateDiscount(double currentPrice, double oldPrice) {
    return (((oldPrice - currentPrice) / oldPrice) * 100).round();
  }
}

