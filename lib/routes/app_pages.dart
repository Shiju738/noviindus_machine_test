import 'package:get/get.dart';
import '../modules/splash/splash_view.dart';
import '../modules/login/login_view.dart';
import '../modules/home/home_view.dart';
import '../modules/register/register_view.dart';

class Routes {
  Routes._();
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const register = '/register';
}

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(name: Routes.login, page: () => const LoginView()),
    GetPage(name: Routes.home, page: () => const HomeView()),
    GetPage(name: Routes.register, page: () => const RegisterView()),
  ];
}
