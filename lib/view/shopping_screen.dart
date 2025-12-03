import 'package:flutter/material.dart';
import 'package:nexusstore/utils/app_textstyles.dart';
import 'package:nexusstore/view/widgets/category_chips.dart';
import 'package:nexusstore/view/widgets/filter_bottom_sheet.dart'
    show FilterBottomSheet;
import 'package:nexusstore/view/widgets/product_grid.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  String selectedCategory = 'All';

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
            onPressed: () => FilterBottomSheet.show(context),
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
      child: CategoryChips(
        onCategorySelected: (category) {
          setState(() {
            selectedCategory = category;
          });
        },
      ),
      ),
      Expanded(
      child: ProductGrid(categoryFilter: selectedCategory),
      ),
      ]
      ),
    );
  }
}

