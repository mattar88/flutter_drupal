import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../flavors/build_config.dart';
import '../../controllers/login/login_controller.dart';
import '../../routes/app_pages.dart';
import '../../widgets/loading_overlay.dart';
import 'painters/login_curve_painter.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(children: [
            Container(
              width: Get.width,
              height: Get.height,
              child: CustomPaint(
                painter:
                    LoginCurvePainter(Theme.of(context).colorScheme.primary),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (BuildConfig.instance.config.loginWithPassword)
                        Column(children: [
                          TextFormField(
                            // key: const Key('username'),
                            controller: controller.emailController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Username',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: controller.validator,
                          ),
                          TextFormField(
                            // key: const Key('password'),
                            controller: controller.passwordController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.security),
                              hintText: 'Password',
                            ),
                            validator: controller.validator,
                            obscureText: true,
                          ),
                          FilledButton(
                              onPressed: () async {
                                if (controller.loginFormKey.currentState!
                                    .validate()) {
                                  LoadingOverlay.show(message: 'Login...');
                                  try {
                                    await controller.login();
                                    Get.offAllNamed(Routes.HOME.path);
                                  } catch (err, _) {
                                    printError(info: err.toString());
                                    LoadingOverlay.hide();
                                    Get.snackbar(
                                      "Error",
                                      err.toString(),
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor:
                                          Colors.red.withOpacity(.75),
                                      colorText: Colors.white,
                                      icon: const Icon(Icons.error,
                                          color: Colors.white),
                                      shouldIconPulse: true,
                                      barBlur: 20,
                                    );
                                  } finally {}

                                  controller.loginFormKey.currentState!.save();
                                }
                              },
                              child: const Text('login'))
                        ]),
                      FilledButton(
                          onPressed: () async {
                            try {
                              Get.toNamed(Routes.LOGIN_WEBVIEW.path);
                            } catch (err, _) {
                              printError(info: err.toString());
                              LoadingOverlay.hide();
                              Get.snackbar(
                                "Error",
                                err.toString(),
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red.withOpacity(.75),
                                colorText: Colors.white,
                                icon: const Icon(Icons.error,
                                    color: Colors.white),
                                shouldIconPulse: true,
                                barBlur: 20,
                              );
                            } finally {}
                          },
                          child: const Text('login with browser')),
                      GestureDetector(
                        onTap: () {
                          Get.offAllNamed(Routes.SIGNUP.path);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            Text(
                              'Create an account',
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}
