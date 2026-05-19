import 'package:detect_text_from_image/core/app_snackbar.dart';
import 'package:detect_text_from_image/models/id_card_model.dart';
import 'package:detect_text_from_image/models/scan_record.dart';
import 'package:detect_text_from_image/services/history_service.dart';
import 'package:detect_text_from_image/view/detail_view.dart';
import 'package:edge_detection_plus/edge_detection_plus.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExtractDataController extends GetxController {
  final RxString imagePath = ''.obs;
  final RxList<String> imagePaths = <String>[].obs;
  final Rx<IdCardModel> idCard = const IdCardModel().obs;
  final RxBool isProcessing = false.obs;

  late final TextRecognizer _textRecognizer;
  final _imagePicker = ImagePicker();

  static final RegExp _datePattern = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');

  static const _birthDateKeywords = ['Birth', 'Date', 'Doğum', 'Tarihi', 'Tarini', 'Tartini', 'Doğu'];
  static const _serialKeywords = ['Seri', 'Document', 'Ser', 'Doc'];
  static const _validUntilKeywords = ['Son', 'Geçerlilik', 'Valid', 'Until', 'Geçer', 'Valia', 'Unti', 'Geçeri', 'Geçerli'];
  static const _tcknKeywords = ['Kimlik No', 'Kimlik', 'TR Identity', 'Identity No', 'Identity', 'TR', 'entity', 'ity No'];
  static const _surnameKeywords = ['Soyadı', 'Surname', 'Soyadi', 'urname', 'Soyad'];
  static const _nameKeywords = ['Adı', 'Adi', 'Given Name', 'Name(s)', 'Give', 'Name', 'Gven'];

  @override
  void onInit() {
    super.onInit();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }

  void clearData() {
    idCard.value = const IdCardModel();
    imagePath.value = '';
    imagePaths.clear();
  }

  Future<void> getImage() async {
    if (!await _requestCameraPermission()) return;

    final path = join(
      (await getApplicationSupportDirectory()).path,
      '${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg',
    );

    try {
      final success = await EdgeDetectionPlus.detectEdge(
        path,
        canUseGallery: false,
        androidScanTitle: 'Scan',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      if (success) {
        imagePath.value = path;
        imagePaths.add(path);
      }
    } catch (e) {
      _showError('error_capture'.tr);
    }
  }

  Future<void> getImageFromGallery() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (file == null) return;

      imagePath.value = file.path;
      imagePaths.add(file.path);
    } catch (e) {
      _showError('error_capture'.tr);
    }
  }

  Future<void> processImage() async {
    if (imagePath.value.isEmpty || isProcessing.value) return;

    isProcessing.value = true;
    try {
      final inputImage = InputImage.fromFilePath(imagePath.value);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final parsed = _parseIdCard(recognizedText.text);
      idCard.value = parsed;

      if (parsed.fieldCount >= 3) {
        await HistoryService.add(ScanRecord(card: parsed, scannedAt: DateTime.now()));
        _showSuccess('success_extracted'.tr);
        Get.to(() => const DetailView());
      } else {
        _showError('error_low_data'.tr);
      }
    } catch (e) {
      _showError('error_process'.tr);
    } finally {
      isProcessing.value = false;
    }
  }

  IdCardModel _parseIdCard(String text) {
    final lines = text.split('\n');

    String tckn = '';
    String name = '';
    String surname = '';
    String birthdate = '';
    String serialNumber = '';
    String validUntil = '';

    bool expectSerial = false;
    bool expectBirthdate = false;
    bool expectValidUntil = false;
    bool expectTCKN = false;
    bool expectName = false;
    bool expectSurname = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (expectSerial && serialNumber.isEmpty) {
        serialNumber = _parseSerialNumber(trimmed);
        expectSerial = false;
      }
      if (expectBirthdate && birthdate.isEmpty) {
        if (_isValidDate(trimmed)) birthdate = trimmed;
        expectBirthdate = false;
      }
      if (expectValidUntil && validUntil.isEmpty) {
        if (_isValidDate(trimmed)) validUntil = trimmed;
        expectValidUntil = false;
      }
      if (expectTCKN && tckn.isEmpty) {
        tckn = trimmed;
        expectTCKN = false;
      }
      if (expectName && name.isEmpty) {
        name = trimmed;
        expectName = false;
      }
      if (expectSurname && surname.isEmpty) {
        surname = trimmed;
        expectSurname = false;
      }

      if (_matchesAny(trimmed, _birthDateKeywords)) expectBirthdate = true;
      if (_matchesAny(trimmed, _serialKeywords)) expectSerial = true;
      if (_matchesAny(trimmed, _validUntilKeywords)) expectValidUntil = true;
      if (_matchesAny(trimmed, _tcknKeywords)) expectTCKN = true;
      if (_matchesAny(trimmed, _nameKeywords)) expectName = true;
      if (_matchesAny(trimmed, _surnameKeywords)) expectSurname = true;
    }

    return IdCardModel(
      tckn: tckn,
      name: name,
      surname: surname,
      birthdate: birthdate,
      serialNumber: serialNumber,
      validUntil: validUntil,
    );
  }

  String _parseSerialNumber(String line) {
    if (!line.startsWith('A') || line.length != 9) return '';
    String serial = line;
    if (serial[3] == '1') serial = serial.replaceRange(3, 4, 'I');
    if (serial[3] == '0') serial = serial.replaceRange(3, 4, 'O');
    return serial;
  }

  bool _isValidDate(String value) =>
      value.length >= 3 &&
      double.tryParse(value[0]) != null &&
      double.tryParse(value[2]) == null &&
      _datePattern.hasMatch(value);

  bool _matchesAny(String line, List<String> keywords) =>
      keywords.any((k) => line.contains(k));

  Future<bool> _requestCameraPermission() async {
    if (await Permission.camera.isGranted) return true;
    return await Permission.camera.request() == PermissionStatus.granted;
  }

  void _showError(String message) => AppSnackbar.error(message);

  void _showSuccess(String message) => AppSnackbar.success(message);
}
