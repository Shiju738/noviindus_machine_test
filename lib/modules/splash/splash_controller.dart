import 'package:get/get.dart';

class SplashController extends GetxController {
  Future<void> initialize() async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}

