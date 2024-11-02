import 'package:flutter/material.dart';
import 'package:youtube_shorts/youtube_shorts.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final ShortsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ShortsController(
      youtubeVideoSourceController: VideosSourceController.fromUrlList(
      videoIds: [
          'https://www.youtube.com/shorts/PiWJWfzVwjU',
          'https://www.youtube.com/shorts/AeZ3dmC676c',
          'https://www.youtube.com/shorts/L1lg_lxUxfw',
          'https://www.youtube.com/shorts/OWPsdhLHK7c'
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubeShortsPage(
      controller: _controller
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
