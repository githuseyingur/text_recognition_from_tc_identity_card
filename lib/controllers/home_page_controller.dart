import 'package:barcode_finder/barcode_finder.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePageController extends GetxController {
  RxList<String> imagePaths = <String>[].obs;
  RxString imagePath = "".obs;
  RxInt imageCount = 0.obs;

  RxString idSerialNumber = "".obs;
  RxString idBirthdate = "".obs;
  RxString idValidUntil = "".obs;

  List<String> _imagePaths = [];
  String barcodeValue = '';

  RegExp dateRegex = RegExp(
      r'^\d{2}\.\d{2}\.\d{4}$'); // get date from picture and validate with this Regex

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

      bool success = await EdgeDetection.detectEdge(
        imagePath.value,
        canUseGallery: true,
        androidScanTitle: 'Tara', // use custom localizations for android
        androidCropTitle: 'Kırp',
        androidCropBlackWhiteTitle: 'Siyah Beyaz',
        androidCropReset: 'Sıfırla',
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
      TextRecognizer textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      List<String> lines = text.split('\n');
      bool isSerial = false;
      bool isBirthDate = false;
      bool isVlidUntil = false;
      int counter = 0;
      for (var line in lines) {
        if (isSerial) {
          if (line.startsWith('A') && line.length == 9) {
            idSerialNumber.value = line;
            if (line[3] == '1')
              idSerialNumber.value =
                  idSerialNumber.value.replaceRange(3, 4, 'I');
            if (line[3] == '0')
              idSerialNumber.value =
                  idSerialNumber.value.replaceRange(3, 4, 'O');

            print("CONTROL: Serial Number $idSerialNumber");
          } else {
            //  Get.snackbar("Hata", "Seri Numarası Net Değil! Lütfen Tekrar Deneyin...");
            print("Hatax: seri hatası");
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
            print("Hatax: doğum tarihi hatası");

            break;
          }
          isBirthDate = false;
        }
        if (isVlidUntil) {
          if (double.tryParse(line[0]) != null &&
              double.tryParse(line[2]) == null &&
              dateRegex.hasMatch(line)) {
            idValidUntil.value = line;
            print("CONTROL: VALID UNTIL:  $line");
          } else {
            //   Get.snackbar("Hata", "Son Geçerlilik Tarihi Net Değil! Lütfen Tekrar Deneyin...");
            print("Hatax: son geçerlilik ");

            break;
          }

          isVlidUntil = false;
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

        if (line.contains("Seri") || line.contains("Document")) {
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
          isVlidUntil = true;
          counter++;
        }

        print(line);
      }
      if (counter != 3) {
        //  Get.snackbar("Hata", "Fotoğraf Net Değil! Lütfen Tekrar Deneyin...");
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
