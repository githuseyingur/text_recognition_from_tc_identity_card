# Extract Text From TC Identity Card with Flutter


### Packages : 

```
barcode_finder: ^0.0.5
permission_handler: ^10.4.3
path: ^1.8.2
path_provider: ^2.0.15
edge_detection: ^1.1.2
lottie: ^2.3.2             // for UI (optional)
get: ^4.6.5
google_mlkit_text_recognition: ^0.8.1
```

#### Get Text From Image:

```dart
  final InputImage inputImage;
    if (imagePath.value != null) {
      inputImage = InputImage.fromFilePath(imagePath.value);
      TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      List<String> lines = text.split('\n');
   ```   

### Screenshots :

<img src="https://github.com/githuseyingur/flutter_text_recog_from_tc_identity_card/assets/120099096/08054602-bd8a-41ee-8730-b38796ced406"  width="280" height ="580">
<img src="https://github.com/githuseyingur/flutter_text_recog_from_tc_identity_card/assets/120099096/57b6d1bb-9d46-43d6-b664-6ffdf56115aa"  width="280" height ="580">
<img src="https://github.com/githuseyingur/flutter_text_recog_from_tc_identity_card/assets/120099096/17953d0c-395b-465c-81b4-acd72ea654d9"  width="280" height ="580">
<img src="https://github.com/githuseyingur/flutter_text_recog_from_tc_identity_card/assets/120099096/d9565a6f-179a-4f56-95aa-ab49fac8c43f"  width="280" height ="580">
