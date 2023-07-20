import 'dart:io';
import 'package:detect_fext_from_image/controllers/home_page_controller.dart';
import 'package:detect_fext_from_image/views/id_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  HomePageController homePageController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                (homePageController.imagePaths.value.length == 0)
                    ? Lottie.asset('assets/animations/id_card_scan.json')
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Visibility(
                          visible:
                              homePageController.imagePath.value.isNotEmpty,
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(
                                            homePageController.imagePaths.last),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              homePageController
                                                  .idBirthdate.value = '';
                                              homePageController
                                                  .idSerialNumber.value = '';
                                              homePageController
                                                  .idValidUntil.value = '';
                                              homePageController
                                                  .imagePath.value = '';
                                              homePageController.imagePaths
                                                  .clear();
                                              homePageController.barcodeValue =
                                                  '';
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
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      child: const Text(
                        "Kimlik Tara",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await homePageController.getImage();
                        await homePageController.processImage();
                        await homePageController.scanFile();
                      }),
                ),
                Obx(
                  () => Visibility(
                    visible: homePageController.imagePath.value.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            child: const Text(
                              "Onayla",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              print(
                                  "VV:barcodeValue: ${homePageController.barcodeValue}");
                              print(
                                  "VV:idSerialNumber: ${homePageController.idSerialNumber.value}");
                              print(
                                  "VV:idBirthdate: ${homePageController.idBirthdate.value}");
                              print(
                                  "VV:idValidUntil: ${homePageController.idValidUntil.value}");

                              if (homePageController.barcodeValue !=
                                      '' || // if back side
                                  homePageController.idSerialNumber.value ==
                                      '' ||
                                  homePageController.idBirthdate.value == '' ||
                                  homePageController.idValidUntil.value == '') {
                                Get.snackbar(
                                  'Hata',
                                  'Kimliğin Arka Yüzü Çekilmiş\nVeya Fotoğraf Net Değil\nLütfen Tekrar Deneyin.',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else if (homePageController.barcodeValue ==
                                      '' && // if front side
                                  homePageController.idSerialNumber.value !=
                                      '' &&
                                  homePageController.idBirthdate.value != '' &&
                                  homePageController.idValidUntil.value != '') {
                                Get.snackbar(
                                  'Kimlik Okuma',
                                  'Kimliğin ön yüzü çekilmiş.\nKimlik Yönü Doğrulandı.',
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
