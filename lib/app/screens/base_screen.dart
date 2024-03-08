import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/base_controller.dart';
import '../models/enum/message_status.dart';
import '../models/message_model.dart';
import '../values/app_colors.dart';

abstract class BaseScreen<Controller extends BaseController>
    extends GetView<Controller> {
  BaseScreen({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Widget showMessages() {
    return Obx(() {
      var msgs = controller.messages.value;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (msgs.isNotEmpty) {
          for (MessageModel message in msgs) {
            switch (message.status) {
              case MessageStatus.error:
                Get.snackbar(
                  message.title ?? 'Error',
                  message.message,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                  icon: const Icon(Icons.error, color: Colors.white),
                  shouldIconPulse: true,
                  barBlur: 20,
                );
                break;
              case MessageStatus.warning:
                Get.snackbar(
                  message.title ?? 'Warning',
                  message.message,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.warning,
                  colorText: Colors.white,
                  icon: const Icon(Icons.warning, color: Colors.white),
                  shouldIconPulse: true,
                  barBlur: 20,
                );
                break;
              default:
                Get.snackbar(
                  message.title ?? 'Success',
                  message.message,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  shouldIconPulse: true,
                  barBlur: 20,
                );
            }
          }
          controller.clearMessages();
        }
      });
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [pageScaffold(context), showMessages()],
      ),
    );
  }

  Widget pageScaffold(BuildContext context);
}
