import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class ExploreVideo extends StatefulWidget {
  final String videoURL;

  ExploreVideo({required this.videoURL});

  @override
  _ExploreVideoState createState() => _ExploreVideoState();
}

class _ExploreVideoState extends State<ExploreVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoURL)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
