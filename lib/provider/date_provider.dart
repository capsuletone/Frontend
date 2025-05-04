import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsProvider extends ChangeNotifier {
  Map<String, dynamic> events = {};

  loadEvents(Map<String, dynamic> a) {
    events.addAll(a);
  }

  removeEvents() {
    events.clear();
  }

  getEvents() {
    return events;
  }

  void setEvents(DateTime startDay, String contents, int cycle) {
    for (int i = 0; i < cycle - 1; i++) {
      DateTime currentDay = startDay.add(Duration(days: i));
      String dayData = DateFormat('yy/MM/dd').format(currentDay);

      Map<String, dynamic> eventsContents = {
        "iconIndex": 0, // 필요시 다르게 처리 가능
        "contents": contents,
      };

      if (events.containsKey(dayData)) {
        List eventList = events[dayData]!;

        // 같은 contents가 이미 있는지 체크
        bool alreadyExists =
            eventList.any((event) => event['contents'] == contents);

        if (!alreadyExists && eventList.length < 7) {
          eventList.add(eventsContents);
        }
      } else {
        events[dayData] = [eventsContents];
      }
    }

    notifyListeners();
  }

  deleteEvents(selectedDay, index) {
    String dayData = DateFormat('yy/MM/dd').format(selectedDay);
    List eventsList = events[dayData]!;
    eventsList.removeAt(index);
  }
}
