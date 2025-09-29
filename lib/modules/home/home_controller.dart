import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt selectedSortIndex = 0.obs;

  final List<String> sortOptions = const ['Date', 'Name'];

  void setSort(int index) {
    selectedSortIndex.value = index;
  }
}
