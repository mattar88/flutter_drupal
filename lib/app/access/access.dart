import 'dart:developer';

import 'package:get/get.dart';

import '../models/node/node_model.dart';
import '../models/taxonomy/taxonomy_model.dart';
import '../models/user_oauth_model.dart';
import '../services/cache_service.dart';

enum Operation { add, edit, delete, view }

abstract class Access {
  static bool access(String permission, {UserOauthModel? user}) {
    user ??= Get.find<CacheService>().loadUserOauth();
    var ret =
        user!.permissions != null && user.permissions!.contains(permission);
    return ret;
  }

  static bool contentAccess(Operation operation, NodeModel node) {
    if (access('${operation.name} any ${node.type} content')) return true;

    if (access('${operation.name} own ${node.type} content')) {
      // make sure you are the author
      if (node.author?.drupalInternalUid != null) {
        UserOauthModel? user = Get.find<CacheService>().loadUserOauth();

        return (node.author?.drupalInternalUid == user?.drupalInternalUid);
      }
    }
    return false;
  }

  static bool termAccess(Operation operation, TaxonomyModel term) {
    log('Enter access bbbehavior for: ${operation.name} terms in ${term.vocabulary}');
    if (access('${operation.name} terms in ${term.vocabulary}')) return true;

    return false;
  }

  static bool administerNodes() => Access.access('administer nodes');
}
