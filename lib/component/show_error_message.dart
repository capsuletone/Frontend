import 'package:flutter/material.dart';

class ShowErrorMessage {
  final double pixel;
  final String message;
  final BuildContext context;

  ShowErrorMessage({
    required this.pixel,
    required this.context,
    required this.message,
  });

  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[300],
          title: Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 20 * pixel, color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('닫기',
                  style: TextStyle(fontSize: 14 * pixel, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
