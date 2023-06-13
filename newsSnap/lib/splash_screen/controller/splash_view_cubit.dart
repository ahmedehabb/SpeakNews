import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_view_state.dart';

class SplashViewCubit extends Cubit<SplashViewStates> {
  SplashViewCubit() : super(SplashViewInitState());

  void onSplashViewScreenLaunch() async {
    await Future.delayed(const Duration(seconds: 4));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool onboardingState = preferences.getBool('seenSplashScreen') ?? false;
    if (onboardingState) {
      emit(UserSeenSplashScreen());
    } else {
      emit(UserNotSeenSplashScreen());
    }
  }

  void onAppClosed() {
    emit(SplashViewInitState());
  }
}
