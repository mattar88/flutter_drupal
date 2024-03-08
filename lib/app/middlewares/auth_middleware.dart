import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/auth_api_service.dart';

class AuthMiddleware extends GetMiddleware {
  // ignore: non_constant_identifier_names
  final AuthApiService _authApiService = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (_authApiService.sessionIsEmpty()) {
      return RouteSettings(name: Routes.LOGIN.path);
    }
    return null;
  }
}
