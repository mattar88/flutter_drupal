import 'package:get/get.dart';

import '../models/enum/message_status.dart';
import '../models/message_model.dart';

abstract class BaseController extends GetxController {
  RxList<MessageModel> messages = RxList(<MessageModel>[]);
  void addMessage(
      {MessageStatus? status, String? title, required String message}) {
    messages.add(MessageModel(status: status, title: title, message: message));
  }

  void clearMessages() {
    messages.clear();
  }
}
