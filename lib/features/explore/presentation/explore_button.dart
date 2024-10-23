import 'package:flutter/material.dart';

class ExploreButton extends StatelessWidget {
  // the icon of the button
  final icon;
  // the corresponding number that is on the bottom of the icon
  final String number;

  ExploreButton({required this.icon, required this.number});

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
        SizedBox(
          height: 2,
        ),
        Text(number,
            style: TextStyle(
              color: Colors.white,
            )),
      ]),
    );
  }
}
