import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';
import '../../routes/app_pages.dart';
import '../../helpers/image_paths.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(() => Get.offAllNamed(Routes.login));
          }
          return SizedBox.expand(
            child: Image.asset(ImagePaths.splash, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
