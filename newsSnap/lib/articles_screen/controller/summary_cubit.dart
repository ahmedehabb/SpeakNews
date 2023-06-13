import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/cnn_article_model.dart';
import 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryStates> {
  SummaryCubit() : super(SummaryInitStates());

  Future<String?> getSummary(
      String articleContent, BuildContext context) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      emit(SummaryLoadingStates());
      Map<String, String> body = {
        "sentence": articleContent,
      };
      var provider = Provider.of<CnnArticleModel>(context, listen: false);
      final response = await http.post(
        Uri.parse("http://192.168.1.15:1000/abstractive"),
        headers: headers,
        body: jsonEncode(body),
      );
      String formattedSummary = jsonDecode(response.body)[0];
      formattedSummary = formattedSummary.replaceAll("<q>", ". ");
      formattedSummary = capitalize(formattedSummary);
      debugPrint("Summary response: ${response.body}");
      emit(SummarySuccessStates());
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
