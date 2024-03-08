import 'dart:developer';
import 'dart:ui';

import '../bindings/theme_mode_binding.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../bindings/article/article_form_binding.dart';
import '../bindings/article/article_view_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/languages_binding.dart';
import '../bindings/login/login_binding.dart';
import '../bindings/login/login_webview_binding.dart';
import '../bindings/node/node_form_binding.dart';
import '../bindings/node/node_list_binding.dart';
import '../bindings/node/node_type_binding.dart';
import '../bindings/node/node_view_binding.dart';
import '../bindings/signup_binding.dart';

import '../bindings/taxonomy/taxonomy_form_binding.dart';
import '../bindings/taxonomy/taxonomy_list_binding.dart';
import '../bindings/taxonomy/taxonomy_view_binding.dart';
import '../bindings/taxonomy/taxonomy_vocaulary_binding.dart';
import '../bindings/user/user_list_binding.dart';
import '../bindings/user/user_view_binding.dart';
import '../middlewares/auth_middleware.dart';
import '../models/enum/entity_action.dart';
import '../models/node/node_model.dart';
import '../models/taxonomy/taxonomy_model.dart';
import '../models/user_model.dart';
import '../models/user_oauth_model.dart';
import '../screens/article/article_form_screen.dart';
import '../screens/article/article_view_screen.dart';
import '../screens/node/node_form_screen/node_form_screen.dart';
import '../screens/node/node_list_screen/node_list_screen.dart';
import '../screens/node/node_type_list_screen.dart';
import '../screens/node/node_view_screen/node_view_screen.dart';
import '../screens/taxonomy/taxonomy_translations_screen.dart';
import '../screens/theme_mode/theme_mode_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/languages/languages_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/login_webview_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/taxonomy/taxonomy_form_screen/taxonomy_form_screen.dart';
import '../screens/taxonomy/taxonomy_list_screen/taxonomy_list_screen.dart';
import '../screens/taxonomy/taxonomy_view_screen.dart';
import '../screens/taxonomy/taxonomy_vocabulary_list_screen.dart';
import '../screens/user/user_list_screen/user_list_screen.dart';
import '../screens/user/user_view_screen/user_view_screen.dart';
import '../services/cache_service.dart';
import '../access/access.dart';

part 'app_routes.dart';

class AppPages {
  static const transition = Transition.noTransition;
  static List<GetPage> pages = [
    GetPage(
        name: Routes.HOME.path,
        page: () => const HomeScreen(),
        binding: HomeBinding(),
        middlewares: [AuthMiddleware()],
        transition: transition),
    GetPage(
        name: Routes.LOGIN.path,
        page: () => const LoginScreen(),
        binding: LoginBinding(),
        transition: transition),
    GetPage(
        name: Routes.LOGIN_WEBVIEW.path,
        page: () => const LoginWebviewScreen(),
        binding: LoginWebviewBinding(),
        transition: transition),
    GetPage(
        name: Routes.SIGNUP.path,
        page: () => const SignupScreen(),
        binding: SignupBinding(),
        transition: transition),
    GetPage(
        name: Routes.USER_VIEW.path,
        page: () => UserViewScreen(),
        binding: UserViewBinding(),
        transition: transition),
    GetPage(
        name: Routes.USER_LIST.path,
        page: () => UserListScreen(),
        binding: UserListBinding(),
        transition: transition),
    GetPage(
        name: Routes.TAXONOMY_ADD.path,
        page: () => TaxonomyFormScreen(EntityAction.add),
        binding: TaxonomyFormBinding(EntityAction.add),
        transition: transition),
    GetPage(
        name: Routes.TAXONOMY_EDIT.path,
        page: () => TaxonomyFormScreen(EntityAction.edit),
        binding: TaxonomyFormBinding(EntityAction.edit),
        transition: transition),
    GetPage(
        name: Routes.TAXONOMY_VIEW.path,
        page: () => TaxonomyViewScreen(),
        binding: TaxonomyViewBinding(),
        transition: transition),
    GetPage(
        name: Routes.TAXONOMY_LIST.path,
        page: () => TaxonomyListScreen(),
        binding: TaxonomyListBinding(),
        transition: transition),
    GetPage(
        name: Routes.TAXONOMY_VOCABULARY_LIST.path,
        page: () => TaxonomyVocabularyListScreen(),
        binding: TaxonomyVocabularyBinding(),
        transition: transition),
    GetPage(
        name: Routes.ARTICLE_ADD.path,
        page: () => ArticleFormScreen(EntityAction.add),
        binding: ArticleFormBinding(EntityAction.add),
        transition: transition),
    GetPage(
        name: Routes.ARTICLE_EDIT.path,
        page: () => ArticleFormScreen(EntityAction.edit),
        binding: ArticleFormBinding(EntityAction.edit),
        transition: transition),
    GetPage(
        name: Routes.ARTICLE_VIEW.path,
        page: () => ArticleViewScreen(),
        binding: ArticleViewBinding(),
        transition: transition),
    GetPage(
        name: Routes.NODE_ADD.path,
        page: () => NodeFormScreen(EntityAction.add),
        binding: NodeFormBinding(EntityAction.add),
        transition: transition),
    GetPage(
        name: Routes.NODE_EDIT.path,
        page: () => NodeFormScreen(EntityAction.edit),
        binding: NodeFormBinding(EntityAction.edit),
        transition: transition),
    GetPage(
        name: Routes.NODE_VIEW.path,
        page: () => NodeViewScreen(),
        binding: NodeViewBinding(),
        transition: transition),
    GetPage(
        name: Routes.NODE_TYPE_LIST.path,
        page: () => NodeTypeListScreen(),
        binding: NodeTypeBinding(),
        transition: transition),
    GetPage(
        name: Routes.NODE_LIST.path,
        page: () => NodeListScreen(),
        binding: NodeListBinding(),
        transition: transition),
    GetPage(
        name: Routes.THEME_MODE.path,
        page: () => ThemeModeScreen(),
        binding: ThemeModeBinding(),
        transition: transition),
    GetPage(
        name: Routes.LANGUAGES.path,
        page: () => LanguagesScreen(),
        binding: LanguagesBinding(),
        transition: transition),
    GetPage(
        name: Routes.SETTINGS.path,
        page: () => SettingsScreen(),
        // binding: LanguagesBinding(),
        transition: transition),
  ];
}
