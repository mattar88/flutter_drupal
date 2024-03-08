import 'package:flutter/material.dart';

import '../values/app_values.dart';

class CircularPageIndicator extends StatelessWidget {
  const CircularPageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin:
              const EdgeInsets.all(AppValues.circularProgressIndicatorMargin),
          height: AppValues.circularProgressIndicatorSize,
          width: AppValues.circularProgressIndicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          )),
    );
  }
}
