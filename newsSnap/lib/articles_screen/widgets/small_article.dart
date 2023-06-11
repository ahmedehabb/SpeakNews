import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../model/cnn_article_model.dart';
import '../view/article_details.dart';

class SmallArticle extends StatelessWidget {
  const SmallArticle({super.key, required this.article});

  final CnnArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 8.h,
      ),
      child: GestureDetector(
        onTap: () async {
          Provider.of<CnnArticleModel>(context, listen: false).setAudio = null;
          Provider.of<CnnArticleModel>(context, listen: false).setVideo = null;
          Provider.of<CnnArticleModel>(context, listen: false).setSummary =
              null;

          Get.to(
            () => ArticleDetails(
              article: article,
            ),
          );
        },
        child: Card(
          elevation: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 100.w,
                      errorBuilder: (context, url, error) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/img_not_found.jpg',
                            fit: BoxFit.cover,
                            width: 200.w,
                            height: 200.w,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          article.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: 70.w, maxWidth: 80.w),
                              child: Text(
                                article.publishedAt!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                ' | ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: 80.w, maxWidth: 90.w),
                              child: Text(
                                article.author!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
