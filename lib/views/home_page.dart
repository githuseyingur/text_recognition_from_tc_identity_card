import 'dart:io';
import 'package:detect_fext_from_image/controllers/extract_data_controller.dart';
import 'package:detect_fext_from_image/views/id_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  ExtractDataController extractDataController = Get.put(ExtractDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            "Extract Text From ID",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                (extractDataController.imagePaths.isEmpty)
                    ? Lottie.asset('assets/animations/id_card_scan.json')
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Visibility(
                          visible: extractDataController.imagePath.value.isNotEmpty,
                          child: SizedBox(
                              height: 200,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      File(extractDataController.imagePaths.last),
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            extractDataController.idBirthdate.value = '';
                                            extractDataController.idSerialNumber.value = '';
                                            extractDataController.idValidUntil.value = '';
                                            extractDataController.imagePath.value = '';
                                            extractDataController.imagePaths.clear();
                                            extractDataController.barcodeValue = '';
                                          });
                                          // deliveryDocumentController.imagePaths.removeAt(index);
                                          // deliveryDocumentController.capturedImageCount.value--;
                                        },
                                        icon: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 30,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                ],
                              )),
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
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(11)),
                          ))),
                      child: const Text(
                        "Scan ID Card",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await extractDataController.getImage();
                      }),
                ),
                SizedBox(
                  height: 10,
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
                                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(11)),
                                ))),
                            child: const Text(
                              "Confirm",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await extractDataController.processImage();

                              print("VV:barcodeValue: ${extractDataController.barcodeValue}");
                              print("VV:idSerialNumber: ${extractDataController.idSerialNumber.value}");
                              print("VV:idBirthdate: ${extractDataController.idBirthdate.value}");
                              print("VV:idValidUntil: ${extractDataController.idValidUntil.value}");

                              if (extractDataController.barcodeValue != '' || // if back side
                                  extractDataController.idSerialNumber.value == '' ||
                                  extractDataController.idBirthdate.value == '' ||
                                  extractDataController.idValidUntil.value == '' ||
                                  extractDataController.idName.value == '' ||
                                  extractDataController.idSurname.value == '' ||
                                  extractDataController.idTCKN == '') {
                                Get.snackbar(
                                  'Error',
                                  "Some data couldn't be retrieved from the ID card photo. Please check photo quality and try again...",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Success',
                                  'Data successfully extracted from ID card photo.',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }
                              await Get.to(IdDetailPage());
                            }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
