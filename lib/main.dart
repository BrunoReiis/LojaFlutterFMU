import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lojaflutter/controllers/auth_controller.dart';
import 'package:lojaflutter/controllers/navigation_controller.dart';
import 'package:lojaflutter/controllers/theme_controller.dart';
import 'package:lojaflutter/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/utils/app_themes.dart';
import 'package:lojaflutter/view/splash_screen.dart';
import 'package:lojaflutter/view/cart_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(NavigationController());
  Get.put(CartController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NexusStore',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/cart', page: () => const CartScreen()),
      ],
    );
  }
}