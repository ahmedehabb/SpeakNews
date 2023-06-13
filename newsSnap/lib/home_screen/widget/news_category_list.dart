import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../articles_screen/controller/articles_cubit.dart';

import '../model/category_new.dart';
import 'news_category_chip.dart';

class NewsCategoryList extends StatefulWidget {
  final List<CategoryNewsModel> listCategories;
  final int indexDefaultSelected;
  final void Function(int)? changeCategory;
  const NewsCategoryList({
    super.key,
    required this.listCategories,
    required this.indexDefaultSelected,
    this.changeCategory,
  });

  @override
  State<NewsCategoryList> createState() => _NewsCategoryListState();
}

class _NewsCategoryListState extends State<NewsCategoryList> {
  int indexCategorySelected = 0;

  @override
  void initState() {
    indexCategorySelected = widget.indexDefaultSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: widget.listCategories.length,
        itemBuilder: (context, index) {
          var itemCategory = widget.listCategories[index];
          return Padding(
            padding: EdgeInsets.only(
              top: 5.h,
              left: index == 0 ? 0 : 12.w,
            ),
            child: GestureDetector(
              onTap: () {
                if (indexCategorySelected == index) {
                  return;
                }
                setState(() => indexCategorySelected = index);
                widget.changeCategory?.call(index);
                BlocProvider.of<ArticlesCubit>(context)
                    .getCnnArticles(itemCategory.title);
              },
              child: NewsCategoryChip(
                  indexCategorySelected: indexCategorySelected,
                  itemCategory: itemCategory,
                  indexCategoryInList: index),
            ),
          );
        },
      ),
    );
  }
}
