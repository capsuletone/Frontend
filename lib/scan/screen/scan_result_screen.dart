import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionScreen extends StatefulWidget {
  final File imageFile;

  TextRecognitionScreen({required this.imageFile});

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  String recognizedText = "텍스트를 인식 중입니다...";
  late final TextRecognizer textRecognizer;

  @override
  void initState() {
    super.initState();
    textRecognizer = GoogleMlKit.vision.textRecognizer();
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      final InputImage inputImage = InputImage.fromFile(widget.imageFile);
      final RecognizedText recognizedTextResult =
          await textRecognizer.processImage(inputImage);

      setState(() {
        recognizedText = recognizedTextResult.text.isNotEmpty
            ? recognizedTextResult.text
            : "텍스트를 찾을 수 없습니다.";
      });
    } catch (e) {
      setState(() {
        recognizedText = "오류 발생: $e";
      });
    } finally {
      textRecognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('인식된 텍스트')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            recognizedText,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
