import 'package:get/get.dart';

import '../../models/file_model.dart';
import '../../models/user_model.dart';
import '../../services/user_api_service.dart';
import '../base_controller.dart';

class UserController extends BaseController {
  final UserApiService _userApiService;

  UserController(this._userApiService);

  Future<List<UserModel>?> getUsers(
      {String? title, String condition = 'CONTAINS', offset, limit}) async {
    try {
      return await _userApiService.list(
          title: title, condition: condition, offset: offset, limit: limit);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser({List<String>? include}) async {
    try {
      return _userApiService.getCurrentUser(include);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<FileModel?> uploadFile(String fieldMachineName, dynamic file,
      {Progress? uploadProgress}) async {
    try {
      return await _userApiService.uploadFile(fieldMachineName, file,
          uploadProgress: uploadProgress);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///
  ///@include used to load associated objects example({include=field_tags})
  ///with this example we load the user with all tags objects
  ///more details: https://www.drupal.org/docs/core-modules-and-themes/core-modules/jsonapi-module/includes
  ///
  Future<UserModel> load(String id, {List<String>? include}) async {
    try {
      return await _userApiService.load(id, include: include);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<UserModel> create(UserModel user) async {
    try {
      return await _userApiService.create(user);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<UserModel> edit(UserModel user) async {
    try {
      return await _userApiService.update(user);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<bool> delete(String id) async {
    try {
      return await _userApiService.remove(id);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }
}
