import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.titleText,
    required this.contentText,
    required this.cancelText,
    required this.confirmText,
    super.key,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String titleText,
    required String contentText,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
  }) =>
      showDialog<bool>(
        context: context,
        builder: (context) => AppAlertDialog(
          titleText: titleText,
          contentText: contentText,
          cancelText: cancelText,
          confirmText: confirmText,
        ),
      );

  final String titleText;
  final String contentText;
  final String cancelText;
  final String confirmText;

  void _confirm(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: [
          CupertinoDialogAction(
            onPressed: () => _cancel(context),
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            onPressed: () => _confirm(context),
            child: Text(confirmText),
          ),
        ],
      );
    }
    return AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: () => _cancel(context),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => _confirm(context),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
