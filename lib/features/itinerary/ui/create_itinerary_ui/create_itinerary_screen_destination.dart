import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:yojana/features/itinerary/ui/create_itinerary_ui/temp_Itinerary.dart';

class CreateItineraryScreenDestination extends StatelessWidget {
  final TempItinerary? tempItinerary;
  final _destinationController = TextEditingController();

  CreateItineraryScreenDestination({super.key, this.tempItinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Where are we going?')),
      body: Center(
        child: SizedBox(
          width: 350,
          height: 60,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            textInputAction: TextInputAction.next,
            onSubmitted: (value) {
              tempItinerary?.destination = value;
              context.push(
                '/createitinerary/createitineraryfriends',
                extra: tempItinerary,
              );
            },
          ),
        ),
      ),
    );
  }
}
