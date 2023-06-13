class ArticleModel {
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  String author;

  ArticleModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
    required this.author,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      url: json['url'] ?? "",
      urlToImage: json['urlToImage'] ?? "",
      content: json['content'] ?? "",
      author: json['author'] ?? "",
    );
  }
}
