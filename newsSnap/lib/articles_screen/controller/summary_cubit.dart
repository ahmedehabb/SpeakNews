import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:newssnap/settings_screen/model/settings_model.dart';
import 'package:provider/provider.dart';

import '../model/cnn_article_model.dart';
import 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryStates> {
  SummaryCubit() : super(SummaryInitStates());

  Future<String?> getSummary(
      String articleContent, BuildContext context) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    String summaryType =
        Provider.of<SettingsModel>(context, listen: false).getSummaryType;
    int compressionRatio =
        Provider.of<SettingsModel>(context, listen: false).getCompressionRatio;
    try {
      emit(SummaryLoadingStates());
      Map<String, String> body = {
        "sentence": articleContent,
      };
      var provider = Provider.of<CnnArticleModel>(context, listen: false);
      final response = await http.post(
        Uri.parse("http://172.20.10.5:1000/$summaryType"),
        headers: headers,
        body: jsonEncode(body),
      );
      String formattedSummary = jsonDecode(response.body)[0];
      formattedSummary = formattedSummary.replaceAll("<q>", ". ");
      formattedSummary = capitalize(formattedSummary);
      debugPrint("Summary response: ${response.body}");
      emit(SummarySuccessStates());
      if (summaryType == 'extractive') {
        List<String> sentences = formattedSummary.split(".");
        int length = sentences.length;
        length = (length * (1 - compressionRatio / 100)).toInt();
        sentences = sentences.sublist(0, max(length, 1));
        formattedSummary = sentences.join(".");
      }

      provider.setSummary = formattedSummary;
      return formattedSummary;
    } catch (e) {
      debugPrint("Caught error while getting summary: ${e.toString()}");
      emit(SummaryFailedStates());
      return null;
    }
  }

  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }
}
