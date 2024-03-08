import 'dart:developer';

import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_pages.dart';
import 'package:get/get.dart';

import '../navbar/nav_drawer.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('Go to home');
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        // leadingWidth: double.infinity,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 28),
        ),
        // leading: Builder(builder: (context) {
        //   return IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //   );
        // })
      ),
      body: controller.obx(
        (state) => Container(
            child: Column(
          children: [
            const Text('This is the home page'),
          ],
        )),

        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CircularProgressIndicator(),
        onEmpty: Column(
          children: [
            const Text('No Data found'),
            ElevatedButton(
                onPressed: () {
                  Get.find<AuthController>().signOut();
                  Get.offAllNamed(Routes.LOGIN.path);
                },
                child: const Text("Signout",
                    style: TextStyle(color: Colors.white))),
          ],
        ),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error) => Text(''),
      ),
    );
  }
}
