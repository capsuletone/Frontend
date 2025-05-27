import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart'; // 추가
import '../database/requestuser_request_database.dart';
import '../database/requestuser_response_extentions_database.dart';
import '../utils/endpoint.dart';

class NotificationRepository {
  static final NotificationRepository _instance =
      NotificationRepository._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationRepository() {
    return _instance;
  }

  NotificationRepository._internal();

  /// 알림 초기화
  Future<void> init() async {
    // 1. 알림 권한 요청 (Android 13 이상)
    await requestNotificationPermission();

    // 2. 알림 초기화
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 3. 타임존 초기화
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  /// 알림 권한 요청 (Android 13 이상)
  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        print('✅ 알림 권한 허용됨');
      } else {
        print('⚠️ 알림 권한 거부됨');
      }
    } else {
      print('✅ 알림 권한 이미 허용됨');
    }
  }

  /// 단일 알림 예약 (미래 시간일 경우에만 예약)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      print('⏭️ 알림 스킵됨: 과거 시간 (${scheduledTime.toIso8601String()})');
      return; // 과거 시간은 예약하지 않음
    }

    print('⏰ 알림 예약됨: $title - $body @ ${scheduledTime.toLocal()}');

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel_id',
          '약 복용 알림',
          channelDescription: '약 복용 시간을 알려주는 채널입니다.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('[알림 제거] 모든 알림이 해제되었습니다.');
  }

  /// 알림 설정 (API 응답 데이터를 기반으로)
  Future<void> setupMedicineNotifications(
      String userid, List<Map<String, dynamic>> medicineData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String morningTime = prefs.getString('${userid}_morning') ?? '08:00';
    String lunchTime = prefs.getString('${userid}_lunch') ?? '09:25';
    String dinnerTime = prefs.getString('${userid}_dinner') ?? '21:25';

    await cancelAllNotifications(); // 기존 알림을 취소

    int notificationId = 0;

    for (var item in medicineData) {
      List<dynamic> medicines = item['medicines'];
      for (var medicine in medicines) {
        String medicineName = medicine['medicineName'];
        String time = medicine['time']; // '아침,점심,저녁'
        String startDateStr = medicine['date'];
        int totalDays = medicine['totalDays'];

        DateTime startDate = DateTime.parse(startDateStr);

        for (int i = 0; i < totalDays; i++) {
          DateTime currentDate = startDate.add(Duration(days: i));

          // 알림 예약 시간 출력 (디버깅)
          print('현재 날짜: $currentDate');

          if (time.contains('아침')) {
            final scheduledTime = _combineDateAndTime(currentDate, morningTime);
            await scheduleNotification(
              id: notificationId++,
              title: '약 복용 알림',
              body: '$medicineName 먹을 시간입니다.',
              scheduledTime: scheduledTime,
            );
          }
          if (time.contains('점심')) {
            final scheduledTime = _combineDateAndTime(currentDate, lunchTime);
            await scheduleNotification(
              id: notificationId++,
              title: '약 복용 알림',
              body: '$medicineName 먹을 시간입니다.',
              scheduledTime: scheduledTime,
            );
          }
          if (time.contains('저녁')) {
            final scheduledTime = _combineDateAndTime(currentDate, dinnerTime);
            await scheduleNotification(
              id: notificationId++,
              title: '약 복용 알림',
              body: '$medicineName 먹을 시간입니다.',
              scheduledTime: scheduledTime,
            );
          }
        }
      }
    }
  }

  /// 날짜와 시간 문자열을 결합하여 DateTime 생성
  DateTime _combineDateAndTime(DateTime date, String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  /// 예약된 알림 목록 확인 (시간은 알 수 없음)
  Future<void> checkScheduledNotifications() async {
    final pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    if (pendingNotifications.isEmpty) {
      print('설정된 알림이 없습니다.');
    } else {
      print('설정된 알림 목록:');
      for (var notification in pendingNotifications) {
        print(
            '알림 ID: ${notification.id}, 제목: ${notification.title}, 내용: ${notification.body}');
      }
    }
  }

  /// 사용자 요청 및 알림 설정 (API 호출 포함)
  Future<List<RequestuserResponseExtentionsDatabase>?> requestUserAndNotify(
      String userid) async {
    const url = 'http://211.188.63.79:8080/requestuserdata'; // 실제 API URL로 교체
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'userid': userid});

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode != 200) {
        print('❌ API 오류: ${response.statusCode}');
        return null;
      }

      final responseData = json.decode(response.body);

      List<RequestuserResponseExtentionsDatabase> parsedData =
          (responseData as List)
              .map((jsonItem) =>
                  RequestuserResponseExtentionsDatabase.fromJson(jsonItem))
              .toList();

      await init(); // 알림 초기화
      await setupMedicineNotifications(
        userid,
        List<Map<String, dynamic>>.from(responseData),
      );

      await checkScheduledNotifications(); // 예약된 알림 확인

      return parsedData;
    } catch (e) {
      print('❌ 요청 중 오류 발생: $e');
      return null;
    }
  }
}
