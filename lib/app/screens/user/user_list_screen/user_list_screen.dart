import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../values/app_values.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:wp_search_bar/wp_search_bar.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/circuclar_indicator.dart';
import '../../../controllers/user/user_list_controller.dart';
import '../../../models/user_model.dart';
import '../../../widgets/skeleton/skeleton_list_view_card.dart';
import '../../base_screen.dart';
import 'widgets/user_list_item.dart';

class UserListScreen extends BaseScreen<UserListController> {
  late String? title;

  UserListScreen({this.title, Key? key}) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.USER_VIEW.path);
          },
          child: const Icon(
            Icons.add,
            // color: Colors.white,
          ),
          // backgroundColor: Colors.black,
          tooltip: 'Add User',
          // elevation: 5,
          // splashColor: Colors.grey,
        ),
        // appBar: PreferredSize(
        //     preferredSize: const Size.fromHeight(0),
        //     child: AppBar(
        //       automaticallyImplyLeading: false, // hides leading widget
        //       flexibleSpace: null,
        //       elevation: 0,
        //     )),
        body: Obx(() {
          // var l = controller.reachTheEnd.value;
          var reachTheEnd = controller.reachTheEnd.value!;
          log('updatiiiiiiig obx');
          return WPSearchBar(
              isLoading: controller.isLoading.value! && !reachTheEnd,
              listOfFilters: const {
                'name': {
                  'name': 'name',
                  'selected': false,
                  'title': 'Username',
                  'operation': 'CONTAINS',
                  'icon': Icons.title,
                },
                'status': {
                  'name': 'status',
                  'selected': false,
                  'title': 'status',
                  'operation': '=',
                  'icon': Icons.check_box,
                },
              },
              materialDesign: {
                'title': {'text': AppLocalizations.of(context)!.pageUsers},
                'loadingIndicator': Transform.scale(
                  scale: 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                'textField': {
                  'cursorColor': Theme.of(context).colorScheme.onSurface,
                  'style':
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  'decoration': InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      )),
                },
                'buttonsColor': {
                  'selected': {
                    'textColor': Colors.white,
                    'backgroundColor': Theme.of(context).colorScheme.primary
                  },
                  'unselected': {
                    'textColor': Colors.white,
                    'backgroundColor': Color.fromARGB(255, 47, 64, 75)
                  }
                },
              },
              onSearch: controller.onSearch,
              body: (controller.isLoading.value! && controller.list.isEmpty)
                  ? SkeletonListViewCard(
                      hasSubtitle: true,
                      hasLeading: false,
                      paddingContainer: AppValues.pagePadding,
                    )
                  : Container(
                      padding: AppValues.pagePadding,
                      child: Stack(
                        children: [
                          if (controller.isLoading.value! && !reachTheEnd)
                            const Opacity(
                              opacity: 0.2,
                              child: ModalBarrier(
                                  dismissible: false, color: Colors.black),
                            ),
                          controller.list.isEmpty
                              ? Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .noTermsAvailable),
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        controller:
                                            controller.listViewController,
                                        shrinkWrap: true,
                                        primary: false,
                                        physics: BouncingScrollPhysics(),

                                        // shrinkWrap: true,
                                        itemCount: controller.list.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Widget item;
                                          UserModel user =
                                              controller.list[index];
                                          log('User... ${user.toJson()}');
                                          if (user.drupalInternalUid == null) {
                                            // return SizedBox.shrink();
                                            return null;
                                          }
                                          item = UserListItem(user);

                                          if (reachTheEnd &&
                                              index ==
                                                  controller.list.length - 1) {
                                            item = Column(children: [
                                              item,
                                              CircularPageIndicator()
                                            ]);
                                          }
                                          return item;
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Container();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      )));
        }));
  }
}
