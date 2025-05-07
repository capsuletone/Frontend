import 'dart:convert';
import 'dart:io';
import 'package:capsuleton_flutter/database/naver_ocr_request_database.dart';
import 'package:capsuleton_flutter/repository/naver_ocr_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final naverOcrRepository = NaverOcrRepository();
  String? base64Image;
  File? _imageFile;

  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      File imageFile = File(photo.path);
      final bytes = await imageFile.readAsBytes();
      String base64String = base64Encode(bytes);

      setState(() {
        _imageFile = imageFile;
        base64Image = base64String;
      });

      print("✅ Base64 이미지: ${base64String}"); // 긴 Base64는 일부만 출력
      final reuqestData = NaverOcrRequestDatabase(base64img: base64String);
      naverOcrRepository.ocrPicture(reuqestData, context);
    }
  }

  Future<void> handleImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      File imageFile = File(photo.path);
      final bytes = await imageFile.readAsBytes();
      String base64String = base64Encode(bytes);

      setState(() {
        _imageFile = imageFile;
        base64Image = base64String;
      });

      print("✅ Base64 이미지: ${base64String}");

      final requestData = NaverOcrRequestDatabase(base64img: base64String);
      naverOcrRepository.ocrPicture(requestData, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("카메라로 사진 찍고 Base64 변환")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Text("아직 사진 없음"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: takePicture,
              child: const Text("사진 찍기"),
            ),
            ElevatedButton(
              onPressed: handleImage,
              child: const Text("앨범에서 가져오기"),
            ),
          ],
        ),
      ),
    );
  }
}
