import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../routes/app_pages.dart';

class NodeViewMeta extends StatelessWidget {
  final String userId;
  final String authorName;
  final String createdDate;

  const NodeViewMeta(
      {required this.userId,
      required this.authorName,
      required this.createdDate,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text('By',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(
          width: 4,
        ),
        TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              Get.toNamed(Routes.USER_VIEW.path.replaceAll(':id', userId));
            },
            child: Text(authorName,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16))),
        const SizedBox(
          width: 4,
        ),
        Text(createdDate,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
      ]),
    );
  }
}
