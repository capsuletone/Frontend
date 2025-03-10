import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 import

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String parsedtext = '';

  Future _getFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final apiKey = dotenv.env['API_KEY'] ?? 'No API Key found';
    var bytes = File(pickedFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      "language": "kor" // 한국어로 설정
    };
    var header = {"apikey": apiKey};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);

    if (post.statusCode == 200) {
      var result = jsonDecode(post.body);
      setState(() {
        parsedtext = result['ParsedResults'][0]['ParsedText'];
      });
      print("결과값 : $parsedtext");
      print("Response body: ${post.body}");
    } else {
      print("Error: ${post.statusCode}");
      print("Response body: ${post.body}");
    }

    setState(() {
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
    print("결과값 : $parsedtext");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('텍스트 인식')),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0),
            alignment: Alignment.center,
            child: Text(
              "OCR APP",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: ElevatedButton(
              onPressed: () => _getFromGallery(),
              child: Text(
                'Upload a image',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(height: 70.0),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  "ParsedText is:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  parsedtext,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
