import 'package:get/get.dart';

import '../../controllers/user/user_list_controller.dart';
import '../../services/user_api_service.dart';

class UserListBinding extends Bindings {
  UserListBinding();

  @override
  void dependencies() {
    Get.lazyPut<UserListController>(
        () => UserListController(Get.put(UserApiService())));
  }
}
