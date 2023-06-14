import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home_screen/constants.dart';
import '../model/cnn_article_model.dart';
import '../view/article_details.dart';

class LargeArticle extends StatelessWidget {
  const LargeArticle({super.key, required this.article});

  final CnnArticleModel article;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.to(
          () => ArticleDetails(
            article: article,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 420.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: NetworkImage(
              article.urlToImage!,
            ),
            fit: BoxFit.contain,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 420.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.0),
              ],
              stops: const [
                0.0,
                0.8,
              ],
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text(
                  article.title!,
                  style: TextStyle(
                    color: thirdColor,
                    fontSize: 21.sp,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      constraints:
                          BoxConstraints(minWidth: 60.w, maxWidth: 70.w),
                      child: Text(
                        article.publishedAt!,
                        style: TextStyle(
                          color: fourthColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        ' | ',
                        style: TextStyle(
                          color: fourthColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(minWidth: 100.w, maxWidth: 200.w),
                      child: Text(
                        article.author!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: fourthColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
