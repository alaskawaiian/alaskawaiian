import 'package:flutter/material.dart';

class ExploreButton extends StatelessWidget {
  // the icon of the button
  final icon;

  ExploreButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(children: [
        Icon(
          icon,
          size: 40,
          color: Colors.white,
        ),
      ]),
    );
  }
}
