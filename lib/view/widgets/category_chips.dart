import 'package:flutter/material.dart';
import 'package:nexusstore/utils/app_textstyles.dart';

class CategoryChips extends StatefulWidget {
  final Function(String)? onCategorySelected;

  const CategoryChips({super.key, this.onCategorySelected});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int selectIndex = 0;
  final categories = ['All', 'Footwear', 'Electronics', 'Clothing', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ChoiceChip(
                label: Text(
                  categories[index],
                  style: AppTextStyle.withColor(
                    selectIndex == index
                        ? AppTextStyle.withWeight(
                            AppTextStyle.bodySmall,
                            FontWeight.w600,
                          )
                        : AppTextStyle.bodySmall,
                    selectIndex == index
                        ? Colors.white
                        : isDark
                            ? Colors.grey[300]!
                            : Colors.grey[600]!,
                  ),
                ),
                selected: selectIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    selectIndex = selected ? index : selectIndex;
                  });
                  if (widget.onCategorySelected != null) {
                    widget.onCategorySelected!(categories[selectIndex]);
                  }
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: selectIndex == index ? 2 : 0,
                pressElevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(
                  color: selectIndex == index
                      ? Colors.transparent
                      : isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


