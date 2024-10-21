import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/features/explore/presentation/explore_post.dart';

class Post1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExplorePost(
        username: 'Jenielle',
        caption: 'Aloha Stadium Swap Meet on Oahu!',
        hashtags: '#hawaii #supportlocal',
        likes: '9,456',
        comments: '45',
        saves: '123',
        shares: '98',
        videoURL: 'assets/videos/tiktok-aloha-stadium.MP4');
  }
}
