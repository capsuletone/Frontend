import 'package:capsuleton_flutter/provider/user_data_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'provider/date_provider.dart';
import 'provider/email_provider.dart';
import 'provider/tablet_provider.dart';
import 'utils/gorouter.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appRouter = AppRouter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => EmailProvider()),
      ChangeNotifierProvider(
          create: (BuildContext context) => UserDiseaseProvider()),
      ChangeNotifierProvider(
          create: (BuildContext context) => EventsProvider()),
      ChangeNotifierProvider(create: (BuildContext context) => TabletProvider())
    ],
    child: MyApp(router: appRouter.router),
  ));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // 애뮬레이터에서 debug 보이는 거
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'capsuleton', // Optionally, add app title and theme as well
      theme: ThemeData(),
      locale: const Locale('ko', 'KR'), // 기본 로케일을 한국어로 설정
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // 머티리얼 로컬라이제이션
        GlobalWidgetsLocalizations.delegate, // 위젯 로컬라이제이션
        GlobalCupertinoLocalizations.delegate, // 쿠퍼티노 로컬라이제이션
      ],
    );
  }
}
