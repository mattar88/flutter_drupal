import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

import '../../controllers/nav_drawer_controller.dart';
import '../../widgets/user_picture.dart';

class NavbarHeader extends GetView<NavDrawerController> {
  const NavbarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DrawerHeader(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: CircleAvatar(
                child: ClipOval(
                    child: controller.isLoading.value
                        ? const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                                shape: BoxShape.circle,
                                width: 100,
                                height: 100),
                          )
                        : (controller.user.value.userPicture != null
                            ? ImageView(
                                controller.user.value.userPicture!,
                                width: 100,
                                height: 100,
                              )
                            : Text(controller
                                .user.value.displayName![0].capitalize!))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                  child: controller.isLoading.value
                      ? const SkeletonLine(
                          style: SkeletonLineStyle(
                              width: 60,
                              height: 15,
                              alignment: AlignmentDirectional.center),
                        )
                      : Text(
                          controller.user.value.displayName!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )),
            )
          ],
        ),
      );
    });
  }
}
