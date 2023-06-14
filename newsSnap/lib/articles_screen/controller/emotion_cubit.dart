import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:newssnap/articles_screen/model/cnn_article_model.dart';
import 'package:newssnap/home_screen/constants.dart';
import 'package:provider/provider.dart';

import 'emotion_state.dart';

class EmotionCubit extends Cubit<EmotionStates> {
  EmotionCubit() : super(EmotionInitStates());
  Future<int> getEmotion(String articleContent, BuildContext context) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      var provider = Provider.of<CnnArticleModel>(context, listen: false);
      emit(EmotionLoadingStates());
      Map<String, String> body = {
        "text": articleContent,
      };
      var response = await http.post(
        Uri.parse("http://172.20.10.5:2000/sentiment"),
        headers: headers,
        body: jsonEncode(body),
      );
      var decodedResponse = jsonDecode(response.body);
      debugPrint("Decoded response: $decodedResponse");
      int? emotionIndex = 2;

      if (decodedResponse['probability'] >= 0.43) {
        String emotion = decodedResponse['prediction'];
        emotionIndex = emotionMap[emotion];
      }
      provider.setEmotionIndex = emotionIndex!;
      provider.setEmotion = decodedResponse['prediction'];
      provider.setEmotionAccuracy = decodedResponse['probability'];
      emit(EmotionSuccessStates());
      return emotionIndex;
    } catch (e) {
      debugPrint("Caught error while getting emotion: ${e.toString()}");
      emit(EmotionFailedStates());
      return 2;
    }
  }
}
