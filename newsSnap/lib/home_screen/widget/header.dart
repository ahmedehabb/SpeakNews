import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 100.h,
            color: const Color(0xff720040),
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to NewsSnap ",
                style:
                    TextStyle(fontSize: 22.sp, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 250.w,
                child: Text(
                  "Capture the World in a Snap!",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style:
                      TextStyle(fontSize: 22.sp, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
