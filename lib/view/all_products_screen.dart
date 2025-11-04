import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lojaflutter/utils/app_textstyles.dart';
import 'package:lojaflutter/view/widgets/filter_bottom_sheet.dart';
import 'package:lojaflutter/view/widgets/product_grid.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isdark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'all Products',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isdark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          // search icon
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: isdark ? Colors.white : Colors.black,
            ),
          ),

          // filiter icon 
          IconButton(
            onPressed: () => filterBottomSheet.show(context),
            icon: Icon(
              Icons.filter_list,
              color: isdark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: const ProductGrid(),
    );
  }
}
