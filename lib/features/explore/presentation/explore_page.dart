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
              likes: '9,456',
              comments: '45',
              saves: '123',
              shares: '98',
              videoURL: 'assets/videos/tiktok-aloha-stadium.MP4'),
          ExplorePost(
              username: 'Corban De La Vega',
              caption: 'moving postcards from oahu',
              hashtags: '#hawaii',
              likes: '23.5k',
              comments: '74k',
              saves: '3018',
              shares: '1629',
              videoURL: 'assets/videos/tiktok-hawaii.MP4'),
          ExplorePost(
              username: 'jasminstanleyy',
              caption: 'Alaska feels like a different planet.',
              hashtags: '#alaskawaiian #alaska',
              likes: '238.2k',
              comments: '900',
              saves: '26.7k',
              shares: '37.9k',
              videoURL: 'assets/videos/tiktok-alaska.MP4'),
        ]));
  }
}
