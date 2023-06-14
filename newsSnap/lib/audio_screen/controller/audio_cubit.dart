import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../articles_screen/model/cnn_article_model.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioStates> {
  AudioCubit() : super(AudioInitStates());

  Future<File?> getAudio(String summarizedArticle, BuildContext context) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      Map<String, dynamic> body = {
        "text": summarizedArticle,
      };
      var provider = Provider.of<CnnArticleModel>(context, listen: false);
      emit(AudioLoadingStates());
      // Uri.parse("http://192.168.1.54:5000/text_to_speech_2"),
      final response = await http.post(
        Uri.parse("http://172.20.10.5:9000/text_to_speech_2"),
        headers: headers,
        body: jsonEncode(body),
      );
      final file = await writeToFile(ByteData.view(response.bodyBytes.buffer));
      provider.setAudio = file;
      emit(AudioSuccessStates());
      return file;
    } catch (e) {
      debugPrint("Caught error while getting audio: ${e.toString()}");
      emit(AudioFailedStates());
      return null;
    }
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/file.wav');
    await file.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }
}
