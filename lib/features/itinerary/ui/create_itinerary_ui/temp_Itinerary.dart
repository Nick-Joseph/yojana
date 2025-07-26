import 'package:yojana/features/itinerary/models/itinerary.dart';

class TempItinerary {
  String? title;
  String? destination;
  List<String?> travelers;
  DateTime? startDate;
  DateTime? endDate;
  List<ItineraryDay?> days;

  TempItinerary({
    this.title,
    this.destination,
    this.travelers = const [],
    this.startDate,
    this.endDate,
    this.days = const [],
  });
}
