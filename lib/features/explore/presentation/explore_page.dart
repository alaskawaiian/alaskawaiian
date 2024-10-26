import 'package:flutter/material.dart';

import 'explore_post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            children: [
          ExplorePost(
              username: 'Jenielle',
              caption: 'Aloha Stadium Swap Meet on Oahu!',
              hashtags: '#hawaii #supportlocal',
              videoURL: 'assets/videos/tiktok-aloha-stadium.MP4'),
          ExplorePost(
              username: 'Corban De La Vega',
              caption: 'moving postcards from oahu',
              hashtags: '#hawaii',
              videoURL: 'assets/videos/tiktok-hawaii.MP4'),
          ExplorePost(
              username: 'jasminstanleyy',
              caption: 'Alaska feels like a different planet.',
              hashtags: '#alaskawaiian #alaska',
              videoURL: 'assets/videos/tiktok-alaska.MP4'),
        ]));
  }
}
