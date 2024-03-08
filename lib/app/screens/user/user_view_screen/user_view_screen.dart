import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controllers/user/user_view_controller.dart';
import '../../../widgets/circuclar_indicator.dart';
import '../../../widgets/user_picture.dart';
import '../../base_screen.dart';

class UserViewScreen extends BaseScreen<UserViewController> {
  final String? title;

  UserViewScreen({
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? T.profile),
        ),
        body: Obx(() {
          return (controller.loading.value!)
              ? const CircularPageIndicator()
              : SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Text('Name:'),
                            title: Text('${controller.user.displayName}'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading:
                                Text('Member for ${controller.user.memberFor}'),
                            // title: Text('${controller.user.created}'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (controller.user.userPicture != null)
                            ImageView(
                              controller.user.userPicture!,
                              height: 200,
                            )
                        ],
                      )));
        }));
  }
}
