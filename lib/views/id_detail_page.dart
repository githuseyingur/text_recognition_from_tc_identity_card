import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/extract_data_controller.dart';

class IdDetailPage extends StatelessWidget {
  IdDetailPage({super.key});
  ExtractDataController extractDataController =
      Get.put(ExtractDataController());

  TextStyle profileSettingsStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Color(0xff979797),
  );
  TextStyle userInfoStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Card(
                color: Colors.blue,
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
                  backgroundColor: Colors.blue,
                  shape: const CircleBorder(),
                  elevation: 4,
                  shadowColor: Colors.blue,
                  minimumSize: Size.fromRadius(24)),
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
