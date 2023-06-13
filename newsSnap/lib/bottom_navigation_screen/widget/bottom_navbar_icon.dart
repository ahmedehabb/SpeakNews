import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBarIcon extends StatelessWidget {
  const BottomNavBarIcon(
      {super.key,
      required this.pageIndex,
      required this.myIcon,
      required this.onTap,
      required this.myIndex});

  final int pageIndex;
  final int myIndex;
  final IconData myIcon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          color: (pageIndex == myIndex) ? Colors.orange : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Icon(
          myIcon,
          color: (pageIndex == myIndex) ? Colors.white : Colors.black,
          size: (pageIndex == myIndex) ? 40.sp : 30.sp,
        ),
      ),
    );
  }
}
