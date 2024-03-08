import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NodeViewBody extends StatelessWidget {
  final String body;

  const NodeViewBody(this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Body:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(body,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
        ),
      ]),
    );
  }
}
