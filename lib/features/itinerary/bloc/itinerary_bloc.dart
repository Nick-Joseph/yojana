import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/itinerary.dart';
import '../data/itinerary_repository.dart';

part 'itinerary_event.dart';
part 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final ItineraryRepository repository;
  ItineraryBloc({required this.repository}) : super(ItineraryInitial()) {
    on<LoadItineraries>((event, emit) async {
      emit(ItineraryLoading());
      try {
        final itineraries = await repository.fetchItineraries(event.userId);
        emit(ItineraryLoaded(itineraries));
      } catch (e) {
        emit(ItineraryError(e.toString()));
      }
    });
    on<SaveItinerary>((event, emit) async {
      try {
        await repository.saveItinerary(event.itinerary);
        add(LoadItineraries(event.userId));
      } catch (e) {
        emit(ItineraryError(e.toString()));
      }
    });
  }
}
