import 'package:flutter/material.dart';
import './explore_button.dart';

class ExplorePost extends StatelessWidget {
  final String author;
  final String description;
  final Widget child;

  ExplorePost({
    required this.author,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          // the user's post
          child,
          // the user's name and the post description
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  alignment: Alignment(-1, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // MaterialBanner(
                      //   content: Text("Book a flight!"),
                      //   actions: <Widget>[
                      //     TextButton(onPressed: null, child: Text('OPEN')),
                      //     TextButton(
                      //       onPressed: null,
                      //       child: Text('DISMISS'),
                      //     ),
                      //   ],
                      // ),
                      // author
                      Text(author,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(description,
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text("Book a flight!"),
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
                      ExploreButton(
                        icon: Icons.send,
                      ),
                    ],
                  )),
            ),
          )
        ]));
  }
}
