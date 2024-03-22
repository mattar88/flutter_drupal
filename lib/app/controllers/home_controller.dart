import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/home_api_service.dart';

class HomeController extends GetxController with StateMixin {
  final HomeApiService _homeApiService;

  HomeController(this._homeApiService);
  late WebViewController documentationWebViewController;

  @override
  onInit() async {
    documentationWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://github.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://github.com/mattar88/flutter_drupal?tab=readme-ov-file#flutter-template-for-drupal-cms-getx-mvvm'));
    super.onInit();
  }
}
