import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../home_screen/constants.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoStates> {
  VideoCubit() : super(VideoInitStates());

  Future<File?> getAvatarVideo(File audioFile) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      emit(VideoLoadingStates());
      var request = http.MultipartRequest(
          "POST", Uri.parse("$localBaseUrl:6000/avatar_generation"));
      request.headers.addAll(headers);
      request.files.add(http.MultipartFile.fromBytes(
        'input_audio',
        await audioFile.readAsBytes(),
        filename: 'audio.mp3',
      ));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final file = await writeToFile(ByteData.view(response.bodyBytes.buffer));
      emit(VideoSuccessStates());
      return file;
    } catch (e) {
      debugPrint("Caught error while getting video: ${e.toString()}");
      emit(VideoFailedStates());
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
