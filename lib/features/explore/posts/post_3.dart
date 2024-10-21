import 'package:flutter/material.dart';

import '../presentation/explore_post.dart';

class Post3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExplorePost(
        username: 'alaskawaiian',
        caption: 'alaskan snow!',
        hashtags: '#alaskawaiian #alaska',
        likes: '153k',
        comments: '4.3k',
        saves: '423',
        shares: '543',
        videoURL: 'assets/videos/tiktok-aloha-stadium.MP4');
  }
}
