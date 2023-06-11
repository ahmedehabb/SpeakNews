import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:newssnap/articles_screen/model/cnn_article_model.dart';
import 'package:provider/provider.dart';

import 'emotion_state.dart';

class EmotionCubit extends Cubit<EmotionStates> {
  EmotionCubit() : super(EmotionInitStates());
  Future<void> getEmotion(String articleContent, BuildContext context) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    print("Start emotion");
    try {
      emit(EmotionLoadingStates());
      Map<String, String> body = {
        "text": articleContent,
      };
      var response = await http.post(
        Uri.parse("http://192.168.1.15:2000/sentiment"),
        headers: headers,
        body: jsonEncode(body),
      );
      print("Emotion response: ${response.body}");
      var decodedResponse = jsonDecode(response.body);
      print("Decoded response: $decodedResponse");
      if (context.mounted) {
        print('mounted in emotion');
        Provider.of<CnnArticleModel>(context, listen: false).setEmotion =
            decodedResponse['prediction'];
        Provider.of<CnnArticleModel>(context, listen: false)
            .setEmotionAccuracy = decodedResponse['probability'];
      }
      emit(EmotionSuccessStates());
    } catch (e) {
      debugPrint("Caught error while getting emotion: ${e.toString()}");
      emit(EmotionFailedStates());
    }
  }
}
