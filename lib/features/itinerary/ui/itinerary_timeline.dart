import 'package:flutter/material.dart';
import '../models/itinerary.dart';

class ItineraryTimeline extends StatefulWidget {
  final ItineraryDay dayModel;
  final void Function(int day) onAddEvent;
  final IconData Function(String activity) getEventIcon;

  const ItineraryTimeline({
    super.key,
    required this.dayModel,
    required this.onAddEvent,
    required this.getEventIcon,
  });

  @override
  State<ItineraryTimeline> createState() => _ItineraryTimelineState();
}

class _ItineraryTimelineState extends State<ItineraryTimeline> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              // Infinite scroll: always allow more events to be added
              return false;
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.dayModel.events.length,
              itemBuilder: (context, idx) {
                final event = widget.dayModel.events[idx];
                final isLast = idx == widget.dayModel.events.length - 1;
                final icon = widget.getEventIcon(event.activity);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 64,
                          alignment: Alignment.topCenter,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              event.time,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 32,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(icon, color: Colors.blue, size: 24),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 32,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showDialog<Map<String, String>>(
                            context: context,
                            builder: (context) {
                              final timeController = TextEditingController(
                                text: event.time,
                              );
                              final activityController = TextEditingController(
                                text: event.activity,
                              );
                              return AlertDialog(
                                title: const Text('Edit Event'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: timeController,
                                      decoration: const InputDecoration(
                                        labelText: 'Time',
                                      ),
                                    ),
                                    TextField(
                                      controller: activityController,
                                      decoration: const InputDecoration(
                                        labelText: 'Activity',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop({
                                        'time': timeController.text,
                                        'activity': activityController.text,
                                      });
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              event.time = result['time'] ?? event.time;
                              event.activity =
                                  result['activity'] ?? event.activity;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.activity,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      setState(() {
                                        widget.dayModel.events.removeAt(idx);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              // Optionally add subtitle or duration here
                            ],
                          ),
                        ),
                      ),
                    ),
                    Checkbox(
                      value: event.checked,
                      onChanged: (val) {
                        setState(() {
                          event.checked = val ?? false;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
            onPressed: () => widget.onAddEvent(widget.dayModel.day),
          ),
        ),
      ],
    );
  }
}
