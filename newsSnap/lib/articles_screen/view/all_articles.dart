import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newssnap/articles_screen/widgets/large_article.dart';
import 'package:newssnap/articles_screen/widgets/small_article.dart';

import '../../common_widgets/loading_widget.dart';
import '../controller/article_state.dart';
import '../controller/articles_cubit.dart';

class AllNewsContent extends StatelessWidget {
  const AllNewsContent({super.key, this.query = "trending"});
  final String query;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<ArticlesCubit>(context).getCnnArticles(query);
      },
      child:
          BlocBuilder<ArticlesCubit, ArticlesStates>(builder: (context, state) {
        if (state is ArticlesLoadingStates) {
          return const LoadingWidget();
        } else if (state is ArticlesSuccessStates &&
            state.allArticles.isNotEmpty) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return LargeArticle(
                                article: state.allArticles[index]);
                          } else {
                            return SmallArticle(
                                article: state.allArticles[index]);
                          }
                        },
                        childCount: state.allArticles.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text("No articles found."));
        }
      }),
    );
  }
}
