import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/itinerary.dart';

class ItineraryRepository {
  final _collection = FirebaseFirestore.instance.collection('itineraries');

  Future<void> saveItinerary(Itinerary itinerary) async {
    await _collection.doc(itinerary.id).set(itinerary.toMap());
  }

  Future<List<Itinerary>> fetchItineraries(String userId) async {
    final query = await _collection
        .where('travelers', arrayContains: userId)
        .get();
    return query.docs.map((doc) => Itinerary.fromMap(doc.data())).toList();
  }

  Future<Itinerary?> getItinerary(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return Itinerary.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> deleteItinerary(Itinerary itinerary) async {
    final doc = await _collection.doc(itinerary.id).get();
    if (doc.exists) {
      return _collection.doc(itinerary.id).delete();
    }
  }
}
