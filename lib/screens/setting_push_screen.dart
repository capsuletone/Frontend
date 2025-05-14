import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../component/setting_line_component.dart';
import '../repository/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../provider/email_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _requestNotificationPermissions() async {
  // Android 13 이상: 알림 권한 요청
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
    print("알림 권한 요청됨.");
  } else {
    print("알림 권한이 이미 부여됨.");
  }

  // iOS 권한 요청
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
  print("iOS 알림 권한 요청됨.");
}

class SettingPushScreen extends StatefulWidget {
  @override
  _SettingPushScreenState createState() => _SettingPushScreenState();
}

class _SettingPushScreenState extends State<SettingPushScreen> {
  bool _isToggled = false;
  late TextEditingController _morningController;
  late TextEditingController _lunchController;
  late TextEditingController _dinnerController;

  late NotificationRepository _notificationRepository;

  @override
  void initState() {
    super.initState();
    _morningController = TextEditingController();
    _lunchController = TextEditingController();
    _dinnerController = TextEditingController();

    _notificationRepository = NotificationRepository();

    _loadTimes();
    _requestNotificationPermissions();
  }

  // SharedPreferences에서 알림 시간 로드
  Future<void> _loadTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _morningController.text = prefs.getString('morning_time') ?? '08:00';
      _lunchController.text = prefs.getString('lunch_time') ?? '12:00';
      _dinnerController.text = prefs.getString('dinner_time') ?? '18:00';
    });
  }

  // 알림 시간 저장 및 설정
  Future<void> _saveTimes() async {
    String email = Provider.of<EmailProvider>(context, listen: false).email;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${email}_morning', _morningController.text);
    await prefs.setString('${email}_lunch', _lunchController.text);
    await prefs.setString('${email}_dinner', _dinnerController.text);

    // 알림 설정
    if (_isToggled) {
      await _notificationRepository.requestUserAndNotify(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isScrollable = constraints.maxHeight < 600;
              final screenWidth = MediaQuery.of(context).size.width;
              final isTablet = screenWidth >= 768;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
                child: Column(
                  children: [
                    if (!isScrollable || !isTablet)
                      SizedBox(height: 54 * pixel),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go('/root');
                          },
                          child: const Text("뒤로가기"),
                        ),
                        Container(
                          height: 120 * pixel,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 * pixel, vertical: 18 * pixel),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '케어 알림',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30 * pixel,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 10 * pixel),
                                      Text(
                                        "약 먹을 시간에 알림",
                                        style: TextStyle(
                                          color: const Color(0x7F191F28),
                                          fontSize: 13 * pixel,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isToggled = !_isToggled;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: 50 * pixel,
                                      height: 30 * pixel,
                                      decoration: BoxDecoration(
                                        color: _isToggled
                                            ? Colors.green[300]
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(25 * pixel),
                                      ),
                                      child: Stack(
                                        children: [
                                          AnimatedAlign(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            alignment: _isToggled
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(2.0 * pixel),
                                              child: Container(
                                                width: 27 * pixel,
                                                height: 27 * pixel,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8 * pixel),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('아침 알림 시간'),
                          TextField(
                            controller: _morningController,
                            decoration: const InputDecoration(
                              hintText: '08:00',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10 * pixel),
                          Text('점심 알림 시간'),
                          TextField(
                            controller: _lunchController,
                            decoration: const InputDecoration(
                              hintText: '12:00',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10 * pixel),
                          Text('저녁 알림 시간'),
                          TextField(
                            controller: _dinnerController,
                            decoration: const InputDecoration(
                              hintText: '18:00',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20 * pixel),
                          ElevatedButton(
                            onPressed: () async {
                              await _saveTimes();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('알림 시간이 설정되었습니다.'),
                                ),
                              );
                            },
                            child: const Text('알림 시간 설정 완료'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
