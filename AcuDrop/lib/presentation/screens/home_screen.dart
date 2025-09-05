import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart'; // Import for isSameDay
import 'package:acudrop/domain/entities/app_user.dart';
import 'package:acudrop/domain/entities/dose.dart';
import 'package:acudrop/domain/repositories/user_repository.dart';
import 'package:acudrop/presentation/providers/auth_provider.dart';
import 'package:acudrop/presentation/providers/home_provider.dart';
import 'package:acudrop/presentation/screens/calendar_screen.dart';
import 'package:acudrop/presentation/screens/profile_screen.dart';
import 'package:acudrop/presentation/widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID from AuthProvider.
    final user = Provider.of<AuthProvider>(context).user;
    // Get the UserRepository to fetch data streams.
    final userRepository = Provider.of<UserRepository>(context);

    // If for some reason the user is null, show a loading indicator.
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AcuDrop Dashboard'),
        actions: [
          // Button to navigate to the Profile screen.
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          // Button to sign out.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      // Use a StreamBuilder to listen for real-time updates to the user's data.
      body: StreamBuilder<AppUser>(
        stream: userRepository.getUser(user.uid),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError || !userSnapshot.hasData) {
            return const Center(child: Text('Error loading user data.'));
          }
          final appUser = userSnapshot.data!;

          // Use another StreamBuilder for the list of doses.
          return StreamBuilder<List<Dose>>(
            stream: userRepository.getDoses(user.uid),
            builder: (context, doseSnapshot) {
              final doses = doseSnapshot.data ?? [];
              final latestDose = doses.isNotEmpty ? doses.first : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Welcome, ${appUser.email}',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 24),
                    // Display the main info cards.
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        InfoCard(
                          title: 'Bottle Level',
                          value: '${appUser.bottleLevel}%',
                          icon: Icons.opacity,
                          color: Colors.blue,
                        ),
                        InfoCard(
                          title: 'Redness Score',
                          value:
                              latestDose?.eyeRednessScore.toStringAsFixed(2) ??
                                  'N/A',
                          icon: Icons.remove_red_eye_outlined,
                          color: Colors.red,
                        ),
                        InfoCard(
                          title: 'Doses Today',
                          value:
                              '${_getDosesTodayCount(doses)} / ${appUser.dosesPerDay}',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        InfoCard(
                          title: 'Next Dose',
                          value: _getNextDoseTime(appUser.schedule, context),
                          icon: Icons.schedule,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Button to administer a dose.
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Administer Dose Now'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      // UPDATED: Now passes the context for showing SnackBars.
                      onPressed: () => context
                          .read<HomeProvider>()
                          .addDose(user.uid, context),
                    ),
                    const SizedBox(height: 16),
                    // Button to view the calendar.
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('View Adherence Calendar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        // Pass the full user and dose data to the calendar screen
                        MaterialPageRoute(
                            builder: (_) =>
                                CalendarScreen(doses: doses, appUser: appUser)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper function to count how many doses were taken today.
  // CORRECTED: Now uses the isSameDay utility for robust comparison.
  int _getDosesTodayCount(List<Dose> doses) {
    final now = DateTime.now();
    return doses.where((dose) => isSameDay(dose.timestamp, now)).length;
  }

  // Helper function to determine the next scheduled dose time.
  String _getNextDoseTime(List<String> schedule, BuildContext context) {
    if (schedule.isEmpty) return 'Not Set';

    final now = TimeOfDay.now();
    TimeOfDay? nextScheduleTime;

    try {
      // Parse the stored "HH:mm" strings and convert to TimeOfDay
      final sortedTimes = schedule
          .map((timeStr) =>
              TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(timeStr)))
          .toList()
        ..sort((a, b) {
          if (a.hour != b.hour) return a.hour.compareTo(b.hour);
          return a.minute.compareTo(b.minute);
        });

      // Find the first scheduled time that is after the current time.
      for (final time in sortedTimes) {
        if (time.hour > now.hour ||
            (time.hour == now.hour && time.minute > now.minute)) {
          nextScheduleTime = time;
          break;
        }
      }

      // If no time is found for today, the next dose is tomorrow at the first scheduled time.
      if (nextScheduleTime == null && sortedTimes.isNotEmpty) {
        nextScheduleTime = sortedTimes.first;
      }

      // Format the result for display in the user's local format
      return nextScheduleTime?.format(context) ?? 'Not Set';
    } catch (e) {
      // If parsing fails for any reason, return a safe value.
      debugPrint("Error parsing schedule time: $e");
      return "Check Sched.";
    }
  }
}
