import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddEventDialog extends StatefulWidget {
  final TextEditingController timeController;
  final TextEditingController activityController;
  final VoidCallback onAdd;

  const AddEventDialog({
    super.key,
    required this.timeController,
    required this.activityController,
    required this.onAdd,
  });

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  TimeOfDay? _selectedTime;

  void _showTimePicker() async {
    final now = TimeOfDay.now();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          use24hFormat: false,
          initialDateTime: DateTime(
              2020,
              1,
              1,
              _selectedTime?.hour ?? now.hour,
              _selectedTime?.minute ?? now.minute),
          onDateTimeChanged: (dateTime) {
            setState(() {
              _selectedTime = TimeOfDay(
                  hour: dateTime.hour, minute: dateTime.minute);
              final hour = _selectedTime!.hourOfPeriod == 0
                  ? 12
                  : _selectedTime!.hourOfPeriod;
              final minute = _selectedTime!.minute.toString().padLeft(2, '0');
              final period = _selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
              widget.timeController.text = '$hour:$minute $period';
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _showTimePicker,
            child: AbsorbPointer(
              child: TextField(
                controller: widget.timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 6:00 AM)',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
              ),
            ),
          ),
          TextField(
            controller: widget.activityController,
            decoration: const InputDecoration(labelText: 'Activity'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: widget.onAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
