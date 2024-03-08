part of 'app_pages.dart';

class RouteModel {
  final String path;
  final Function? access;
  RouteModel({required this.path, this.access}) {
    access ??
        () {
          return true;
        };
  }
}

abstract class Routes {
  static RouteModel HOME = RouteModel(path: '/');
  static RouteModel LOGIN = RouteModel(path: '/login');
  static RouteModel LOGIN_WEBVIEW = RouteModel(path: '/login-webview');
  static RouteModel SIGNUP = RouteModel(path: '/signup');
  static RouteModel USER_VIEW = RouteModel(path: '/user/user/:id');

  static RouteModel USER_LIST = RouteModel(
      path: '/user/user', access: () => Access.access('administer users'));

  static RouteModel ARTICLE_ADD =
      RouteModel(path: '/node/add/article', access: Access.contentAccess);
  static RouteModel ARTICLE_EDIT =
      RouteModel(path: '/node/article/:id/edit', access: Access.contentAccess);
  static RouteModel ARTICLE_VIEW =
      RouteModel(path: '/node/article/:id', access: Access.contentAccess);

  static RouteModel NODE_DELETE =
      RouteModel(path: '', access: Access.contentAccess);
  static RouteModel NODE_ADD =
      RouteModel(path: '/node/add/:nodeType', access: Access.contentAccess);
  static RouteModel NODE_EDIT = RouteModel(
      path: '/node/:nodeType/:id/edit', access: Access.contentAccess);
  static RouteModel NODE_VIEW = RouteModel(
      path: '/node/:nodeType/:id',
      access: () => Access.access('access content'));
  static RouteModel NODE_LIST = RouteModel(path: '/node/:nodeType');

  static RouteModel NODE_TYPE_LIST = RouteModel(
      path: '/node-type',
      access: () => Access.access('access content overview'));

  static RouteModel TAXONOMY_DELETE =
      RouteModel(path: '', access: Access.termAccess);
  static RouteModel TAXONOMY_ADD =
      RouteModel(path: '/taxonomy/add/:vocabulary', access: Access.termAccess);
  static RouteModel TAXONOMY_EDIT = RouteModel(
      path: '/taxonomy/:vocabulary/:id/edit', access: Access.termAccess);
  static RouteModel TAXONOMY_VIEW = RouteModel(
      path: '/taxonomy/:vocabulary/:id',
      access: () => Access.access('access content'));
  static RouteModel TAXONOMY_LIST = RouteModel(
      path: '/taxonomy/:vocabulary',
      access: () => Access.access('access taxonomy overview'));

  static RouteModel TAXONOMY_VOCABULARY_LIST = RouteModel(
      path: '/taxonomy-vocabulary',
      access: () => Access.access('access taxonomy overview'));

  static RouteModel THEME_MODE = RouteModel(path: '/theme-mode');
  static RouteModel LANGUAGES = RouteModel(path: '/languages');
  static RouteModel SETTINGS = RouteModel(path: '/settings');
}
