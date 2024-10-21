import 'package:flutter/material.dart';

import '../posts/post_1.dart';
import '../posts/post_2.dart';
import '../posts/post_3.dart';

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
          Post1(),
          Post2(),
          Post3(),
        ]));
  }
}
