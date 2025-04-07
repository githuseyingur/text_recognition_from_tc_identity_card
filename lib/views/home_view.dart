import 'dart:io';
import 'package:detect_text_from_image/controllers/extract_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void dispose() {
    super.dispose();
  }

  final extractDataController = Get.put(ExtractDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Center(
          child: Text(
            "Extract Text From ID",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Obx(
                () => (extractDataController.imagePaths.isEmpty)
                    ? Lottie.asset('assets/animations/id_card_scan.json')
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Visibility(
                          visible:
                              extractDataController.imagePath.value.isNotEmpty,
                          child: SizedBox(
                              height: 200,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(
                                          extractDataController.imagePaths.last,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -12,
                                    right: -12,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          extractDataController
                                              .idBirthdate.value = '';
                                          extractDataController
                                              .idSerialNumber.value = '';
                                          extractDataController
                                              .idValidUntil.value = '';
                                          extractDataController
                                              .imagePath.value = '';
                                          extractDataController.imagePaths
                                              .clear();
                                          extractDataController.barcodeValue =
                                              '';
                                        });
                                        // deliveryDocumentController.imagePaths.removeAt(index);
                                        // deliveryDocumentController.capturedImageCount.value--;
                                      },
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.054,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => Colors.deepPurple),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                        ))),
                    child: const Text(
                      "SCAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () async {
                      await extractDataController.getImage();
                    }),
              ),
              Obx(
                () => Visibility(
                  visible: extractDataController.imagePaths.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.054,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromARGB(255, 236, 125, 7)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                              ))),
                          child: const Text(
                            "EXTRACT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () async {
                            await extractDataController.processImage();

                            print(
                                "Confirm - barcode: ${extractDataController.barcodeValue}");
                            print(
                                "Confirm - idSerialNumber: ${extractDataController.idSerialNumber.value}");
                            print(
                                "Confirm - idBirthdate: ${extractDataController.idBirthdate.value}");
                            print(
                                "Confirm - idValidUntil: ${extractDataController.idValidUntil.value}");
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
