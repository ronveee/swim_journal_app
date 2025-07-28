import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AddSwimEntryPage.dart';
import 'JournalPage.dart';
import 'SwimJournalApp.dart';
import 'MonthlySummaryPage.dart';
import 'SwimEntry.dart';

class MilestonesPage extends StatefulWidget {
  const MilestonesPage({super.key});

  @override
  State<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends State<MilestonesPage> {
  final SwimEntryManager _entryManager = SwimEntryManager();

  @override
  Widget build(BuildContext context) {
    final allEntries = _entryManager.entries;
    final now = DateTime.now();

    // Entries this month
    final thisMonthEntries = allEntries.where((entry) {
      try {
        final parsedDate = DateFormat('MMM dd, yyyy').parse(entry.date);
        return parsedDate.month == now.month && parsedDate.year == now.year;
      } catch (_) {
        return false;
      }
    }).toList();

    final allLocations = allEntries.map((e) => e.place).toSet();
    final monthlyLocations = thisMonthEntries.map((e) => e.place).toSet();
    final photosUploaded = allEntries.where((e) => e.image != null).length;

    // All-time achievements
    final bool has10Entries = allEntries.length >= 10;
    final bool has25Entries = allEntries.length >= 25;
    final bool has50Entries = allEntries.length >= 50;
    final bool hasUploadedPhotos = photosUploaded >= 5;
    final bool has3Locations = allLocations.length >= 3;
    final bool has5Locations = allLocations.length >= 5;

    final List<bool> trophiesChecks = [
      has10Entries,
      has25Entries,
      has50Entries,
      hasUploadedPhotos,
      has3Locations,
      has5Locations,
    ];

    final int totalTrophies = trophiesChecks.where((b) => b).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text("Milestones & Trophies"),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryCard(
                icon: Icons.emoji_events,
                label: "Total Achievements",
                value: "$totalTrophies",
                subtitle: "Trophies collected",
                gradientColors: const [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
              ),
              const SizedBox(height: 24),
              const Text(
                "Your Achievements",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              _trophieTile(
                label: "Logged 10 Entries",
                achieved: has10Entries,
                description: "${allEntries.length}/10 entries",
              ),
              _trophieTile(
                label: "Logged 25 Entries",
                achieved: has25Entries,
                description: "${allEntries.length}/25 entries",
              ),
              _trophieTile(
                label: "Logged 50 Entries",
                achieved: has50Entries,
                description: "${allEntries.length}/50 entries",
              ),
              _trophieTile(
                label: "Uploaded 5+ Photos",
                achieved: hasUploadedPhotos,
                description: "$photosUploaded/5 photos",
              ),
              _trophieTile(
                label: "Swam in 3 Locations",
                achieved: has3Locations,
                description: "${allLocations.length}/3 locations",
              ),
              _trophieTile(
                label: "Swam in 5 Locations",
                achieved: has5Locations,
                description: "${allLocations.length}/5 locations",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MonthlySummaryPage()),
              );
              break;
            case 3:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Trophies'),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required List<Color> gradientColors,
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
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _trophieTile({
    required String label,
    required bool achieved,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achieved ? const Color(0xFFE0F7FA) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achieved ? Colors.blue : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.emoji_events : Icons.lock_outline,
            color: achieved ? Colors.amber[800] : Colors.grey,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: achieved ? Colors.blue : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: achieved ? Colors.blueAccent : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
