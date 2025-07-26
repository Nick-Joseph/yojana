import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/temp_Itinerary.dart';

class CreateItineraryScreenTitle extends StatelessWidget {
  final TempItinerary? tempItinerary;

  const CreateItineraryScreenTitle({super.key, this.tempItinerary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Name your Itinerary!')),
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
              temp.title = value;
              context.push(
                '/createitinerary/createitinerarydestination',
                extra: temp,
              );
            },
          ),
        ),
      ),
    );
  }
}
