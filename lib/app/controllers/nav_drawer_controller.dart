import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../controllers/base_controller.dart';
import '../controllers/user/user_controller.dart';

import '../models/user_model.dart';
import '../services/oauth_client_service2.dart';
import 'package:oauth2/oauth2.dart';

import '../routes/app_pages.dart';
import '../services/cache_service.dart';
import 'package:get/get.dart';
import '../services/auth_api_service.dart';
import '../services/user_api_service.dart';

class NavDrawerController extends BaseController {
  RxBool isLoading = RxBool(false);
  late Rx<UserModel> user;

  NavDrawerController();

  @override
  void onInit() {
    isLoading.value = true;
    UserController userController =
        Get.put(UserController(Get.put(UserApiService())));
    userController.getCurrentUser(include: ['user_picture']).then(
        (UserModel? currentUser) {
      user = currentUser!.obs;
      isLoading.value = false;
    }).catchError((onError) {
      throw Exception('An error occurred $onError');
    });
    super.onInit();
  }
}
