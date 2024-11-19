import 'package:flutter/material.dart';
import './explore_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorePost extends StatelessWidget {
  final String author;
  final String description;
  final Widget child;

  const ExplorePost(
      {required this.author, required this.description, required this.child});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(airlineURL);

    try {
      if (await launchUrl(url)) {
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
                      // book a flight
                      GestureDetector(
                        onTap: _launchUrl,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Book a Flight! ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Icon(
                                Icons.flight,
                                size: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // the user's name
                      Text(place,
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
