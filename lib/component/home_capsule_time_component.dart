import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget homeCapsuleTimeContainer(double pixel) {
  double widthSize = 400 * pixel;
  double heightSize = 300 * pixel;
  double fontSize = 24.0 * pixel; // 글자 크기 설정
  double spacing = 30.0 * pixel; // 두 텍스트 사이의 간격 설정

  return Container(
    width: widthSize, // 가로 500
    height: heightSize, // 세로 300
    padding: EdgeInsets.all(16 * pixel),
    color: Colors.green[300], // 배경색
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '현재 시각 : 저녁',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16 * pixel),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // 리스트 아이템 개수

            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0 * pixel), // 각 Row 간의 간격 설정
                  child: GestureDetector(
                      onTap: () {
                        // '/detail'로 이동하면서 데이터를 전달
                        context.go('/root/home/detail');
                      },
                      child: Container(
                          child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30, // 원형 아바타 크기
                            backgroundImage: NetworkImage(
                                'https://www.example.com/avatar.jpg'), // 아바타 이미지 URL
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('이름: $index',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('설명:  $index',
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ))));
            },
          ),
        ),
      ],
    ),
  );
}
