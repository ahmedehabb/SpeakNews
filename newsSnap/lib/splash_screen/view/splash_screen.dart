import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../bottom_navigation_screen/view/bottom_navigation_screen.dart';

import '../controller/splash_view_cubit.dart';
import '../controller/splash_view_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewCubit, SplashViewStates>(
        listener: (context, state) async {
          if (state is UserNotSeenSplashScreen) {
            Get.off(() => const BottomNavigationScreen());
          } else {
            // Get.off(() => const HomeScreen());
          }
        },
        child: Scaffold(
          body: Center(
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              padding: EdgeInsets.only(
                top: 250.h,
                left: 40.w,
                right: 40.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Welcome to SpeakNews',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Image.asset(
                    "assets/show_news_boy.gif",
                    height: 170.0,
                    width: 170.0,
                  ),
                  Image.asset(
                    "assets/app_logo_without_background.png",
                    height: 150.0,
                    width: 150.0,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
