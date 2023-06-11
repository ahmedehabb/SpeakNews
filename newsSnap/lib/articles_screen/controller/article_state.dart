import '../../articles_screen/model/cnn_article_model.dart';

abstract class ArticlesStates {}

class ArticlesInitStates extends ArticlesStates {}

class ArticlesLoadingStates extends ArticlesStates {}

class ArticlesSuccessStates extends ArticlesStates {
  List<CnnArticleModel> allArticles;
  ArticlesSuccessStates({
    required this.allArticles,
  });
}

class ArticlesFailedStates extends ArticlesStates {}
