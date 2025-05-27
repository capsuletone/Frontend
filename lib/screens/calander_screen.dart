import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../component/calander_color_mark.dart';
import '../component/highlight_text_component.dart';
import '../provider/date_provider.dart';
import '../provider/user_data_provider.dart';

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
  final bool _isLoading = false;
  late final ValueNotifier<List> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = context.read<EventsProvider>();
      final diseaseList = context.read<UserDiseaseProvider>().diseaseData;

      DateTime stripTime(DateTime date) =>
          DateTime(date.year, date.month, date.day);

      eventProvider.clearEvents(); // 이벤트 초기화
      for (var disease in diseaseList) {
        for (var med in disease.medicines!) {
          if (med.date != '') {
            int cycle = med.totalDays;
            String medicineName = med.medicineName;
            DateTime startDate = stripTime(DateTime.parse(med.date));

            eventProvider.setEvents(startDate, medicineName, cycle);
          }
        }
      }

      // 이벤트를 다시 가져와서 초기화
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });

    _selectedEvents = ValueNotifier([]);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  List _getEventsForDay(DateTime day) {
    String dayT = DateFormat('yy/MM/dd').format(day);
    Map<String, dynamic> events = context.read<EventsProvider>().getEvents();
    return events[dayT] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    final eventProvider = Provider.of<EventsProvider>(context, listen: false);
    final diseaseList = Provider.of<UserDiseaseProvider>(context).diseaseData;

    DateTime stripTime(DateTime date) =>
        DateTime(date.year, date.month, date.day);

    eventProvider.clearEvents(); // <-- 이 함수가 eventProvider에 있어야 함
    for (var disease in diseaseList) {
      for (var med in disease.medicines!) {
        if (med.date != '') {
          int cycle = med.totalDays;
          String medicineName = med.medicineName;
          DateTime startDate = stripTime(DateTime.parse(med.date));

          eventProvider.setEvents(
              startDate, medicineName, cycle); // iconIndex는 임의로 0
        }
        print("현재 사용자 ${diseaseList.length}");
      }
    }

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
        },
        child: Scaffold(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: kIsWeb ? 24 * pixel : 54 * pixel),
                            highlightText(pixel, context, "달력"),
                            SizedBox(height: 10 * pixel),
                            TableCalendar(
                              headerStyle: HeaderStyle(
                                titleTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20 * pixel,
                                  fontWeight: FontWeight.bold,
                                ),
                                titleCentered: true,
                                formatButtonVisible: false,
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 30 * pixel,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 30 * pixel,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green[600]!,
                                      Colors.green[300]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(7 * pixel),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8 * pixel,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                headerMargin:
                                    EdgeInsets.only(bottom: 10 * pixel),
                              ),

                              locale: 'ko-KR',
                              rowHeight: 65 * pixel, // ✅ 수직 간격 키우기
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              onDaySelected: _onDaySelected,
                              eventLoader: _getEventsForDay,

                              daysOfWeekStyle: DaysOfWeekStyle(
                                // ✅ 요일 스타일 명시
                                weekdayStyle: TextStyle(
                                  fontSize: 13 * pixel,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                weekendStyle: TextStyle(
                                  fontSize: 13 * pixel,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),

                              calendarStyle: CalendarStyle(
                                defaultTextStyle: TextStyle(
                                  fontSize: 15 * pixel,
                                  height: 1.2,
                                ),
                                outsideTextStyle: TextStyle(
                                  fontSize: 14 * pixel,
                                  color: Colors.grey, // ✔ 회색 등으로 지정
                                ),
                                selectedTextStyle: TextStyle(
                                  // ✅ 선택된 날짜 텍스트 크기 크게
                                  fontSize: 18 * pixel,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                todayTextStyle: TextStyle(
                                  fontSize: 15 * pixel,
                                  color: Colors.black,
                                ),
                                weekendTextStyle: TextStyle(
                                  fontSize: 15 * pixel,
                                  color: Colors.redAccent,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Colors.green[500],
                                  shape: BoxShape.circle,
                                ),
                              ),

                              calendarBuilders: CalendarBuilders(
                                dowBuilder: (context, day) {
                                  final text = DateFormat.E('ko').format(day);
                                  final isWeekend =
                                      day.weekday == DateTime.saturday ||
                                          day.weekday == DateTime.sunday;

                                  return Center(
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: 13 * pixel,
                                        fontWeight: FontWeight.w600,
                                        color: isWeekend
                                            ? Colors.red
                                            : Colors.grey[800],
                                      ),
                                    ),
                                  );
                                },
                                markerBuilder: (context, day, events) {
                                  if (events.isNotEmpty) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        events.length > 4 ? 4 : events.length,
                                        (index) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            width: events.length > 3
                                                ? 4 * pixel
                                                : 8 * pixel,
                                            height: events.length > 3
                                                ? 4 * pixel
                                                : 8 * pixel,
                                            decoration: BoxDecoration(
                                              color: getColorByIndex(index),
                                              shape: BoxShape.circle,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return null;
                                },
                              ),

                              onFormatChanged: (format) {
                                if (_calendarFormat != format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                }
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                            ),
                            SizedBox(
                                height: 300 * pixel, // 고정 높이 설정
                                child: ValueListenableBuilder<List>(
                                    valueListenable:
                                        _selectedEvents, // 데이터의 변화를 듣고 반영
                                    builder: (context, value, _) {
                                      return ListView.builder(
                                          itemCount: value.length,
                                          itemBuilder: (context, index) {
                                            Map eventIconIndex = value[index];
                                            return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 6 *
                                                        pixel, // 아이템 양 옆 여백 설정
                                                    vertical: 6.0 *
                                                        pixel), // 아이템 위 아래 여백 설정
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 12.0 * pixel,
                                                      vertical: 6.0 * pixel),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 8,
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ListTile(
                                                    leading: Icon(
                                                        FontAwesomeIcons.pills,
                                                        color: getColorByIndex(
                                                            eventIconIndex[
                                                                'iconIndex'])),
                                                    title: Text(
                                                      '${eventIconIndex['contents']}',
                                                      style: TextStyle(
                                                          fontSize: 15 * pixel,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    onLongPress: () {
                                                      setState(() {
                                                        context
                                                            .read<
                                                                EventsProvider>()
                                                            .deleteEvents(
                                                                _selectedDay,
                                                                0);
                                                      });
                                                    },
                                                  ),
                                                ));
                                          });
                                    }))
                          ])));

              return SingleChildScrollView(
                  physics: isScrollable
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: content,
                  ));
            })));
  }
}
