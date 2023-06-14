import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../articles_screen/model/cnn_article_model.dart';
import '../../settings_screen/model/settings_model.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoStates> {
  VideoCubit() : super(VideoInitStates());

  Future<File?> getAvatarVideo(File audioFile, BuildContext context) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      emit(VideoLoadingStates());
      var provider = Provider.of<CnnArticleModel>(context, listen: false);
      var settingsProvider = Provider.of<SettingsModel>(context, listen: false);
      var request = http.MultipartRequest(
          "POST", Uri.parse("http://172.20.10.5:8000/avatar_generation"));
      request.headers.addAll(headers);
      request.files.add(http.MultipartFile.fromBytes(
        'input_audio',
        await audioFile.readAsBytes(),
        filename: 'audio.mp3',
      ));
      File? faceFile = settingsProvider.getImageFile;
      debugPrint(settingsProvider.getIsUsingOwnAvatar.toString());
      debugPrint(faceFile.toString());
      if (settingsProvider.getIsUsingOwnAvatar && faceFile != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'input_face',
          await faceFile.readAsBytes(),
          filename: 'face.jpeg',
        ));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final file = await writeToFile(ByteData.view(response.bodyBytes.buffer));
      provider.setVideo = file;
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
    File file = File('$tempPath/file.mp4');
    await file.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }
}
