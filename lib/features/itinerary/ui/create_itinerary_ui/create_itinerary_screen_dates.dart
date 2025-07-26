import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:yojana/features/itinerary/bloc/itinerary_bloc.dart';
import 'package:yojana/features/itinerary/models/itinerary.dart'
    as itinerary_model;
import 'package:yojana/features/itinerary/ui/create_itinerary_ui/temp_Itinerary.dart';

class CreateItineraryScreenDates extends StatefulWidget {
  final itinerary_model.Itinerary? itinerary;
  final TempItinerary? tempItinerary;
  const CreateItineraryScreenDates({
    super.key,
    this.itinerary,
    this.tempItinerary,
  });

  @override
  State<CreateItineraryScreenDates> createState() =>
      _CreateItineraryScreenDatesState();
}

class _CreateItineraryScreenDatesState
    extends State<CreateItineraryScreenDates> {
  DateTime? _startDate;
  DateTime? _endDate;

  void _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_startDate ?? now)
        : (_endDate ?? (_startDate ?? now));
    final firstDate = isStart ? now : (_startDate ?? now);
    await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (_) => Container(
        constraints: const BoxConstraints(minHeight: 250, maxHeight: 250),
        color: Colors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initial,
          minimumDate: firstDate,
          onDateTimeChanged: (date) {
            setState(() {
              if (isStart) {
                _startDate = date;
                if (_endDate != null && _endDate!.isBefore(date)) {
                  _endDate = null;
                }
              } else {
                _endDate = date;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tempItinerary = widget.tempItinerary;
    return Scaffold(
      appBar: AppBar(title: Text('Whens your trip!')),
      body: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStart: true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _startDate != null
                      ? DateFormat('MMM d, yyyy').format(_startDate!)
                      : 'Start Date',
                  style: TextStyle(
                    color: _startDate != null ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStart: false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _endDate != null
                      ? DateFormat('MMM d, yyyy').format(_endDate!)
                      : 'End Date',
                  style: TextStyle(
                    color: _endDate != null ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
