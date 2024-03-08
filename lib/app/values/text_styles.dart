import 'package:flutter/material.dart';

import 'app_colors.dart';

const headline1 = TextStyle(color: Colors.red);
const headline2 = TextStyle(color: Colors.yellow);
const headline3 = TextStyle(color: Colors.green);
const subtitle1 = TextStyle(color: Colors.black);

const pageTitleBlackStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.appBarTitleColor);

const appBarTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.appBarTitleColor);

const appBarSubtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: Colors.white);

const centerTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: AppColors.centerTextColor,
);

const errorTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: AppColors.error,
);

const greyDarkTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textColorGreyDark,
    height: 1.45);

const primaryColorSubtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.45);

const whiteText16 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

const whiteText18 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

const whiteText32 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

const cyanText16 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: AppColors.textColorCyan,
);

const cyanText32 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w400,
  color: AppColors.textColorCyan,
);

const dialogSubtitle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: AppColors.textColorPrimary,
);

const labelStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 1.8,
);

final labelStylePrimaryTextColor = labelStyle.copyWith(
  color: AppColors.textColorPrimary,
  height: 1,
);

final labelStyleAppPrimaryColor = labelStyle.copyWith(
  color: AppColors.primary,
  height: 1,
);

final labelStyleGrey =
    labelStyle.copyWith(color: const Color(0xFF323232).withOpacity(0.5));

final labelCyanStyle = labelStyle.copyWith(color: AppColors.textColorCyan);

const labelStyleWhite = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 1.8,
  color: Colors.white,
);

const cardTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textColorPrimary);

const cardTitleCyanStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: AppColors.primary,
);

const cardSubtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textColorGreyLight);

const titleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  height: 1.34,
);

final cardTagStyle = titleStyle.copyWith(color: AppColors.textColorGreyDark);

const titleStyleWhite = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white);

const inputFieldLabelStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  height: 1.34,
  color: AppColors.textColorPrimary,
);

const cardSmallTagStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textColorGreyDark);

const appBarActionTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: AppColors.primary,
);

const pageTitleWhiteStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.15,
    color: AppColors.white);

const extraBigTitleStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w600,
  height: 1.12,
);

final extraBigTitleCyanStyle =
    extraBigTitleStyle.copyWith(color: AppColors.textColorCyan);

const bigTitleStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  height: 1.15,
);

const mediumTitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  height: 1.15,
);

const descriptionTextStyle = TextStyle(
  fontSize: 16,
);

final bigTitleCyanStyle =
    bigTitleStyle.copyWith(color: AppColors.textColorCyan);

const bigTitleWhiteStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  height: 1.15,
  color: Colors.white,
);

const boldTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  height: 1.34,
);
final boldTitleWhiteStyle =
    boldTitleStyle.copyWith(color: AppColors.textColorWhite);

final boldTitleCyanStyle =
    boldTitleStyle.copyWith(color: AppColors.textColorCyan);

final boldTitleSecondaryColorStyle =
    boldTitleStyle.copyWith(color: AppColors.textColorSecondary);

final boldTitlePrimaryColorStyle =
    boldTitleStyle.copyWith(color: AppColors.primary);
