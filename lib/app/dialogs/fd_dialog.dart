import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FDDialog {
  static Future<bool?> delete(BuildContext context,
      {required String deleteMessage,
      VoidCallback? onDeleted,
      VoidCallback? onCanceled}) async {
    var T = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(T.delete),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(deleteMessage),
              ],
            ),
          ),
          actions: <Widget>[
            FilledButton(
              child: Text(T.confirm),
              onPressed: () {
                Navigator.of(context).pop(true);
                onDeleted!();
              },
            ),
            TextButton(
              child: Text(T.cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
                onCanceled!();
              },
            ),
          ],
        );
      },
    );
  }
}
