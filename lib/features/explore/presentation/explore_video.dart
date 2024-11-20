import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExploreVideo extends StatefulWidget {
  final String videoURL;

  const ExploreVideo({required this.videoURL});

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

  void _videoPlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: _videoPlayPause,
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
}
