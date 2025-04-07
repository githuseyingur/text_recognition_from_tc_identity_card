import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/extract_data_controller.dart';

class IdDetailView extends StatelessWidget {
  IdDetailView({super.key});
  final extractDataController = Get.put(ExtractDataController());

  final profileSettingsStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Color(0xff979797),
  );
  final userInfoStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.deepPurple,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Visibility(
              visible: extractDataController.imagePath.value.isNotEmpty,
              child: Container(
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
                    File(extractDataController.imagePaths.last),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Card(
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Center(
                  child: Text(
                    "DATA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "TC",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idTCKN.value == ''
                              ? "-"
                              : extractDataController.idTCKN.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Name Surname",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          '${extractDataController.idName.value} ${extractDataController.idSurname.value}' ==
                                  ' '
                              ? '-'
                              : '${extractDataController.idName.value} ${extractDataController.idSurname.value}',
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Birthdate",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idBirthdate.value == ''
                              ? '-'
                              : extractDataController.idBirthdate.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Serial Number",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idSerialNumber.value == ''
                              ? '-'
                              : extractDataController.idSerialNumber.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Valid Until",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idValidUntil.value == ''
                              ? "-"
                              : extractDataController.idValidUntil.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: const CircleBorder(),
                elevation: 4,
                shadowColor: Colors.deepPurple,
                minimumSize: const Size.fromRadius(24),
              ),
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
