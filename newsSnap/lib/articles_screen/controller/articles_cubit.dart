import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_screen/constants.dart';
import '../controller/article_state.dart';
import '../model/cnn_article_model.dart';

class ArticlesCubit extends Cubit<ArticlesStates> {
  ArticlesCubit() : super(ArticlesInitStates());

  Future<List<CnnArticleModel>> getCnnArticles(String query) async {
    final dio = Dio();

    Map<String, String> headers = {"Content-Type": "application/json"};
    List<CnnArticleModel> allArticles = [];
    try {
      emit(ArticlesLoadingStates());
      final response = await dio.get(
          "$cnnBaseUrl?q=$query&size=150&from=1&page=1&sort=newest",
          options: Options(headers: headers));
      if (response.data['message'] == "success") {
        for (var article in response.data['result']) {
          if (article['body'].toString().split(" ").length < 100) {
            continue;
          }
          String formattedDate = "";
          if (article['lastPublishDate'] != null) {
            DateTime date = DateTime.parse(article['lastPublishDate']);
            formattedDate = "${date.day}/${date.month}/${date.year}";
          }
          article['lastPublishDate'] = formattedDate;
          allArticles.add(CnnArticleModel.fromJson(article));
        }
        emit(ArticlesSuccessStates(allArticles: allArticles));
        return allArticles;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  // static Future<List<ArticleModel>> getAllArticles(String query) async {
  //   final dio = Dio();

  //   Map<String, String> headers = {"Content-Type": "application/json"};
  //   List<ArticleModel> allArticles = [];
  //   final response = await dio.get("$baseUrl?apiKey=$apiKey&q=$query",
  //       options: Options(headers: headers));

  //   if (response.data['status'] == "ok") {
  //     for (var article in response.data['articles']) {
  //       if (article['content'].toString().split(" ").length < 200) {
  //         continue;
  //       }
  //       allArticles.add(ArticleModel.fromJson(article));
  //     }
  //     return allArticles;
  //   } else {
  //     return [];
  //   }
  // }
}
