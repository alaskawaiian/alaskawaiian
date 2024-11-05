import 'package:flutter/material.dart';
import './explore_post.dart';
import '../../../youtube_shorts_fork/youtube_explode_fork/youtube_explode_dart.dart';
import '../../../youtube_shorts_fork/youtube_shorts.dart';

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
        videosWillBeInLoop: false,
        youtubeVideoSourceController:
            VideosSourceController.fromMultiYoutubeChannels(
                channelsName: ['@AlaskaAirlines', '@HawaiianAirlines']));
  }

  @override
  Widget build(BuildContext context) {
    return YoutubeShortsPage(
      controller: _controller,
      videoBuilder: (
        int index,
        PageController pageController,
        VideoController videoController,
        Video videoData,
        MuxedStreamInfo hostedVideoInfo,
        Widget child,
      ) {
        return ExplorePost(
            author: videoData.author,
            description: videoData.description,
            child: child);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
