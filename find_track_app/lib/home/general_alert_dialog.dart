import 'package:flutter/material.dart';

class GeneralAlertDialog extends StatelessWidget {
  final String title, content, submit;
  final Function onSubmit;

  const GeneralAlertDialog({
    Key? key,
    required this.title,
    required this.submit,
    required this.content,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'continue');
            onSubmit();
          },
          child: Text(submit),
        ),
      ],
    );
  }
}
