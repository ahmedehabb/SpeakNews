import 'dart:io';

import 'package:flutter/material.dart';

class CnnArticleModel extends ChangeNotifier {
  String? id;
  String? title;
  String? url;
  String? urlToImage;
  String? content;
  String? author;
  String? publishedAt;
  String? summary;
  File? audio;
  File? video;
  String emotion = "";
  double emotionAccuracy = 0.0;

  CnnArticleModel({
    this.id,
    this.title,
    this.url,
    this.urlToImage,
    this.content,
    this.author,
    this.publishedAt,
    this.audio,
    this.video,
  });

  set setSummary(String? summary) {
    this.summary = summary;
    notifyListeners();
  }

  set setAudio(File? audio) {
    this.audio = audio;
    notifyListeners();
  }

  set setVideo(File? video) {
    this.video = video;
    notifyListeners();
  }

  set setEmotion(String emotion) {
    this.emotion = emotion;
    notifyListeners();
  }

  set setEmotionAccuracy(double emotionAccuracy) {
    this.emotionAccuracy = emotionAccuracy;
    notifyListeners();
  }

  get getSummary => summary;

  get getAudio => audio;

  get getVideo => video;

  get getEmotion => emotion;

  get getEmotionAccuracy => emotionAccuracy;

  factory CnnArticleModel.fromJson(Map<String, dynamic> json) {
    return CnnArticleModel(
      id: json['_id'] ?? "",
      title: json['headline'] ?? "",
      content: json['body'] ?? "",
      author: json['byLine'] ?? "CNN",
      url: json['url'] ?? "",
      urlToImage: json['thumbnail'] ?? "",
      publishedAt: json['lastPublishDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'headline': title,
        'body': content,
        'byLine': author,
        'url': url,
        'thumbnail': urlToImage,
        'lastPublishDate': publishedAt,
      };
}
