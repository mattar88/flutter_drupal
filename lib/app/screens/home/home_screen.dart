import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../flavors/build_config.dart';
import '../../controllers/home_controller.dart';
import '../navbar/nav_drawer.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _key = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        _key.currentState!.openDrawer();
      });
    });
    log('Go to home');
    return Scaffold(
        key: _key,
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text(BuildConfig.instance.config.appName),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Image(
                  image: AssetImage('screenshots/flutter_and_drupal.png')),
            ),
            Expanded(
                child: WebViewWidget(
                    controller: controller.documentationWebViewController)),
          ],
        ));
  }
}
