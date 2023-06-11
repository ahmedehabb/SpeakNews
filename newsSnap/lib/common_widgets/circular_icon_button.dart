import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularIconButton extends StatelessWidget {
  const CircularIconButton(
      {super.key,
      required this.icon,
      required this.onTap,
      this.iconHeight,
      this.iconWidth});
  final IconData icon;
  final void Function()? onTap;
  final double? iconWidth;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: iconWidth ?? 42.h,
        height: iconHeight ?? 42.h,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
