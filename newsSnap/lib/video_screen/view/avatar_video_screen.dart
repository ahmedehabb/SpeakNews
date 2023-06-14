import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newssnap/common_widgets/loading_widget.dart';
import 'package:video_player/video_player.dart';

class AvatarVideoScreen extends StatefulWidget {
  const AvatarVideoScreen({super.key, required this.videoFile});

  final File videoFile;

  @override
  State<AvatarVideoScreen> createState() => _AvatarVideoScreenState();
}

class _AvatarVideoScreenState extends State<AvatarVideoScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.videoFile);
    _initializeVideoPlayerFuture = _controller.initialize();
    // _controller.setLooping(true);

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   Provider.of<CnnArticleModel>(context, listen: false).setVideo =
    //       widget.videoFile;
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Video'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const LoadingWidget();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
