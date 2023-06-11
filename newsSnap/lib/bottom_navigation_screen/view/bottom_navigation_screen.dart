import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newssnap/bookmark_screen/view/bookmark_screen.dart';

import '../../home_screen/constants.dart';
import '../../home_screen/view/home.dart';
import '../widget/bottom_navbar_icon.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int pageIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  final pages = [
    const HomeScreen(),
    const BookmarkScreen(),
  ];

  void changePageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: PageView(
        controller: pageController,
        onPageChanged: (newIndex) => changePageIndex(newIndex),
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Container(
                height: 60.h,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BottomNavBarIcon(
                      pageIndex: pageIndex,
                      myIcon: Icons.home_outlined,
                      onTap: () => changePageIndex(0),
                      myIndex: 0,
                    ),
                    BottomNavBarIcon(
                      pageIndex: pageIndex,
                      myIcon: Icons.bookmark_outline,
                      onTap: () => changePageIndex(1),
                      myIndex: 1,
                    ),
                  ],
                ))),
      ),
    );
  }
}
