import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:lojaflutter/controllers/navigation_controller.dart';
import 'package:lojaflutter/controllers/theme_controller.dart';
import 'package:lojaflutter/view/account_screen.dart';
import 'package:lojaflutter/view/home_screen.dart';
import 'package:lojaflutter/view/shopping_screen.dart';
import 'package:lojaflutter/view/widgets/Custom_bottom_navbar.dart';
import 'package:lojaflutter/view/wishlist_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(
      NavigationController(),
    );

    return GetBuilder<ThemeController>(
      builder: (themeController) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Obx(
            () => IndexedStack(
              key: ValueKey(navigationController.currentIndex.value),
              index: navigationController.currentIndex.value,
              children: const [
                HomeScreen(),
                ShoppingScreen(),
                WishlistScreen(),
                AccountScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavbar(),
      ),
    );
  }
}
