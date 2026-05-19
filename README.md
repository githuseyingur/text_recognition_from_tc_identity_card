# Extract Text From TC Identity Card with Flutter using Google ML Kit Text Recognition


### Packages : 

```
permission_handler: ^10.4.3
path: ^1.8.2
path_provider: ^2.0.14
edge_detection_plus: ^1.0.2
get: ^4.6.5
google_mlkit_text_recognition: ^0.11.0
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



<img width="280" height="580" alt="1" src="https://github.com/user-attachments/assets/35c74e92-0ea7-4116-af15-ff76df0c5ed7" />
<img width="280" height="580" alt="2" src="https://github.com/user-attachments/assets/9a45fc66-8ef1-4bac-93c9-1609a996bd56" />
<img width="280" height="580" alt="3" src="https://github.com/user-attachments/assets/63593e64-58cc-4679-8ee5-f47d223808aa" />
<img width="280" height="580" alt="4" src="https://github.com/user-attachments/assets/8f201d88-5d9d-4bb6-bb4c-0452f3753999" />
<img width="280" height="580" alt="5" src="https://github.com/user-attachments/assets/8982ffdf-8767-4e44-8a9b-45d6e430e3c5" />
<img width="280" height="580" alt="6" src="https://github.com/user-attachments/assets/25a37213-a4b7-457b-8ffa-c1d037019fde" />


