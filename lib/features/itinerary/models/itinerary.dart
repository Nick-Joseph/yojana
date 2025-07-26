class Itinerary {
  final String id;
  final String title;
  final String destination;
  final List<String> travelers;
  final DateTime startDate;
  final DateTime endDate;
  final List<ItineraryDay> days;

  Itinerary({
    required this.id,
    required this.title,
    required this.destination,
    required this.travelers,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'destination': destination,
    'travelers': travelers,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'days': days.map((d) => d.toMap()).toList(),
  };

  factory Itinerary.fromMap(Map<String, dynamic> map) => Itinerary(
    id: map['id'],
    title: map['title'],
    destination: map['destination'],
    travelers: List<String>.from(map['travelers'] ?? []),
    startDate: DateTime.parse(map['startDate']),
    endDate: DateTime.parse(map['endDate']),
    days:
        (map['days'] as List<dynamic>?)
            ?.map((d) => ItineraryDay.fromMap(d))
            .toList() ??
        [],
  );
}

class ItineraryDay {
  final int day;
  final List<ItineraryEvent> events;
  ItineraryDay({required this.day, required this.events});
  Map<String, dynamic> toMap() => {
    'day': day,
    'events': events.map((e) => e.toMap()).toList(),
  };
  factory ItineraryDay.fromMap(Map<String, dynamic> map) => ItineraryDay(
    day: map['day'],
    events:
        (map['events'] as List<dynamic>?)
            ?.map((e) => ItineraryEvent.fromMap(e))
            .toList() ??
        [],
  );
}

class ItineraryEvent {
  String time;
  String activity;
  bool checked;
  ItineraryEvent({
    required this.time,
    required this.activity,
    this.checked = false,
  });
  Map<String, dynamic> toMap() => {
    'time': time,
    'activity': activity,
    'checked': checked,
  };
  factory ItineraryEvent.fromMap(Map<String, dynamic> map) => ItineraryEvent(
    time: map['time'],
    activity: map['activity'],
    checked: map['checked'] ?? false,
  );
}
