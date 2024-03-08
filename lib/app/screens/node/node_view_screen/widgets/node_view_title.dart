import 'package:flutter/cupertino.dart';

class NodeViewTitle extends StatelessWidget {
  final String title;

  const NodeViewTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(children: [
        const Text('Title :',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(
          width: 4,
        ),
        Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
      ]),
    );
  }
}
