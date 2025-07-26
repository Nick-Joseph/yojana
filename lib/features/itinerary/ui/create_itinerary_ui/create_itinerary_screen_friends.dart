import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:yojana/features/itinerary/ui/create_itinerary_ui/temp_Itinerary.dart';

class CreateItineraryScreenFriends extends StatelessWidget {
  final TempItinerary? tempItinerary;

  const CreateItineraryScreenFriends({super.key, this.tempItinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Whos going?')),
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
              final temp = tempItinerary ?? TempItinerary();
              temp.travelers = value.split(',').map((e) => e.trim()).toList();
              context.push(
                '/createitinerary/createitinerarydates',
                extra: temp,
              );
            },
          ),
        ),
      ),
    );
  }
}
