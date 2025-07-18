import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/home_capsule_time_component.dart';
import '../component/home_header_component.dart';
import '../provider/email_provider.dart';
import '../provider/user_data_provider.dart';

class HomeScreen extends StatefulWidget {
  final Function()? onTap;
  const HomeScreen({super.key, this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    final diseaseList = Provider.of<UserDiseaseProvider>(context).diseaseData;
    final email = context.read<EmailProvider>().email;
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          final isScrollable = constraints.maxHeight < 600;
          final screenWidth = MediaQuery.of(context).size.width;
          final isTablet = screenWidth >= 768;
          final pixel = screenWidth / 375 * 0.97;
          final content = Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: kIsWeb ? 24 * pixel : 54 * pixel),
                        homeHeader(pixel, context, email),
                        SizedBox(
                          height: kIsWeb ? 20 * pixel : 34 * pixel,
                        ),
                        homeCapsuleTimeContainer(pixel, diseaseList, kIsWeb),
                        SizedBox(
                          height: 20 * pixel,
                        ),
                      ])));

          // 600보다 작으면 스크롤 적용

          return SingleChildScrollView(
              physics:
                  isScrollable ? null : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: content,
              ));
        }));
  }
}
