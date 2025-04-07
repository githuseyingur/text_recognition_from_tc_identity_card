// import 'package:barcode_finder/barcode_finder.dart';

import 'package:detect_text_from_image/views/id_detail_view.dart';
import 'package:edge_detection_plus/edge_detection_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExtractDataController extends GetxController {
  RxBool isSnackbarShown = false.obs;
  RxList<String> imagePaths = <String>[].obs;
  RxString imagePath = "".obs;
  RxInt imageCount = 0.obs;

  RxString idSerialNumber = "".obs;
  RxString idBirthdate = "".obs;
  RxString idValidUntil = "".obs;
  RxString idTCKN = "".obs;
  RxString idName = "".obs;
  RxString idSurname = "".obs;
  RxString idGender = "".obs;

  String barcodeValue = '';

  RegExp dateRegex = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
// validate birthdate Regex

  final List<String> birthDateKeywords = [
    "Birth",
    "Date",
    "Doğum",
    "Tarihi",
    "Tarini",
    "Tartini",
    "Doğu"
  ];
  final List<String> serialKeywords = ["Seri", "Document", "Ser", "Doc"];
  final List<String> validUntilKeywords = [
    "Son",
    "Geçerlilik",
    "Valid",
    "Until",
    "Geçer",
    "Valia",
    "Unti",
    "Geçeri",
    "Geçerli"
  ];
  final List<String> tcknKeywords = [
    "Kimlik No",
    "Kimlik",
    "TR Identity",
    "Identity No",
    "Identity",
    "TR",
    "entity",
    "ity No"
  ];
  final List<String> surnameKeywords = [
    "Soyadı",
    "Surname",
    "Soyadi",
    "urname",
    "Soyad"
  ];
  final List<String> nameKeywords = [
    "Adı",
    "Adi",
    "Given Name",
    "Name(s)",
    "Give",
    "Name",
    "Gven"
  ];

  Future<void> getImage() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    imagePath.value = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      // Make sure to await the call to detectEdge.

      bool success = await EdgeDetectionPlus.detectEdge(
        imagePath.value,
        canUseGallery: true,
        androidScanTitle: 'Scan', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      if (success) {
        imagePaths.add(imagePath.value);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> processImage() async {
    final InputImage inputImage;
    inputImage = InputImage.fromFilePath(imagePath.value);
    TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    List<String> lines = text.split('\n');

    bool isSerial = false;
    bool isBirthDate = false;
    bool isValidUntil = false;
    bool isTCKN = false;
    bool isName = false;
    bool isSurname = false;
    int counter = 0;

    for (var line in lines) {
      print("line : $line");
      if (isSerial) {
        if (line.startsWith('A') && line.length == 9) {
          idSerialNumber.value = line;
          if (line[3] == '1') {
            idSerialNumber.value = idSerialNumber.value.replaceRange(3, 4, 'I');
          }
          if (line[3] == '0') {
            idSerialNumber.value = idSerialNumber.value.replaceRange(3, 4, 'O');
          }

          print("CONTROL: Serial Number $idSerialNumber");
        } else {
          //  Get.snackbar("Hata", "Seri Numarası Net Değil! Lütfen Tekrar Deneyin...");
          break;
        }
        isSerial = false;
      }
      if (isBirthDate) {
        if (double.tryParse(line[0]) != null &&
            double.tryParse(line[2]) == null &&
            dateRegex.hasMatch(line)) {
          idBirthdate.value = line;
          print("CONTROL: BIRTH DATE $line");
        } else {
          //  Get.snackbar("Hata", "Doğum Tarihi Net Değil! Lütfen Tekrar Deneyin...");

          break;
        }
        isBirthDate = false;
      }
      if (isValidUntil) {
        if (double.tryParse(line[0]) != null &&
            double.tryParse(line[2]) == null &&
            dateRegex.hasMatch(line)) {
          idValidUntil.value = line;
          print("CONTROL: VALID UNTIL:  $line");
        } else {
          //   Get.snackbar("Hata", "Son Geçerlilik Tarihi Net Değil! Lütfen Tekrar Deneyin...");

          break;
        }

        isValidUntil = false;
      }

      //! !
      if (isTCKN) {
        if (true) {
          idTCKN.value = line;
          print("CONTROL: TCKN:  $line");
        }

        isTCKN = false;
      }
      if (isName) {
        if (true) {
          idName.value = line;
          print("CONTROL: NAME:  $line");
        }

        isName = false;
      }
      if (isSurname) {
        if (true) {
          idSurname.value = line;
          print("CONTROL: SURNAME:  $line");
        }

        isSurname = false;
      }

      if (birthDateKeywords.any((k) => line.contains(k))) {
        isBirthDate = true;
        counter++;
      }

      if (serialKeywords.any((k) => line.contains(k))) {
        isSerial = true;
        counter++;
      }

      if (validUntilKeywords.any((k) => line.contains(k))) {
        isValidUntil = true;
        counter++;
      }

      if (tcknKeywords.any((k) => line.contains(k))) {
        isTCKN = true;
        counter++;
      }

      if (surnameKeywords.any((k) => line.contains(k))) {
        isSurname = true;
        counter++;
      }

      if (nameKeywords.any((k) => line.contains(k))) {
        isName = true;
        counter++;
      }

      print(line);
    }
    if (counter != 6) {
      Get.snackbar("Error",
          "Some data couldn't be retrieved from the ID card photo. Please check photo quality and try again...",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.only(
            top: MediaQuery.of(Get.context!).size.height * 0.82,
            left: 20,
            right: 20,
          ),
          duration: const Duration(seconds: 1),
          dismissDirection: DismissDirection.horizontal);
    } else {
      Get.snackbar('Success', 'Data successfully extracted from ID card photo.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.only(
            top: MediaQuery.of(Get.context!).size.height * 0.82,
            left: 20,
            right: 20,
          ),
          duration: const Duration(seconds: 1),
          dismissDirection: DismissDirection.horizontal);
      Get.to(IdDetailView());
    }
  }

  // // Find barcode in the picture, if picture contains a barcode, then it is a back side.
  // Future<String?> scanFile() async {
  //   // Used to pick a file from device storage
  //   var response = await BarcodeFinder.scanFile(path: imagePaths[0]);
  //   barcodeValue = response.toString();
  //   return response;
  // }

  changeSnackbarValue(bool isShown) {
    isSnackbarShown.value = isShown;
  }
}
