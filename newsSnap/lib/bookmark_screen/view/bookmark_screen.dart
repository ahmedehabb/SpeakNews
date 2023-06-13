import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newssnap/articles_screen/model/cnn_article_model.dart';
import 'package:newssnap/bookmark_screen/controller/database_helper.dart';
import 'package:newssnap/common_widgets/loading_widget.dart';

import '../../articles_screen/widgets/small_article.dart';
import '../../common_widgets/circular_icon_button.dart';
import '../../home_screen/constants.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CnnArticleModel>>(
        future: DatabaseHelper.instance.getBookmarkedArticles(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingWidget();
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No bookmarked articles"),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Bookmarks",
                  style: appbarTextStyle,
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Stack(
                      children: [
                        SmallArticle(article: snapshot.data![index]),
                        CircularIconButton(
                          icon: Icons.delete_outline,
                          onTap: () {
                            setState(() {
                              DatabaseHelper.instance
                                  .removeBookmark(snapshot.data![index]);
                            });
                            Get.snackbar(
                              "Removed from bookmarks",
                              "Article removed from bookmarks",
                              backgroundColor: Colors.green,
                            );
                          },
                        )
                      ],
                    );
                  }),
                ),
              ),
            );
          }
        }));
  }
}
