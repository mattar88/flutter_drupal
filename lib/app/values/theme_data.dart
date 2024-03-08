import 'package:flutter/material.dart';

import 'app_colors.dart';

var defaultElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
  foregroundColor: Colors.black,
  backgroundColor: AppColors.primarySwatch,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
));
