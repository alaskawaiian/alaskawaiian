import 'package:flutter/material.dart';

import '../presentation/explore_post.dart';

class Post2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExplorePost(
        username: 'alaskawaiian',
        caption: 'visit aloha stadium!',
        hashtags: '#alaskawaiian #hawaii',
        likes: '23k',
        comments: '1.2k',
        saves: '122',
        shares: '254',
        videoURL: 'assets/videos/tiktok-aloha-stadium.MP4');
  }
}
