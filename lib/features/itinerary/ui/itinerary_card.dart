import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yojana/features/itinerary/models/itinerary.dart';

class ItineraryCard extends StatelessWidget {
  final Itinerary itinerary;
  const ItineraryCard({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final friendsCount = itinerary.travelers.length;
    final tripDays =
        itinerary.endDate.difference(itinerary.startDate).inDays + 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          itinerary.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Destination: ${itinerary.destination}'),
                const SizedBox(width: 16),
                Text('Days: $tripDays'),
              ],
            ),
            Row(
              children: [
                Text(
                  '${dateFormat.format(itinerary.startDate)} - ${dateFormat.format(itinerary.endDate)}',
                ),
                const SizedBox(width: 16),
                Text('Friends: $friendsCount'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push('/itinerary', extra: itinerary);
        },
      ),
    );
  }
}
