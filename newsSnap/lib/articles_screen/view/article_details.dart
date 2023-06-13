import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newssnap/common_widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../audio_screen/controller/audio_cubit.dart';
import '../../audio_screen/controller/audio_state.dart';
import '../../audio_screen/view/audio_screen.dart';
import '../../bookmark_screen/controller/database_helper.dart';
import '../../common_widgets/circular_icon_button.dart';
import '../../video_screen/controller/video_cubit.dart';
import '../../video_screen/controller/video_state.dart';
import '../../video_screen/view/avatar_video_screen.dart';
import '../controller/summary_cubit.dart';
import '../model/cnn_article_model.dart';

class ArticleDetails extends StatefulWidget {
  const ArticleDetails({super.key, required this.article});
  final CnnArticleModel article;

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  bool showSummary = true;

  Future<String> getSummary(BuildContext context) async {
    String? summarizedContent = await BlocProvider.of<SummaryCubit>(context)
        .getSummary(widget.article.content!, context);
    return summarizedContent!;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getSummary(context).then((summarizedContent) {
        Provider.of<CnnArticleModel>(context, listen: false).setSummary =
            summarizedContent;
        Get.snackbar(
          "Done",
          "Summary is ready 🎉",
          backgroundColor: Colors.green,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? articleText = showSummary
        ? Provider.of<CnnArticleModel>(context).getSummary ??
            widget.article.content!
        : widget.article.content!;
    return BlocBuilder<VideoCubit, VideoStates>(
      builder: (context, videoState) {
        return BlocBuilder<AudioCubit, AudioStates>(
            builder: (context, audioState) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(ScreenUtil().screenWidth, 300.h),
                child: SafeArea(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.article.urlToImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CircularIconButton(
                              icon: Icons.arrow_back, onTap: () => Get.back())
                          .marginOnly(right: 335.w, top: 5.h, left: 5.w),
                      CircularIconButton(
                          icon: Icons.more_horiz,
                          onTap: () {
                            debugPrint("More button pressed");
                            Get.bottomSheet(
                              backgroundColor: Colors.white,
                              SizedBox(
                                height: 200.h,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0.h,
                                    horizontal: 5.w,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint(
                                                  "Share button pressed");
                                              Share.share(widget.article.url!);
                                            },
                                            child: Container(
                                              width: 160.w,
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.ios_share_outlined,
                                                      color: Colors.white),
                                                  Text('Share',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          GestureDetector(
                                            onTap: () {
                                              DatabaseHelper.instance
                                                  .addBookmark(widget.article);
                                              Get.snackbar(
                                                "Bookmarked",
                                                "Article saved to bookmarks",
                                                backgroundColor: Colors.green,
                                              );
                                            },
                                            child: Container(
                                              width: 160.w,
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.bookmark_outline,
                                                      color: Colors.white),
                                                  Text('Bookmark',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showSummary = !showSummary;
                                          });
                                          Get.back();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.h),
                                          child: Container(
                                              width: ScreenUtil().screenWidth,
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                showSummary
                                                    ? 'Show original'
                                                    : 'Show summary',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).marginOnly(right: 5.w, top: 5.h, left: 335.w),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.article.title!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.article.publishedAt!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        flex: 6,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                articleText!,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.aBeeZee(
                                  letterSpacing: 0.4,
                                  fontSize: 18,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (audioState is AudioLoadingStates) ...[
                              const LoadingWidget()
                            ] else ...[
                              FilledButton(
                                onPressed: () async {
                                  debugPrint("Listen button pressed");
                                  File? audioInArticle =
                                      Provider.of<CnnArticleModel>(context,
                                              listen: false)
                                          .getAudio;
                                  if (audioInArticle == null) {
                                    File? audioFile = await context
                                        .read<AudioCubit>()
                                        .getAudio(articleText);
                                    if (audioFile == null) {
                                      Get.snackbar(
                                        "Error",
                                        "Audio could not be generated",
                                        backgroundColor: Colors.red,
                                      );
                                    } else {
                                      Get.to(() =>
                                          AudioScreen(audioFile: audioFile));
                                    }
                                  } else {
                                    Get.to(() =>
                                        AudioScreen(audioFile: audioInArticle));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange),
                                ),
                                child: Text(
                                    Provider.of<CnnArticleModel>(context)
                                                .getAudio ==
                                            null
                                        ? "Generate Audio"
                                        : "Listen to Audio"),
                              ),
                            ],
                            if (audioState is AudioLoadingStates ||
                                videoState is VideoLoadingStates) ...[
                              const LoadingWidget()
                            ] else ...[
                              FilledButton(
                                onPressed: () async {
                                  File? videoInArticle =
                                      Provider.of<CnnArticleModel>(context,
                                              listen: false)
                                          .getVideo;
                                  File? audioInArticle =
                                      Provider.of<CnnArticleModel>(context,
                                              listen: false)
                                          .getAudio;
                                  if (videoInArticle == null &&
                                      audioInArticle == null) {
                                    File? videoFile = await context
                                        .read<AudioCubit>()
                                        .getAudio(articleText)
                                        .then(
                                      (audioFile) async {
                                        if (audioFile == null) {
                                          return null;
                                        }
                                        return await context
                                            .read<VideoCubit>()
                                            .getAvatarVideo(audioFile);
                                      },
                                    );
                                    if (videoFile == null) {
                                      Get.snackbar(
                                        "Error",
                                        "Video could not be generated",
                                        backgroundColor: Colors.red,
                                      );
                                    } else {
                                      Get.to(() => AvatarVideoScreen(
                                            videoFile: videoFile,
                                          ));
                                    }
                                  } else if (videoInArticle == null) {
                                    File? videoFile = await context
                                        .read<VideoCubit>()
                                        .getAvatarVideo(audioInArticle!);
                                    if (videoFile == null) {
                                      Get.snackbar(
                                        "Error",
                                        "Video could not be generated",
                                        backgroundColor: Colors.red,
                                      );
                                    } else {
                                      Get.to(() => AvatarVideoScreen(
                                            videoFile: videoFile,
                                          ));
                                    }
                                  } else {
                                    Get.to(() => AvatarVideoScreen(
                                          videoFile: videoInArticle,
                                        ));
                                  }
                                  debugPrint("Watch button pressed");
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange),
                                ),
                                child: Text(
                                    Provider.of<CnnArticleModel>(context)
                                                .getVideo ==
                                            null
                                        ? "Generate Video"
                                        : "Watch Avatar Video"),
                              ),
                            ]
                          ],
                        ),
                      ),
                      //  Flexible(flex: 4, child: const EgyptHorizontalArticles()),
                    ],
                  ),
                ),
              ));
        });
      },
    );
  }
}
