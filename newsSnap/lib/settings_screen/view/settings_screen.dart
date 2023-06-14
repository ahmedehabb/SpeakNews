import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newssnap/common_widgets/circular_icon_button.dart';
import 'package:newssnap/settings_screen/model/settings_model.dart';
import 'package:provider/provider.dart';

import '../../home_screen/constants.dart';

enum SummaryType { abstractive, extractive }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _currentSliderValue = 100;
  SummaryType? summarizationType;
  bool isUsingOwnAvatar = false;

  File? imageTest;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imageTest = imageTemp);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: ${e.toString()}');
    }
  }

  dynamic image;
  final picker = ImagePicker();
  String? img64;
  File? imgFile;
  bool isFileImage = true;

  Future<void> _imgFromCamera(context) async {
    var provider = Provider.of<SettingsModel>(context, listen: false);
    XFile? image_ = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 20,
    );
    setState(() {
      imgFile = File(image_!.path);
      isFileImage = true;
    });
    provider.setImageFile = imgFile!;
    provider.setIsFileImage = true;
  }

  Future<void> _imgFromGallery(context) async {
    var provider = Provider.of<SettingsModel>(context, listen: false);
    XFile? image_ = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    setState(() {
      imgFile = File(image_!.path);
      isFileImage = true;
    });
    provider.setImageFile = imgFile!;
    provider.setIsFileImage = true;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<SettingsModel>(context, listen: false);
      summarizationType = provider.getSummaryType == "abstractive"
          ? SummaryType.abstractive
          : SummaryType.extractive;
      int x = provider.getCompressionRatio;
      setState(() {});
      isUsingOwnAvatar = provider.getIsUsingOwnAvatar;
      imgFile = provider.getImageFile;
      _currentSliderValue = x.toDouble();
      isFileImage = provider.getIsFileImage;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: appbarTextStyle,
        ),
        leading:
            CircularIconButton(icon: Icons.arrow_back, onTap: () => Get.back()),
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: ListView(
            children: [
              Text(
                'Note that in the extractive summary, the sentences are directly extracted from the original text without any rephrasing or modification. On the other hand, the abstractive summary includes a more concise and paraphrased version of the original information, presenting it in a way that captures the key points while using different wording.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.aBeeZee(
                  letterSpacing: 0.4,
                  fontSize: 17,
                  height: 1.2,
                ),
              ),
              ListTile(
                title: const Text('Abstractive'),
                leading: Radio<SummaryType>(
                  value: SummaryType.abstractive,
                  groupValue: summarizationType,
                  onChanged: (value) {
                    setState(() {
                      summarizationType = value;
                    });
                    settingsProvider.setSummaryType = 'abstractive';
                  },
                ),
              ),
              ListTile(
                title: const Text('Extractive'),
                leading: Radio<SummaryType>(
                  value: SummaryType.extractive,
                  groupValue: summarizationType,
                  onChanged: (value) {
                    setState(() {
                      summarizationType = value;
                    });
                    settingsProvider.setSummaryType = 'extractive';
                  },
                ),
              ),
              Visibility(
                visible: summarizationType == SummaryType.extractive,
                child: Column(
                  children: [
                    const Text('Compression Ratio'),
                    Slider(
                      value: _currentSliderValue,
                      min: 1,
                      max: 100,
                      divisions: 100,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                      onChangeEnd: (value) {
                        settingsProvider.setCompressionRatio = value.toInt();
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Use your own avatar'),
                trailing: Checkbox(
                  value: isUsingOwnAvatar,
                  onChanged: (val) {
                    settingsProvider.setIsUsingOwnAvatar = val!;
                    setState(() {
                      isUsingOwnAvatar = val;
                    });
                  },
                ),
              ),
              FilledButton(
                onPressed: () {
                  _imgFromGallery(context);
                },
                child: const Text('Pick image from gallery'),
              ),
              FilledButton(
                onPressed: () {
                  _imgFromCamera(context);
                },
                child: const Text('Pick image from camera'),
              ),
              if (imgFile != null && isFileImage) ...[
                SizedBox(
                  height: 400,
                  width: 350,
                  child: Image.file(imgFile!),
                ),
              ]
            ],
          )),
    );
  }
}
