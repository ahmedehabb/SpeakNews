import 'dart:io';

import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  String chosenSummaryType = 'extractive';
  int compressionRatio = 50;
  File? imageFile;
  bool isUsingOwnAvatar = false;
  bool isFileImage = true;

  set setSummaryType(String summaryType) {
    chosenSummaryType = summaryType;
    notifyListeners();
  }

  set setCompressionRatio(int compressionRatio) {
    this.compressionRatio = compressionRatio;
    notifyListeners();
  }

  set setImageFile(File imgFile) {
    imageFile = imgFile;
    notifyListeners();
  }

  set setIsUsingOwnAvatar(bool usingOwnAvatar) {
    isUsingOwnAvatar = usingOwnAvatar;
    notifyListeners();
  }

  set setIsFileImage(bool isFileImage) {
    this.isFileImage = isFileImage;
    notifyListeners();
  }

  get getSummaryType => chosenSummaryType;

  get getCompressionRatio => compressionRatio;

  get getImageFile => imageFile;

  get getIsUsingOwnAvatar => isUsingOwnAvatar;

  get getIsFileImage => isFileImage;
}
