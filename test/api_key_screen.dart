//api key 발급 받는 방법.
// mport 'package:flutter/material.dart';
// import 'dart:convert';
// import 'dart:io';

// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String parsedtext = ''; // 추출된 텍스트를 저장할 String 변수
//   String filepath = '';

//   parsethetext() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;
//     var bytes = File(pickedFile.path.toString()).readAsBytesSync();
//     String img64 = base64Encode(bytes);

//     var url = 'https://api.ocr.space/parse/image';
//     var payload = {
//       "base64Image": "data:image/jpg;base64,${img64.toString()}",
//       "language": "kor"
//     };
//     var header = {"apikey": "K82885659688957"};

//     var post = await http.post(Uri.parse(url), body: payload, headers: header);
//     var result = jsonDecode(post.body); // 추출 결과를 받아서 result에 저장
//     setState(() {
//       parsedtext =
//           result['ParsedResults'][0]['ParsedText']; // 추출결과를 다시 parsedtext로 저장
//       filepath = pickedFile!.path;
//     });
//     print("리턴 값: $parsedtext");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _imageSize = MediaQuery.of(context).size.width / 4;

//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           Container(
//             constraints: BoxConstraints(
//               minHeight: _imageSize,
//               minWidth: _imageSize,
//             ),
//           ),
//           Container(
//             width: 400,
//             height: 200,
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               border: Border.all(
//                   width: 2, color: Theme.of(context).colorScheme.primary),
//               image: DecorationImage(
//                   image: FileImage(File(filepath)), fit: BoxFit.contain),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 30.0),
//             alignment: Alignment.center,
//             child: Text(
//               "OCR APP",
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 15.0),
//           Container(
//               width: MediaQuery.of(context).size.width / 1,
//               height: MediaQuery.of(context).size.height / 15,
//               child: ElevatedButton(
//                   onPressed: () => parsethetext(),
//                   child: Text('사진을 선택해주세요',
//                       style: TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.w700)))),
//           Container(
//             height: 30,
//           ),
//           Container(
//             alignment: Alignment.center,
//             child: Column(
//               children: <Widget>[
//                 Text(
//                   "추출된 텍스트는",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10.0),
//                 Text(
//                   parsedtext,
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
