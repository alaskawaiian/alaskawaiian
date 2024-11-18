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
              place: 'Aloha Stadium - Oahu, HI',
              caption: 'Aloha Stadium Swap Meet on Oahu!',
              hashtags: '#hawaii #supportlocal',
              videoURL: 'assets/videos/tiktok-aloha-stadium.MP4',
              airlineURL: 'https://www.hawaiianairlines.com/'),
          ExplorePost(
              place: 'Oahu, HI',
              caption: 'moving postcards from oahu',
              hashtags: '#hawaii',
              videoURL: 'assets/videos/tiktok-hawaii.MP4',
              airlineURL: 'https://www.hawaiianairlines.com/'),
          ExplorePost(
              place: 'Alaska',
              caption: 'Alaska feels like a different planet.',
              hashtags: '#alaskawaiian #alaska',
              videoURL: 'assets/videos/tiktok-alaska.MP4',
              airlineURL: 'https://www.alaskaair.com/'),
        ]));
  }
}
