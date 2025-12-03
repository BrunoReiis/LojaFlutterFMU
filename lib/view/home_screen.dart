import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexusstore/controllers/theme_controller.dart';
import 'package:nexusstore/controllers/auth_controller.dart';
import 'package:nexusstore/controllers/cart_controller.dart';
import 'package:nexusstore/view/all_products_screen.dart';
import 'package:nexusstore/view/widgets/category_chips.dart';
import 'package:nexusstore/view/widgets/custom_search_bar.dart';
import 'package:nexusstore/view/widgets/product_grid.dart';
import 'package:nexusstore/view/widgets/sale_banner.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: authController.userData?.photoBase64 != null && authController.userData!.photoBase64!.isNotEmpty
                        ? MemoryImage(base64Decode(authController.userData!.photoBase64!))
                        : null,
                    child: authController.userData?.photoBase64 == null || authController.userData!.photoBase64!.isEmpty
                        ? Text(
                            (authController.userData?.name ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(fontSize: 16),
                          )
                        : null,
                  )),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(authController),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const Text(
                        'Good Morning',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // notification icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  // cart button
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed('/cart'),
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                      Obx(() {
                        if (cartController.itemCount > 0) {
                          return Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cartController.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                  // theme button
                  GetBuilder<ThemeController>(
                    builder: (controller) => IconButton(
                      onPressed: () => controller.toggleTheme(),
                      icon: Icon(
                        controller.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // search bar
            const CustomSearchBar(),

            // category chips
            CategoryChips(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            // sale banner
            const SaleBanner(),

            // popular product
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const AllProductsScreen()),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // product grid with filter
            Expanded(
              child: ProductGrid(categoryFilter: selectedCategory),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(AuthController authController) {
    String firstName = 'User';
    
    if (authController.userData?.name != null && authController.userData!.name.isNotEmpty) {
      firstName = authController.userData!.name.split(' ').first;
    } else if (authController.firebaseUser?.displayName != null && authController.firebaseUser!.displayName!.isNotEmpty) {
      firstName = authController.firebaseUser!.displayName!.split(' ').first;
    } else if (authController.firebaseUser?.email != null) {
      firstName = authController.firebaseUser!.email!.split('@').first;
    }
    
    return 'Hello $firstName';
  }
}
 
