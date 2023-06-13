import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newssnap/home_screen/constants.dart';

import '../../articles_screen/view/all_articles.dart';
import '../model/category_new.dart';
import '../widget/news_category_list.dart';
import '../widget/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final listCategories = <CategoryNewsModel>[
    CategoryNewsModel(image: '', title: 'All'),
    CategoryNewsModel(image: 'assets/img_business.png', title: 'Business'),
    CategoryNewsModel(
        image: 'assets/img_entertainment.png', title: 'Entertainment'),
    CategoryNewsModel(image: 'assets/img_health.png', title: 'Health'),
    CategoryNewsModel(image: 'assets/img_science.png', title: 'Science'),
    CategoryNewsModel(image: 'assets/img_sport.png', title: 'Sports'),
    CategoryNewsModel(image: 'assets/img_technology.png', title: 'Technology'),
  ];

  int indexCategorySelected = 0;
  String searchQuery = "";

  void changeCategory(int index) {
    setState(() {
      indexCategorySelected = index;
    });
  }

  void changeSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Breaking News",
          style: appbarTextStyle,
        ),
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: null,
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: SearchWidget(
                    changeSearchQuery: changeSearchQuery,
                  )),
              Visibility(
                visible: searchQuery == "",
                child: NewsCategoryList(
                  listCategories: listCategories,
                  indexDefaultSelected: indexCategorySelected,
                  changeCategory: changeCategory,
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                flex: 8,
                child: AllNewsContent(
                  query: (searchQuery == "")
                      ? listCategories[indexCategorySelected].title
                      : searchQuery,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
