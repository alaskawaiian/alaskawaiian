import 'package:flutter/material.dart';

import '../../../custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key? key,
    required String text,
    bool loading = false,
    VoidCallback? onPressed,
    Color? color,
  }) : super(
          key: key,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: color,
          textColor: Colors.black87,
          loading: loading,
          onPressed: onPressed,
        );
}
