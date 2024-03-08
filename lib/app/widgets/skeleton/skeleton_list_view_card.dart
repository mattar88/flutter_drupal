import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonListViewCard extends StatelessWidget {
  final bool hasLeading;
  final SkeletonAvatarStyle? leadingStyle;
  final SkeletonLineStyle? titleStyle;
  final bool hasSubtitle;
  final SkeletonLineStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? paddingContainer;
  final double? contentSpacing;
  final double? verticalSpacing;
  final Widget? trailing;
  final int? itemCount;
  SkeletonListViewCard({
    Key? key,
    this.itemCount,
    this.hasLeading = true,
    this.leadingStyle, //  = const SkeletonAvatarStyle(padding: EdgeInsets.all(0)),
    this.titleStyle = const SkeletonLineStyle(
      padding: EdgeInsets.all(0),
      height: 22,
    ),
    this.subtitleStyle = const SkeletonLineStyle(
      height: 16,
      padding: EdgeInsetsDirectional.only(end: 32),
    ),
    this.hasSubtitle = false,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    this.paddingContainer = const EdgeInsets.symmetric(vertical: 8),
    this.contentSpacing = 8,
    this.verticalSpacing = 8,
    this.trailing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingContainer,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: SkeletonListTile(
            padding: padding,
            hasLeading: hasLeading,
            hasSubtitle: hasSubtitle,
          ));
        },
      ),
    );
  }
}
