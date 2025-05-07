import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsProvider extends ChangeNotifier {
  Map<String, dynamic> events = {};

  loadEvents(Map<String, dynamic> a) {
    events.addAll(a);
  }

  void clearEvents() {
    events.clear();
    notifyListeners();
  }

  removeEvents() {
    events.clear();
  }

  getEvents() {
    return events;
  }

  void setEvents(DateTime startDay, String contents, int cycle) {
    for (int i = 0; i < cycle; i++) {
      DateTime currentDay =
          startDay.add(Duration(days: i)); // 시작일 기준으로 cycle만큼 반복
      String dayData = DateFormat('yy/MM/dd').format(currentDay);

      Map<String, dynamic> eventsContents = {
        "iconIndex": 0, // 필요시 다르게 처리 가능
        "contents": contents,
      };

      if (events.containsKey(dayData)) {
        List eventList = events[dayData]!;

        // 이미 같은 내용이 있는지 체크
        bool alreadyExists =
            eventList.any((event) => event['contents'] == contents);

        if (!alreadyExists && eventList.length < 7) {
          eventList.add(eventsContents);
        }
      } else {
        events[dayData] = [eventsContents];
      }
    }

    notifyListeners(); // 이벤트 리스트가 변경된 후 알림
  }

  deleteEvents(selectedDay, index) {
    String dayData = DateFormat('yy/MM/dd').format(selectedDay);
    List eventsList = events[dayData]!;
    eventsList.removeAt(index);
  }
}
