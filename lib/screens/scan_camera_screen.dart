import 'dart:convert';
import 'dart:io';
import 'package:capsuleton_flutter/database/naver_ocr_request_database.dart';
import 'package:capsuleton_flutter/repository/naver_ocr_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../database/naver_ocr_response_database.dart';
import 'scan_result_screen.dart';

class CameraScreen extends StatefulWidget {
  final String userId;
  const CameraScreen({super.key, required this.userId});

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

      print("✅ Base64 이미지: $base64String"); // 긴 Base64는 일부만 출력
      final reuqestData = NaverOcrRequestDatabase(base64: base64String);
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

      print("✅ Base64 이미지: $base64String");

      final requestData = NaverOcrRequestDatabase(base64: base64String);
      naverOcrRepository.ocrPicture(requestData, context);
    }
  }

//   void processAndSaveUserData({
//     required String userId,
//     required DateTime date,
//     required String diseaseCode,
//     required List<String?> medicineName,
//     required List<double?> dosesPerDay,
//     required List<int?> totalDays,
//   }) {
//     final formattedDate = "$date";

//     for (int i = 0; i < medicineName.length; i++) {
//       final name = medicineName[i];
//       final doses = dosesPerDay[i] ?? 0;
//       final days = totalDays[i] ?? 0;

//       // 복용 횟수에 따라 시간대 분할
//       List<String> times = _getTimesByDoses(doses);

//       for (String time in times) {
//         final data = {
//           'userId': userId,
//           'diseaseCode': diseaseCode,
//           'medicineName': name,
//           'time': time,
//           'totalDays': days,
//           'date': formattedDate,
//         };

//         saveUserData(data);
//       }
//     }
//   }

// // 복용 횟수에 따라 시간대 정하기
//   List<String> _getTimesByDoses(double doses) {
//     if (doses == 3.0) {
//       return ['아침', '점심', '저녁'];
//     } else if (doses == 2.0) {
//       return ['아침', '저녁'];
//     } else if (doses == 1.0) {
//       return ['점심'];
//     } else {
//       return ['알수없음'];
//     }
//   }

//   void saveUserData(Map<String, dynamic> data) {
//     print("Saving user data: $data");
//     // 실제 저장 처리 로직을 여기에 구현
//   }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;
    return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    SizedBox(height: 54 * pixel),
                    GestureDetector(
                      onTap: () => context.go('/root'),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 24.0 * pixel,
                        color: Colors.black,
                      ),
                    ),
                    Center(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: 40 * pixel), // 여백도 확대
                      Container(
                        width: 430 * pixel,
                        height: 430 * pixel,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.contain)
                              : Center(
                                  child: Text(
                                    "아직 사진 없음",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 22 * pixel, // 🔍 더 크게
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 40 * pixel), // 버튼과 이미지 간 여백 확대
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: takePicture,
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              size: 28 * pixel,
                              color: Colors.white,
                            ),
                            label: Text(
                              "카메라",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18 * pixel,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28 * pixel, vertical: 18 * pixel),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                          SizedBox(width: 24 * pixel), // 버튼 간 간격 확대
                          ElevatedButton.icon(
                            onPressed: handleImage,
                            icon: Icon(
                              Icons.photo_library_outlined,
                              size: 28 * pixel,
                              color: Colors.white,
                            ),
                            label: Text(
                              "앨범",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18 * pixel,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28 * pixel, vertical: 18 * pixel),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ],
                      )
                    ]))
                  ])),
              Container(
                  child: Column(children: [
                SizedBox(
                  height: 30 * pixel,
                ),
                SizedBox(
                  height: 34 * pixel,
                ),
              ])),
            ],
          ),
        )));
  }
}
