import 'package:flutter/material.dart';

import '../presentation/explore_post.dart';

class Post2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExplorePost(
        username: 'Corban De La Vega',
        caption: 'moving postcards from oahu',
        hashtags: '#hawaii',
        likes: '23.5k',
        comments: '74k',
        saves: '3018',
        shares: '1629',
        videoURL: 'assets/videos/tiktok-hawaii.MP4');
  }
}
