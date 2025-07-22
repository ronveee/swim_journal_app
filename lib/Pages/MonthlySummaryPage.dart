import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'JournalPage.dart';
import 'MilestonesPage.dart';
import 'SwimJournalApp.dart';
import 'SwimEntry.dart';

class MonthlySummaryPage extends StatefulWidget {
  const MonthlySummaryPage({super.key});

  @override
  State<MonthlySummaryPage> createState() => _MonthlySummaryPageState();
}

class _MonthlySummaryPageState extends State<MonthlySummaryPage> {
  final SwimEntryManager _entryManager = SwimEntryManager();

  @override
  Widget build(BuildContext context) {
    final allEntries = _entryManager.entries;
    final DateTime now = DateTime.now();

    final thisMonthEntries = allEntries.where((entry) {
      try {
        final parsedDate = DateFormat('MMM dd, yyyy').parse(entry.date);
        return parsedDate.month == now.month && parsedDate.year == now.year;
      } catch (_) {
        return false;
      }
    }).toList();

    final totalSwimsThisMonth = thisMonthEntries.length;
    final totalSwimsAll = allEntries.length;

    final Set<String> allLocations = {};
    final Map<String, int> placeFrequency = {};
    int totalPhotosUploaded = 0;

    for (var entry in allEntries) {
      allLocations.add(entry.place);
      if (entry.image != null) {
        totalPhotosUploaded++;
      }
    }

    for (var entry in thisMonthEntries) {
      placeFrequency[entry.place] = (placeFrequency[entry.place] ?? 0) + 1;
    }

    String favoritePool = 'N/A';
    if (placeFrequency.isNotEmpty) {
      favoritePool = placeFrequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text('Monthly Summary'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryCard(
              icon: Icons.pool_rounded,
              title: "Total Swims",
              value: "$totalSwimsThisMonth",
              subtitle: "swim${totalSwimsThisMonth == 1 ? '' : 's'} this month",
              gradientColors: const [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
            ),
            const SizedBox(height: 24),
            _summaryCard(
              icon: Icons.place,
              title: "Favorite Pool",
              value: favoritePool,
              subtitle: "Most visited location this month",
              gradientColors: const [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              iconColor: Colors.teal,
              textColor: Colors.black87,
            ),
            const SizedBox(height: 24),
            Text(
              "All-Time Stats",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statColumn(Icons.pool, "Swims", "$totalSwimsAll"),
                  _statColumn(Icons.place, "Locations", "${allLocations.length}"),
                  _statColumn(Icons.photo_library, "Photos", "$totalPhotosUploaded"),
                ],
              ),
            ),


          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SwimJournalHome()),
                    (route) => false,
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const JournalPage()),
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MilestonesPage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Badges'),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required List<Color> gradientColors,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, size: 32, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statColumn(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}


