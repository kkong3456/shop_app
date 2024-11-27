import 'package:flutter/material.dart';

class BasicDialog extends StatelessWidget {
  BasicDialog({
    super.key,
    required this.content,
    required this.buttonText,
    required this.buttonFuction,
  });

  String content;
  String buttonText;
  Function() buttonFuction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 10,
              ),
              child: Center(
                child: Text(content),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: FilledButton(
            onPressed: buttonFuction,
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}
