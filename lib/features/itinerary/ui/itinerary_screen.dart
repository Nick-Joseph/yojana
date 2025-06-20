// NOTE: This file uses only standard Flutter properties (width, height, minWidth, minHeight, etc.).
// If your linter complains, update your analysis_options.yaml to allow these properties for Flutter compatibility.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../bloc/itinerary_bloc.dart';
import '../models/itinerary.dart' as itinerary_model;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:yojana/features/itinerary/ui/itinerary_timeline.dart';
import 'package:yojana/features/itinerary/ui/add_event_dialog.dart';

class ItineraryScreen extends StatefulWidget {
  final itinerary_model.Itinerary? itinerary;
  const ItineraryScreen({super.key, this.itinerary});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _travelerController = TextEditingController();
  final List<String> _travelers = [];
  DateTime? _startDate;
  DateTime? _endDate;
  List<itinerary_model.ItineraryDay> _days = [];
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.itinerary != null) {
      _titleController.text = widget.itinerary!.title;
      _destinationController.text = widget.itinerary!.destination;
      _travelers.addAll(widget.itinerary!.travelers);
      _startDate = widget.itinerary!.startDate;
      _endDate = widget.itinerary!.endDate;
      _days = widget.itinerary!.days;
    }
  }

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

  void _addTraveler() {
    final email = _travelerController.text.trim();
    if (email.isNotEmpty && !_travelers.contains(email)) {
      setState(() {
        _travelers.add(email);
        _travelerController.clear();
      });
    }
  }

  void _saveItinerary() {
    if (_titleController.text.isEmpty ||
        _destinationController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }
    // Always include 'userId' in travelers for demo/testing
    if (!_travelers.contains('userId')) {
      _travelers.add('userId');
    }
    final itinerary = itinerary_model.Itinerary(
      id: widget.itinerary?.id ?? UniqueKey().toString(),
      title: _titleController.text,
      destination: _destinationController.text,
      travelers: _travelers,
      startDate: _startDate!,
      endDate: _endDate!,
      days: _days,
    );
    context.read<ItineraryBloc>().add(SaveItinerary(itinerary, 'userId'));
    context.go('/home');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Itinerary saved!')));
  }

  List<Widget> _buildDayEventsSection() {
    if (_startDate == null || _endDate == null) return [];
    final daysCount = _endDate!.difference(_startDate!).inDays + 1;
    if (_selectedDayIndex >= daysCount) return [];
    final dayModel = _days.firstWhere(
      (d) => d.day == _selectedDayIndex + 1,
      orElse: () =>
          itinerary_model.ItineraryDay(day: _selectedDayIndex + 1, events: []),
    );
    return [
      ItineraryTimeline(
        dayModel: dayModel,
        onAddEvent: _showAddEventDialog,
        getEventIcon: _getEventIcon,
      ),
    ];
  }

  IconData _getEventIcon(String activity) {
    final lower = activity.toLowerCase();
    if (lower.contains('bus')) return Icons.directions_bus;
    if (lower.contains('flight') || lower.contains('plane'))
      return Icons.flight;
    if (lower.contains('walk')) return Icons.directions_walk;
    if (lower.contains('hotel') || lower.contains('stay')) return Icons.hotel;
    if (lower.contains('food') ||
        lower.contains('lunch') ||
        lower.contains('dinner'))
      return Icons.restaurant;
    if (lower.contains('car') || lower.contains('drive'))
      return Icons.directions_car;
    if (lower.contains('train')) return Icons.train;
    if (lower.contains('boat') || lower.contains('ferry'))
      return Icons.directions_boat;
    if (lower.contains('museum')) return Icons.museum;
    if (lower.contains('park')) return Icons.park;
    if (lower.contains('shopping')) return Icons.shopping_bag;
    return Icons.location_on;
  }

  void _showAddEventDialog(int day) {
    final timeController = TextEditingController();
    final activityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AddEventDialog(
          timeController: timeController,
          activityController: activityController,
          onAdd: () {
            setState(() {
              final event = itinerary_model.ItineraryEvent(
                time: timeController.text,
                activity: activityController.text,
              );
              final idx = _days.indexWhere((d) => d.day == day);
              if (idx != -1) {
                _days[idx].events.add(event);
              } else {
                _days.add(
                  itinerary_model.ItineraryDay(day: day, events: [event]),
                );
              }
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create/Edit Itinerary'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveItinerary),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Itinerary Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _travelerController,
                      decoration: const InputDecoration(
                        labelText: 'Add traveler by email',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTraveler,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: _travelers
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        onDeleted: () => setState(() => _travelers.remove(t)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
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
                            color: _startDate != null
                                ? Colors.black
                                : Colors.grey,
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
                            color: _endDate != null
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_startDate != null && _endDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Itinerary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _startDate != null && _endDate != null
                            ? _endDate!.difference(_startDate!).inDays + 1
                            : 0,
                        itemBuilder: (context, index) {
                          final day = _startDate!.add(Duration(days: index));
                          final isSelected = _selectedDayIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDayIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected
                                    ? Border.all(color: Colors.blue, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('d').format(day),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(DateFormat('E').format(day)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildDayEventsSection(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
