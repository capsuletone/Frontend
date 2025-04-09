import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../provider/date_provider.dart';

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
  late final ValueNotifier<List> _selectedEvents;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
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
    eventProvider.setEvents(DateTime(2025, 4, 1), '약1', 0);
    eventProvider.setEvents(DateTime(2025, 4, 23), '약1', 1);

    // 4월 5일 이벤트 추가
    eventProvider.setEvents(DateTime(2025, 4, 5), '약2', 2);

    // 4월 10일 이벤트 추가
    eventProvider.setEvents(DateTime(2025, 4, 10), '약3', 3);

    // 4월 12일 이벤트 추가
    eventProvider.setEvents(DateTime(2025, 4, 12), '약4', 4);
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
                                    color: Colors.white, fontSize: 20),
                                decoration: BoxDecoration(
                                    color: Colors.teal,
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
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: _focusedDay,
                              calendarFormat: _calendarFormat,
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: _onDaySelected,
                              eventLoader: _getEventsForDay,
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
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          Map key = iconEvents[index];

                                          return Container(
                                              margin: EdgeInsets.only(
                                                  top: 40 * pixel),
                                              child: Icon(
                                                size: 14 * pixel,
                                                Icons.circle,
                                                color: Colors.green[500],
                                              ));
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
                            Container(
                                height: 300 * pixel,
                                child: ValueListenableBuilder<List>(
                                    valueListenable: _selectedEvents,
                                    builder: (context, value, _) {
                                      return ListView.builder(
                                          itemCount: value.length < 2
                                              ? value.length
                                              : 1,
                                          itemBuilder: (context, index) {
                                            Map event_icon_index = value[index];
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
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
                                                    '${event_icon_index['contents']}'),
                                              ),
                                            );
                                          });
                                    }))
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
