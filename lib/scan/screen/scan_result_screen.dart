// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// class TextRecognitionScreen extends StatefulWidget {
//   final File imageFile;
//   TextRecognitionScreen({required this.imageFile});

//   @override
//   _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
// }

// class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
//   final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
//   String _recognizedText = '';

//   @override
//   void initState() {
//     super.initState();
//     _processImage();
//   }

//   Future<void> _processImage() async {
//     final inputImage = InputImage.fromFilePath(widget.imageFile.path);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);
//     setState(() {
//       _recognizedText = recognizedText.text;
//     });
//   }

//   @override
//   void dispose() {
//     textRecognizer.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('텍스트 인식')),
//       body: Column(
//         children: [
//           Image.file(widget.imageFile),
//           SizedBox(height: 10),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               _recognizedText,
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
