import 'package:get/get.dart';

import '../controller/extract_data_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtractDataController>(() => ExtractDataController());
  }
}
