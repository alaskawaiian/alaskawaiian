import 'package:flutter/material.dart';

import '../presentation/explore_post.dart';

class Post3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExplorePost(
        username: 'jasminstanleyy',
        caption: 'Alaska feels like a different planet.',
        hashtags: '#alaskawaiian #alaska',
        likes: '238.2k',
        comments: '900',
        saves: '26.7k',
        shares: '37.9k',
        videoURL: 'assets/videos/tiktok-alaska.MP4');
  }
}
