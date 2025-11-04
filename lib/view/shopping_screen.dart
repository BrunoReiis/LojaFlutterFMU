import 'package:flutter/material.dart';
import 'package:lojaflutter/utils/app_textstyles.dart';
import 'package:lojaflutter/view/widgets/category_chips.dart';
import 'package:lojaflutter/view/widgets/filter_bottom_sheet.dart'
    show filterBottomSheet;
import 'package:lojaflutter/view/widgets/product_grid.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping',
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
      body: Column(children: [
      Padding(
      padding: EdgeInsets.only(top: 16),
      child: CategoryChips(),
      ),
      Expanded(
      child: ProductGrid(),
      ),
      ]
      ),
    );
  }
}
