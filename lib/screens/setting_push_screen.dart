import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
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
      _morningController.text = prefs.getString('morning_time') ?? '8:00';
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(children: [
                        if (!isScrollable || !isTablet)
                          SizedBox(height: 54 * pixel),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => context.go('/root'),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 24.0 * pixel,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 120 * pixel,
                                width: double.infinity,
                                padding:
                                    EdgeInsets.symmetric(vertical: 18 * pixel),
                                child: Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isToggled = !_isToggled;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  width: 50 * pixel,
                                                  height: 30 * pixel,
                                                  decoration: BoxDecoration(
                                                    color: _isToggled
                                                        ? Colors.green[300]
                                                        : Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25 * pixel),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      AnimatedAlign(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        alignment: _isToggled
                                                            ? Alignment
                                                                .centerRight
                                                            : Alignment
                                                                .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0 * pixel),
                                                          child: Container(
                                                            width: 27 * pixel,
                                                            height: 27 * pixel,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: 10 * pixel),
                                        Text(
                                          "알림을 받으시려면 토글을 켜고, 복용 시간을 설정해주세요.",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12 * pixel,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 8 * pixel),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '아침 알림 시간',
                                          style: TextStyle(
                                            fontSize: 16 * pixel,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10 * pixel),
                                        TextField(
                                          controller: _morningController,
                                          style: TextStyle(
                                            fontSize:
                                                20 * pixel, // 입력 텍스트 크기 키우기
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '8:00',
                                            hintStyle: TextStyle(
                                              fontSize: 20 * pixel,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 10 * pixel),
                                        Text(
                                          '점심 알림 시간',
                                          style: TextStyle(
                                            fontSize: 16 * pixel,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10 * pixel),
                                        TextField(
                                          controller: _lunchController,
                                          style: TextStyle(
                                            fontSize:
                                                20 * pixel, // 입력 텍스트 크기 키우기
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '12:00',
                                            hintStyle: TextStyle(
                                              fontSize: 20 * pixel,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 10 * pixel),
                                        Text(
                                          '저녁 알림 시간',
                                          style: TextStyle(
                                            fontSize: 16 * pixel,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10 * pixel),
                                        TextField(
                                          controller: _dinnerController,
                                          style: TextStyle(
                                            fontSize:
                                                20 * pixel, // 입력 텍스트 크기 키우기
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '18:00',
                                            hintStyle: TextStyle(
                                              fontSize: 20 * pixel,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        )
                                      ]))
                            ]),
                      ]),
                    ),
                    Container(
                        child: Column(children: [
                      GestureDetector(
                        onTap: () async {
                          await _saveTimes();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('알림 시간이 설정되었습니다.'),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16 * pixel),
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(12 * pixel),
                          ),
                          child: Text(
                            "알림 시간 설정 완료",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17 * pixel,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 68 * pixel)
                    ])),
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
