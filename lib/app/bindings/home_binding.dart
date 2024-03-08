import '../controllers/nav_drawer_controller.dart';

import '../controllers/home_controller.dart';
import '../services/home_api_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavDrawerController>(() => NavDrawerController());
    Get.lazyPut<HomeApiService>(() => HomeApiService());
    Get.lazyPut<HomeController>(
        () => HomeController(Get.find<HomeApiService>()));
  }
}
