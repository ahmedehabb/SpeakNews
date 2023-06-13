import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newssnap/articles_screen/model/cnn_article_model.dart';
import 'package:newssnap/common_widgets/circular_icon_button.dart';
import 'package:provider/provider.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key, required this.audioFile});
  final File audioFile;
  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    setAudio();
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        position = newPosition;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CnnArticleModel>(context).setAudio = widget.audioFile;
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(DeviceFileSource(widget.audioFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Listen to the article"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Slider(
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      activeColor: Colors.orange,
                      onChanged: (value) async {
                        final pos = Duration(seconds: value.toInt());
                        await audioPlayer.seek(pos);
                        await audioPlayer.resume();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(duration.toString()),
                        Text((duration - position).toString()),
                      ],
                    ),
                    CircularIconButton(
                      icon: isPlaying ? Icons.pause : Icons.play_arrow,
                      iconHeight: 60.h,
                      iconWidth: 60.w,
                      onTap: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      },
                    ),

                    // SoundWaveformWidget(),
                  ],
                )),
          ),
        ));
  }
}
