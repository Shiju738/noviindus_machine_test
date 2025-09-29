import 'package:get/get.dart';
import '../../modules/splash/splash_controller.dart';
import '../../modules/login/login_controller.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/register/register_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<RegisterController>(RegisterController(), permanent: true);
  }
}
