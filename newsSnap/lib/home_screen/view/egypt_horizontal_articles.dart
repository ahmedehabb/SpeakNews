import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newssnap/common_widgets/loading_widget.dart';

import '../../articles_screen/controller/articles_cubit.dart';
import '../../articles_screen/model/cnn_article_model.dart';
import '../../articles_screen/view/article_details.dart';

class EgyptHorizontalArticles extends StatelessWidget {
  const EgyptHorizontalArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CnnArticleModel>>(
        future: BlocProvider.of<ArticlesCubit>(context).getCnnArticles("egypt"),
        builder: (BuildContext context,
            AsyncSnapshot<List<CnnArticleModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                          () => ArticleDetails(article: snapshot.data![index]));
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  width: 200.w,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data![index].urlToImage!),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 200.w,
                            child: Flexible(
                              child: Text(
                                snapshot.data![index].title!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }));
          } else {
            return const Center(child: Text("No articles found"));
          }
        });
  }
}
