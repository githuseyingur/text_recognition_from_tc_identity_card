import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Colors.white),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => TextRecognitionState(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RegExp isimPattern = RegExp(r'Name(s) (\w+),');
  RegExp soyisimPattern = RegExp(r'SurName (\w+),');
  RegExp dogumTarihiPattern = RegExp(r'Date of Birth ([\d-]+)');
  TextRecognition? _textRecognition = TextRecognition();

  /* TextRecognition? _textRecognition = TextRecognition(
    options: TextRecognitionOptions.Japanese
  ); */

  @override
  void dispose() {
    _textRecognition?.dispose();
    super.dispose();
  }

  Future<void> _startRecognition(InputImage image) async {
    TextRecognitionState state = Provider.of(context, listen: false);

    if (state.isNotProcessing) {
      state.startProcessing();
      state.image = image;
      state.data = await _textRecognition?.process(image);
      state.stopProcessing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputCameraView(
      mode: InputCameraMode.gallery,
      // resolutionPreset: ResolutionPreset.high,
      title: 'Text Recognition',
      onImage: _startRecognition,
      overlay: Consumer<TextRecognitionState>(
        builder: (_, state, __) {
          if (state.isNotEmpty) {
            print("******");
            print(state.text);
            print("******");

            List<String> lines = state.text.split('\n');
            bool isSerial = false;
            bool isBirthDate = false;
            bool isVlidUntil = false;
            int counter = 0;

            for (var line in lines) {
              if (counter != 3 && (line.contains("Signature") || line.contains("Imzası"))) {
                Fluttertoast.showToast(
                    msg: "Fotoğraf Net Değil! Lütfen Tekrar Deneyin...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                break;
              } else {
                if (isSerial) {
                  if (line.startsWith('A') && double.tryParse(line[3]) == null) {
                    print("CONTROL: Serial Number $line");
                  } else {
                    Fluttertoast.showToast(
                        msg: "Seri Numarası Net Değil! Lütfen Tekrar Deneyin...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    break;
                  }
                  isSerial = false;
                }
                if (isBirthDate) {
                  if (double.tryParse(line[0]) != null && double.tryParse(line[2]) == null) {
                    print("CONTROL: BIRTH DATE $line");
                  } else {
                    Fluttertoast.showToast(
                        msg: "Doğum Tarihi Net Değil! Lütfen Tekrar Deneyin...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    break;
                  }
                  isBirthDate = false;
                }
                if (isVlidUntil) {
                  if (double.tryParse(line[0]) != null && double.tryParse(line[2]) == null) {
                    print("CONTROL: VALID UNTIL:  $line");
                  } else {
                    Fluttertoast.showToast(
                        msg: "Son Geçerlilik Tarihi Net Değil! Lütfen Tekrar Deneyin...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    break;
                  }

                  isVlidUntil = false;
                }
                if (line.contains("Birth") ||
                    line.contains("Date") ||
                    line.contains("Doğum") ||
                    line.contains("Tarihi")) {
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
                    line.contains("Until")) {
                  isVlidUntil = true;
                  counter++;
                }

                print(line);
              }
            }
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Column(
                  children: [
                    Text(
                      state.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}

class TextRecognitionState extends ChangeNotifier {
  InputImage? _image;
  RecognizedText? _data;
  bool _isProcessing = false;

  InputImage? get image => _image;
  RecognizedText? get data => _data;
  String get text => _data!.text;
  bool get isNotProcessing => !_isProcessing;
  bool get isNotEmpty => _data != null && text.isNotEmpty;

  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }

  set image(InputImage? image) {
    _image = image;
    notifyListeners();
  }

  set data(RecognizedText? data) {
    _data = data;
    notifyListeners();
  }
}
