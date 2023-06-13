import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newssnap/articles_screen/controller/article_state.dart';
import 'package:newssnap/home_screen/constants.dart';

import '../../articles_screen/controller/articles_cubit.dart';
import '../../common_widgets/loading_widget.dart';
import 'article_details.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key, this.query = ""});

  final String query;

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 10.0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesCubit, ArticlesStates>(
        builder: (context, state) {
      if (state is ArticlesLoadingStates) {
        return const LoadingWidget();
      } else if (state is ArticlesSuccessStates) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: RawScrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thumbColor: firstColor,
              thickness: 3.5,
              radius: const Radius.circular(5),
              mainAxisMargin: 5,
              crossAxisMargin: 0.8,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.allArticles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            ArticleDetails(article: state.allArticles[index]));
                      },
                      child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      state.allArticles[index].urlToImage!,
                                    ),
                                  ),
                                ),
                                Flexible(child: SizedBox(width: 1.w)),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        state.allArticles[index].title!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // FilledButton(
                                      //     onPressed: () {
                                      //       Get.to(() => ArticleDetails(
                                      //           article:
                                      //               state.allArticles[index]));
                                      //     },
                                      //     child: const Text("Summarize"))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  }),
            ),
          ),
        );
      } else {
        return const Center(child: Text("No articles found"));
      }
    });
  }
}
