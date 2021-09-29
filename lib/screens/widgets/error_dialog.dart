import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const ErrorDialog({Key? key, this.title = 'Error', required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
  }

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
