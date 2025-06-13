part of 'itinerary_bloc.dart';

abstract class ItineraryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadItineraries extends ItineraryEvent {
  final String userId;
  LoadItineraries(this.userId);
  @override
  List<Object?> get props => [userId];
}

class SaveItinerary extends ItineraryEvent {
  final Itinerary itinerary;
  final String userId;
  SaveItinerary(this.itinerary, this.userId);
  @override
  List<Object?> get props => [itinerary, userId];
}
