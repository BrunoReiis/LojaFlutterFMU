import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:lojaflutter/controllers/theme_controller.dart';
import 'package:lojaflutter/view/all_products_screen.dart';
import 'package:lojaflutter/view/widgets/category_chips.dart';
import 'package:lojaflutter/view/widgets/custom_search_bar.dart';
import 'package:lojaflutter/view/widgets/product_grid.dart';
import 'package:lojaflutter/view/widgets/sale_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Alex',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
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
                    icon: Icon(Icons.notifications_outlined),
                  ),
                  // cart button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.shopping_bag_outlined),
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
            const CategoryChips(),

            // sale banner
            const SaleBanner(),

            // popular product
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(()=> const AllProductsScreen()),
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

            // product  grid
            const Expanded(child: ProductGrid()),
          ],
        ),
      ),
    );
  }
}
 