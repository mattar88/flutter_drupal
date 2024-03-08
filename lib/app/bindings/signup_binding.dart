import '../services/oauth_client_service2.dart';

import '../controllers/signup_controller.dart';
import '../services/auth_api_service.dart';
import '../services/cache_service.dart';
import 'package:get/get.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
        () => SignupController(Get.find<AuthApiService>()));
  }
}
