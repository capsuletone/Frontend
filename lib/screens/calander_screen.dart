import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../component/calander_color_mark.dart';
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
              final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
              final isTablet = screenWidth >= 768; // 아이패드 여부 판단

              final content = Container(
                  padding: EdgeInsets.symmetric(horizontal: 33 * pixel),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40 * pixel),
                        TableCalendar(
                          headerStyle: HeaderStyle(
                            headerMargin: EdgeInsets.only(bottom: 10 * pixel),
                            titleTextStyle: TextStyle(
                                color: Colors.white, fontSize: 20 * pixel),
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 28 * pixel,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 28 * pixel,
                            ),
                          ),
                          rowHeight: 80 * pixel,
                          locale: 'ko-KR',
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: _onDaySelected,
                          eventLoader: _getEventsForDay,
                          calendarStyle: const CalendarStyle(
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
                                List eventList = events;

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      List.generate(eventList.length, (index) {
                                    Map event = eventList[
                                        index]; // { iconIndex, contents }

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                      child: Icon(
                                        Icons.circle,
                                        size: 6 * pixel, // 점 크기
                                        color:
                                            getColorByIndex(event['iconIndex']),
                                      ),
                                    );
                                  }),
                                );
                              }
                              return null;
                            },
                            dowBuilder: (context, day) {
                              // 요일 텍스트의 크기와 위치를 조정
                              final text = DateFormat.E('ko').format(day);
                              return Center(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: day.weekday == DateTime.saturday ||
                                            day.weekday == DateTime.sunday
                                        ? Colors.red
                                        : Colors.black,
                                    fontSize: 12 * pixel, // 텍스트 크기 조정
                                    fontWeight: FontWeight.bold, // 볼드 스타일
                                  ),
                                ),
                              );
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
                        SizedBox(
                            height: 300 * pixel,
                            child: ValueListenableBuilder<List>(
                                valueListenable: _selectedEvents,
                                builder: (context, value, _) {
                                  return ListView.builder(
                                      itemCount: value.length,
                                      itemBuilder: (context, index) {
                                        Map eventIconIndex = value[index];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ListTile(
                                            onLongPress: () {
                                              setState(() {
                                                context
                                                    .read<EventsProvider>()
                                                    .deleteEvents(
                                                        _selectedDay, 0);
                                              });
                                            },
                                            title: Text(
                                                '${eventIconIndex['contents']}'),
                                          ),
                                        );
                                      });
                                }))
                      ]));

              // 600보다 작으면 스크롤 적용

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
