part of 'itinerary_bloc.dart';

abstract class ItineraryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItineraryInitial extends ItineraryState {}

class ItineraryLoading extends ItineraryState {}

class ItineraryLoaded extends ItineraryState {
  final List<Itinerary> itineraries;
  ItineraryLoaded(this.itineraries);
  @override
  List<Object?> get props => [itineraries];
}

class ItineraryError extends ItineraryState {
  final String error;
  ItineraryError(this.error);
  @override
  List<Object?> get props => [error];
}
