import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/user_model.dart';
import '../../services/user_api_service.dart';
import 'user_controller.dart';

class UserViewController extends UserController {
  final String? id;
  final UserApiService _userApiService;

  late UserModel user;
  List<String>? included;

  UserViewController(this.id, this._userApiService, {this.included})
      : super(_userApiService) {
    included = included ?? ['user_picture'];
  }

  Rxn<bool> loading = Rxn<bool>(false);
  String? title;

  @override
  void onInit() async {
    try {
      title = Get.arguments != null && Get.arguments.containsKey('title')
          ? Get.arguments['title']
          : 'View user';
      loading.value = true;
      log('Loadinnnng: ${loading.value}, ${id}');
      user = await load(id!, include: included);
      loading.value = false;
    } catch (e) {
      loading.value = false;
      throw Exception('UserViewController: $e');
    }
    super.onInit();
  }

  get updateDate => DateFormat('yyyy-MM-dd HH:mm').format(user.changed!);
  get createdDate => DateFormat('yyyy-MM-dd HH:mm').format(user.created!);
}
