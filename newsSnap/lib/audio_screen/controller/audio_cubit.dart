import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:newssnap/home_screen/constants.dart';
import 'package:path_provider/path_provider.dart';

import 'audio_state.dart';

class AudioCubit extends Cubit<AudioStates> {
  AudioCubit() : super(AudioInitStates());

  Future<File?> getAudio(String summarizedArticle) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      Map<String, dynamic> body = {
        "text": summarizedArticle,
      };
      emit(AudioLoadingStates());
      final response = await http.post(
        Uri.parse("$localBaseUrl:5000/text_to_speech"),
        headers: headers,
        body: jsonEncode(body),
      );
      final file = await writeToFile(ByteData.view(response.bodyBytes.buffer));
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
    File file = File('$tempPath/file.png');
    await file.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }
}
