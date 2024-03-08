import 'dart:developer';

import 'package:get/get.dart';

import '../../controllers/user/user_view_controller.dart';
import '../../services/user_api_service.dart';

class UserViewBinding extends Bindings {
  UserViewBinding({this.id});
  String? id;

  @override
  void dependencies() {
    log('Get.parameters: ${Get.parameters}');
    if (Get.parameters.containsKey('id')) {
      id = Get.parameters['id'].toString();
    }

    if (id == null || id!.isEmpty) {
      // throw Exception('An error occurred when view Node on UserViewBinding dependencies(), Empty Id!.');
    }

    Get.lazyPut<UserViewController>(
        () => UserViewController(id, Get.put(UserApiService())));
  }
}
