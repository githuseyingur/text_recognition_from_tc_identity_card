import 'package:barcode_finder/barcode_finder.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExtractDataController extends GetxController {
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

  RegExp dateRegex = RegExp(r'^\d{2}\.\d{2}\.\d{4}$'); // get date from picture and validate with this Regex

  Future<void> getImage() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted = await Permission.camera.request() == PermissionStatus.granted;
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

      bool success = await EdgeDetection.detectEdge(
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
    if (imagePath.value != null) {
      inputImage = InputImage.fromFilePath(imagePath.value);
      TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      List<String> lines = text.split('\n');

      bool isSerial = false;
      bool isBirthDate = false;
      bool isValidUntil = false;
      bool isTCKN = false;
      bool isName = false;
      bool isSurname = false;
      bool isGender = false;
      int counter = 0;

      for (var line in lines) {
        print("line : $line");
        if (isSerial) {
          if (line.startsWith('A') && line.length == 9) {
            idSerialNumber.value = line;
            if (line[3] == '1') idSerialNumber.value = idSerialNumber.value.replaceRange(3, 4, 'I');
            if (line[3] == '0') idSerialNumber.value = idSerialNumber.value.replaceRange(3, 4, 'O');

            print("CONTROL: Serial Number $idSerialNumber");
          } else {
            //  Get.snackbar("Hata", "Seri Numarası Net Değil! Lütfen Tekrar Deneyin...");
            break;
          }
          isSerial = false;
        }
        if (isBirthDate) {
          if (double.tryParse(line[0]) != null && double.tryParse(line[2]) == null && dateRegex.hasMatch(line)) {
            idBirthdate.value = line;
            print("CONTROL: BIRTH DATE $line");
          } else {
            //  Get.snackbar("Hata", "Doğum Tarihi Net Değil! Lütfen Tekrar Deneyin...");

            break;
          }
          isBirthDate = false;
        }
        if (isValidUntil) {
          if (double.tryParse(line[0]) != null && double.tryParse(line[2]) == null && dateRegex.hasMatch(line)) {
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
          } else {
            //   Get.snackbar("Hata", "Son Geçerlilik Tarihi Net Değil! Lütfen Tekrar Deneyin...");
            break;
          }

          isTCKN = false;
        }
        if (isName) {
          if (true) {
            idName.value = line;
            print("CONTROL: NAME:  $line");
          } else {
            //   Get.snackbar("Hata", "Son Geçerlilik Tarihi Net Değil! Lütfen Tekrar Deneyin...");

            break;
          }

          isName = false;
        }
        if (isSurname) {
          if (true) {
            idSurname.value = line;
            print("CONTROL: SURNAME:  $line");
          } else {
            //   Get.snackbar("Hata", "Son Geçerlilik Tarihi Net Değil! Lütfen Tekrar Deneyin...");

            break;
          }

          isSurname = false;
        }

        if (line.contains("Birth") ||
            line.contains("Date") ||
            line.contains("Doğum") ||
            line.contains("Tarihi") ||
            line.contains("Tarini") ||
            line.contains("Tartini") ||
            line.contains("Doğu")) {
          isBirthDate = true;
          counter++;
        }

        if (line.contains("Seri") || line.contains("Document") || line.contains("Ser") || line.contains("Doc")) {
          isSerial = true;
          counter++;
        }

        if (line.contains("Son") ||
            line.contains("Geçerlilik") ||
            line.contains("Valid") ||
            line.contains("Until") ||
            line.contains("Geçer") ||
            line.contains("Valia") ||
            line.contains("Unti") ||
            line.contains("Geçeri") ||
            line.contains("Geçerli")) {
          isValidUntil = true;
          counter++;
        }
        if (line.contains("Kimlik No") ||
            line.contains("Kimlik") ||
            line.contains("TR Identity") ||
            line.contains("Identity No") ||
            line.contains("Identity") ||
            line.contains("TR") ||
            line.contains("entity") ||
            line.contains("ity No")) {
          isTCKN = true;
          counter++;
        }
        if (line.contains("Soyadı") ||
            line.contains("Surname") ||
            line.contains("Soyadi") ||
            line.contains("urname") ||
            line.contains("Soyad")) {
          isSurname = true;
          counter++;
        }
        if (line.contains("Adı") ||
            line.contains("Adi") ||
            line.contains("Given Name") ||
            line.contains("Name(s)") ||
            line.contains("Give") ||
            line.contains("Name") ||
            line.contains("Gven")) {
          isName = true;
          counter++;
        }

        print(line);
      }
      if (counter != 6) {
        Get.snackbar("Error",
            "Some data couldn't be retrieved from the ID card photo. Please check photo quality and try again...",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar(
          'Success',
          'Data successfully extracted from ID card photo.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  // Find barcode in the picture, if picture contains a barcode, then it is a back side.
  Future<String?> scanFile() async {
    // Used to pick a file from device storage
    var response = await BarcodeFinder.scanFile(path: imagePaths[0]);
    barcodeValue = response.toString();
    return response;
  }
}
