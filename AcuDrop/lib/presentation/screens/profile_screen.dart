import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:acudrop/domain/entities/app_user.dart';
import 'package:acudrop/domain/repositories/user_repository.dart';
import 'package:acudrop/presentation/providers/auth_provider.dart';
import 'package:acudrop/presentation/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables for the new UI
  int? _dosesPerDay;
  List<String?> _scheduleTimes = [];
  bool _isInitialized = false;

  // Function to show a time picker and update a specific time slot.
  void _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Convert TimeOfDay to a DateTime to use DateFormat for consistent saving.
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        // Save in a universal, non-localized 24-hour format (e.g., "16:45").
        _scheduleTimes[index] = DateFormat('HH:mm').format(dt);
      });
    }
  }

  // Function to save the updated schedule to Firebase.
  void _saveSchedule() {
    final user = context.read<AuthProvider>().user;
    if (user != null && _dosesPerDay != null) {
      // Filter out any unset time slots before saving.
      final List<String> finalSchedule =
          _scheduleTimes.where((t) => t != null).cast<String>().toList();

      if (finalSchedule.length != _dosesPerDay) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Warning: Not all dose times are set.'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      context
          .read<ProfileProvider>()
          .updateUserSchedule(user.uid, _dosesPerDay!, finalSchedule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule saved!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  // This function updates the list of time slots when the user changes the number of doses.
  void _onDosesPerDayChanged(int? newValue) {
    if (newValue == null) return;
    setState(() {
      _dosesPerDay = newValue;
      List<String?> newSchedule = List.generate(newValue, (index) => null);
      for (int i = 0;
          i < _scheduleTimes.length && i < newSchedule.length;
          i++) {
        newSchedule[i] = _scheduleTimes[i];
      }
      _scheduleTimes = newSchedule;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    final userRepository = context.read<UserRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Schedule',
            onPressed: _saveSchedule,
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('User not found.'))
          : StreamBuilder<AppUser>(
              stream: userRepository.getUser(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final appUser = snapshot.data!;
                if (!_isInitialized) {
                  _dosesPerDay =
                      appUser.dosesPerDay > 0 ? appUser.dosesPerDay : null;
                  _scheduleTimes = List.generate(appUser.dosesPerDay, (index) {
                    return index < appUser.schedule.length
                        ? appUser.schedule[index]
                        : null;
                  });
                  _isInitialized = true;
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Email: ${appUser.email}'),
                      const SizedBox(height: 24),
                      Text('Medication Frequency',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _dosesPerDay,
                        hint: const Text('Select doses per day'),
                        items: List.generate(10, (i) => i + 1)
                            .map((int num) => DropdownMenuItem(
                                value: num, child: Text('$num time(s) a day')))
                            .toList(),
                        onChanged: _onDosesPerDayChanged,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 24),
                      if (_dosesPerDay != null && _dosesPerDay! > 0) ...[
                        Text('Set Medication Times',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _dosesPerDay!,
                            itemBuilder: (context, index) {
                              final time = _scheduleTimes[index];

                              // Logic to display the stored time in the user's local format.
                              String displayText;
                              if (time != null) {
                                try {
                                  // Parse the "HH:mm" string and convert to TimeOfDay.
                                  final parsedTime = TimeOfDay.fromDateTime(
                                      DateFormat('HH:mm').parse(time));
                                  // Format it for display using the device's locale settings.
                                  displayText = parsedTime.format(context);
                                } catch (e) {
                                  displayText = 'Invalid Time';
                                }
                              } else {
                                displayText = 'Tap to set time';
                              }

                              return Card(
                                child: ListTile(
                                  leading:
                                      CircleAvatar(child: Text('${index + 1}')),
                                  title: Text(displayText),
                                  trailing: const Icon(Icons.edit_calendar),
                                  onTap: () => _selectTime(context, index),
                                ),
                              );
                            },
                          ),
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
    );
  }
}
