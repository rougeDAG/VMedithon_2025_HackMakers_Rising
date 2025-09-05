import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:acudrop/domain/entities/app_user.dart';
import 'package:acudrop/domain/entities/dose.dart';

class CalendarScreen extends StatefulWidget {
  final List<Dose> doses;
  final AppUser appUser; // We need the user's schedule info

  const CalendarScreen({super.key, required this.doses, required this.appUser});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // State variables to manage the selected day and its doses
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Dose> _selectedDoses = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selected doses for the current day when the screen loads
    _selectedDoses = _getDosesForDay(_selectedDay);
  }

  // Helper function to get all doses for a specific day
  List<Dose> _getDosesForDay(DateTime day) {
    return widget.doses
        .where((dose) => isSameDay(dose.timestamp, day))
        .toList();
  }

  // Callback function for when a user taps on a day
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // We don't want to select future days
    if (selectedDay.isAfter(DateTime.now())) return;

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedDoses = _getDosesForDay(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adherence Calendar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.now()
                  .add(const Duration(days: 365)), // Show future dates
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              calendarFormat: CalendarFormat.month,
              // This function provides the list of doses for the event marker
              eventLoader: _getDosesForDay,
              // This is where we build the custom UI for each day (the heat map)
              calendarBuilders: CalendarBuilders(
                // Builder for the selected day
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade700, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('${day.day}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                  );
                },
                // Builder for today's date
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.teal.withAlpha(76),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text('${day.day}')),
                  );
                },
                // Builder for all other days in the calendar
                defaultBuilder: (context, day, focusedDay) {
                  // Don't color future days
                  if (day.isAfter(
                      DateTime.now().subtract(const Duration(days: 1)))) {
                    return null;
                  }

                  // Calculate adherence for this specific day
                  int dosesTaken = _getDosesForDay(day).length;
                  int dosesScheduled = widget.appUser.dosesPerDay;

                  Color dayColor = Colors.transparent;
                  if (dosesScheduled > 0) {
                    double adherence = dosesTaken / dosesScheduled;
                    if (adherence >= 1.0) {
                      dayColor = Colors
                          .green.shade400; // Strong color for perfect adherence
                    } else if (adherence > 0) {
                      dayColor =
                          Colors.green.shade200; // Lighter color for partial
                    } else {
                      dayColor = Colors.red.shade200; // Color for missed doses
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: dayColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle().copyWith(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          // This is the "bubble" that shows details for the selected day
          Expanded(
            child: _buildAdherenceBubble(),
          ),
        ],
      ),
    );
  }

  // A helper widget to build the information card for the selected day.
  Widget _buildAdherenceBubble() {
    int dosesScheduled = widget.appUser.dosesPerDay;
    int dosesTaken = _selectedDoses.length;
    String dayText = DateFormat.yMMMd().format(_selectedDay);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayText,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (dosesScheduled > 0) ...[
                    Text(
                      'Adherence: $dosesTaken / $dosesScheduled doses taken.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (dosesTaken < dosesScheduled) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${dosesScheduled - dosesTaken} dose(s) missed.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.red),
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        'Great job! You took all your doses.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.green[800]),
                      ),
                    ]
                  ] else ...[
                    Text(
                      'No doses were scheduled for this day.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
