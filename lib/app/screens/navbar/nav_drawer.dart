import 'dart:developer';

import 'package:flutter/material.dart';
import '../../screens/base_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/nav_drawer_controller.dart';
import '../../routes/app_pages.dart';
import '../../access/access.dart';
import 'navbar_header.dart';

class NavDrawer extends BaseScreen<NavDrawerController> {
  NavDrawer({super.key});

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   log('adter buuuuuildddd!');
    //   if (!controller.isLoading.value) {
    //     log('loaddddinnnnng');
    //     controller.onInit();
    //   }
    // });
    List<Widget> navItems;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const NavbarHeader(),
          Obx(() {
            navItems = [];
            navItems.add(ListTile(
              // style: ListTileStyle(),
              enabled: !controller.isLoading.value,
              leading: const Icon(Icons.verified_user),
              title: Text(T.sideBarMenuItemProfile),
              onTap: !controller.isLoading.value
                  ? () {
                      Get.toNamed(Routes.USER_VIEW.path
                          .replaceAll(':id', controller.user.value.id!));
                    }
                  : null,
            ));

            navItems.add(ListTile(
              leading: const Icon(Icons.settings),
              title: Text(T.sideBarMenuItemSettings),
              onTap: () => {Get.toNamed(Routes.SETTINGS.path)},
            ));

            if (!controller.isLoading.value) {
              if (Routes.USER_LIST.access!()) {
                navItems.add(ListTile(
                  leading: const Icon(Icons.people),
                  title: Text(T.sideBarMenuItemPeople),
                  onTap: () => {Get.toNamed(Routes.USER_LIST.path)},
                ));
              }
              if (Routes.NODE_TYPE_LIST.access!()) {
                navItems.add(ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(T.nodeTypeList),
                  onTap: () {
                    Get.toNamed(Routes.NODE_TYPE_LIST.path);
                  },
                ));
              }

              if (Routes.TAXONOMY_VOCABULARY_LIST.access!()) {
                navItems.add(ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(T.taxonomy),
                  onTap: () {
                    Get.toNamed(Routes.TAXONOMY_VOCABULARY_LIST.path);
                  },
                ));
              }
            }
            navItems.add(ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(T.sideBarMenuItemLogout),
              onTap: () {
                Get.find<AuthController>().signOut();
                Get.offAllNamed(Routes.LOGIN.path);
              },
            ));
            return Column(children: navItems);
          }),
        ],
      ),
    );
  }
}
