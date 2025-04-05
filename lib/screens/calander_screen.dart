import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalanderScreen extends StatefulWidget {
  final Function()? onTap;
  const CalanderScreen({super.key, this.onTap});

  @override
  State<CalanderScreen> createState() => _CalanderScreenState();
}

class _CalanderScreenState extends State<CalanderScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime kFirstDay = DateTime(2022, 01, 01);
  DateTime kLastDay = DateTime(2028, 12, 31);
  DateTime? _selectedDay;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: LayoutBuilder(builder: (context, constraints) {
              final isScrollable = constraints.maxHeight < 600;
              final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
              final isTablet = screenWidth >= 768; // 아이패드 여부 판단

              final content = Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 33 * pixel),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50 * pixel,
                            ),
                            TableCalendar(
                              headerStyle: HeaderStyle(
                                headerMargin:
                                    EdgeInsets.only(bottom: 20 * pixel),
                                titleTextStyle: TextStyle(
                                    color: Colors.white, fontSize: 20 * pixel),
                                decoration: BoxDecoration(
                                    color: Colors.green[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    )),
                                formatButtonVisible: false,
                                titleCentered: true,
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              rowHeight: 60 * pixel,
                              locale: 'ko-KR',
                              firstDay: kFirstDay,
                              lastDay: kLastDay,
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              calendarStyle: CalendarStyle(
                                markersAlignment: Alignment.bottomCenter,
                                canMarkersOverflow: true,
                                markersMaxCount: 2,
                                markersAnchor: 0.7,
                                todayDecoration: BoxDecoration(
                                  color: Color(0xff93bebd),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Colors.teal,
                                  shape: BoxShape.circle,
                                ),
                                weekendTextStyle: TextStyle(color: Colors.red),
                              ),
                              calendarBuilders: CalendarBuilders(
                                markerBuilder: (context, day, events) {
                                  if (events.isNotEmpty) {
                                    List iconEvents = events;
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: events.length,
                                        itemBuilder: (context, index) {
                                          Map key = iconEvents[index];
                                          if (key['iconIndex'] == 1) {
                                            return Container(
                                                margin: EdgeInsets.only(
                                                    top: 40 * pixel),
                                                child: Icon(
                                                  size: 20 * pixel,
                                                  Icons.pets_outlined,
                                                  color: Colors.purpleAccent,
                                                ));
                                          } else if (key['iconIndex'] == 2) {
                                            return Container(
                                                margin: EdgeInsets.only(
                                                    top: 40 * pixel),
                                                child: Icon(
                                                  size: 20 * pixel,
                                                  Icons.rice_bowl_outlined,
                                                  color: Colors.teal,
                                                ));
                                          } else if (key['iconIndex'] == 3) {
                                            return Container(
                                                margin: EdgeInsets.only(
                                                    top: 40 * pixel),
                                                child: Icon(
                                                  size: 20 * pixel,
                                                  Icons.water_drop_outlined,
                                                  color: Colors.redAccent,
                                                ));
                                          }
                                        });
                                  }
                                },
                                dowBuilder: (context, day) {
                                  if (day.weekday == DateTime.saturday ||
                                      day.weekday == DateTime.sunday) {
                                    final text = DateFormat.E('ko').format(day);
                                    return Center(
                                      child: Text(
                                        text,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    );
                                  }
                                },
                              ),
                              onFormatChanged: (format) {
                                if (_calendarFormat != format) {
                                  // Call `setState()` when updating calendar format
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                }
                              },
                              onPageChanged: (focusedDay) {
                                // No need to call `setState()` here
                                _focusedDay = focusedDay;
                              },
                            ),
                          ])));

              // 600보다 작으면 스크롤 적용

              return SingleChildScrollView(
                  physics: isScrollable ? null : NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: content,
                  ));
            })));
  }
}
