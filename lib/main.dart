import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lojaflutter/controllers/auth_controller.dart';
import 'package:lojaflutter/controllers/theme_controller.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/utils/app_themes.dart';
import 'package:lojaflutter/view/splash_screen.dart';

void main() async{
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(AuthController());
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
    );
  }
}