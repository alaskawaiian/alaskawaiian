import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/features/explore/presentation/explore_button.dart';
import 'package:starter_architecture_flutter_firebase/features/explore/presentation/explore_video.dart';

class ExplorePost extends StatelessWidget {
  final String username;
  final String caption;
  final String hashtags;
  final String likes;
  final String comments;
  final String saves;
  final String shares;
  final String videoURL;

  ExplorePost({
    required this.username,
    required this.caption,
    required this.hashtags,
    required this.likes,
    required this.comments,
    required this.saves,
    required this.shares,
    required this.videoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          // the user's post
          ExploreVideo(videoURL: videoURL),
          // the user's name and the post caption
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  alignment: Alignment(-1, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // the user's name
                      Text(username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        // caption
                        TextSpan(
                          text: caption,
                          style: DefaultTextStyle.of(context).style.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        // hashtags
                        TextSpan(
                          text: ' $hashtags',
                          style: DefaultTextStyle.of(context).style.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ])),
                    ],
                  )),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  alignment: Alignment(1, 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ExploreButton(icon: Icons.favorite, number: likes),
                      ExploreButton(icon: Icons.comment, number: comments),
                      ExploreButton(icon: Icons.bookmark, number: saves),
                      ExploreButton(icon: Icons.send, number: shares),
                    ],
                  )),
            ),
          )
        ]));
  }
}
