import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newssnap/articles_screen/controller/emotion_cubit.dart';
import 'package:provider/provider.dart';

import '../articles_screen/controller/articles_cubit.dart';
import '../articles_screen/controller/summary_cubit.dart';
import '../audio_screen/controller/audio_cubit.dart';
import '../video_screen/controller/video_cubit.dart';
import 'articles_screen/model/cnn_article_model.dart';
import 'splash_screen/controller/splash_view_cubit.dart';
import 'splash_screen/view/splash_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const NewsSnap());
}

class NewsSnap extends StatelessWidget {
  const NewsSnap({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.light();
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashViewCubit>(
          create: (context) => SplashViewCubit()..onSplashViewScreenLaunch(),
        ),
        BlocProvider<ArticlesCubit>(
          create: (context) => ArticlesCubit()..getCnnArticles(""),
        ),
        BlocProvider<SummaryCubit>(create: (context) => SummaryCubit()),
        BlocProvider<AudioCubit>(create: (context) => AudioCubit()),
        BlocProvider<VideoCubit>(create: (context) => VideoCubit()),
        BlocProvider<EmotionCubit>(create: (context) => EmotionCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<CnnArticleModel>(
            create: (context) => CnnArticleModel(),
          ),
        ],
        child: ScreenUtilInit(
            designSize: const Size(384.0, 805.3333333333334),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme.copyWith(useMaterial3: true),
                home: const SplashScreen(),
              );
            }),
      ),
    );
  }
}
