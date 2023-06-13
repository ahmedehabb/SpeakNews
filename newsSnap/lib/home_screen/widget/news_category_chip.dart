import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/category_new.dart';

class NewsCategoryChip extends StatelessWidget {
  const NewsCategoryChip({
    super.key,
    required this.indexCategorySelected,
    required this.itemCategory,
    required this.indexCategoryInList,
  });

  final int indexCategorySelected;
  final int indexCategoryInList;
  final CategoryNewsModel itemCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: (indexCategorySelected == indexCategoryInList)
            ? Colors.orange
            : Colors.white,
      ),
      child: Center(
        child: Text(
          itemCategory.title,
          style: TextStyle(
              color: (indexCategorySelected == indexCategoryInList)
                  ? Colors.white
                  : Colors.black),
        ),
      ),
    );
  }
}
