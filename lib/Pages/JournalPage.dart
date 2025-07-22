import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'AddSwimEntryPage.dart';
import 'SwimEntryDetailPage.dart';
import 'SwimJournalApp.dart';
import 'MilestonesPage.dart';
import 'MonthlySummaryPage.dart';
import 'SwimEntry.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<SwimEntry> filteredEntries = [];
  final SwimEntryManager _entryManager = SwimEntryManager();

  void _addEntry(SwimEntry entry) {
    _entryManager.addEntry(entry);
  }

  void _updateEntry(int index, SwimEntry updatedEntry) {
    _entryManager.updateEntry(index, updatedEntry);
  }

  void _deleteEntry(int index) {
    _entryManager.deleteEntry(index);
  }

  void _updateFilteredEntries() {
    setState(() {
      filteredEntries = _entryManager.entries;
    });
  }

  @override
  void initState() {
    super.initState();
    _entryManager.addListener(_updateFilteredEntries);
    filteredEntries = _entryManager.entries;
  }

  @override
  void dispose() {
    _entryManager.removeListener(_updateFilteredEntries);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Swim Journal',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Swims',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lato',

                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.search, color: Colors.blue, size: 24),
                              onPressed: () async {
                                final TextEditingController dateController = TextEditingController();
                                final TextEditingController placeController = TextEditingController();
                                final TextEditingController notesController = TextEditingController();

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (_) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                        left: 24,
                                        right: 24,
                                        top: 20,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Date Field with Picker
                                          TextField(
                                            controller: dateController,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              labelText: 'Date',
                                              prefixIcon: Icon(Icons.date_range, color: Colors.blue),
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (pickedDate != null) {
                                                String formatted = DateFormat('MMM dd, yyyy').format(pickedDate);
                                                dateController.text = formatted;
                                              }
                                            },
                                          ),

                                          const SizedBox(height: 10),

                                          // Place Field
                                          TextField(
                                            controller: placeController,
                                            decoration: const InputDecoration(
                                              labelText: 'Location',
                                              prefixIcon: Icon(Icons.place, color: Colors.blue),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // Notes Field
                                          TextField(
                                            controller: notesController,
                                            decoration: const InputDecoration(
                                              labelText: 'Notes',
                                              prefixIcon: Icon(Icons.note, color: Colors.blue),
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          ElevatedButton(
                                            onPressed: () {
                                              final dateQuery = dateController.text.toLowerCase();
                                              final placeQuery = placeController.text.toLowerCase();
                                              final notesQuery = notesController.text.toLowerCase();

                                              setState(() {
                                                filteredEntries = _entryManager.entries.where((entry) {
                                                  final matchDate = dateQuery.isEmpty || entry.date.toLowerCase() == dateQuery;
                                                  final matchPlace = placeQuery.isEmpty || entry.place.toLowerCase().contains(placeQuery);
                                                  final matchNotes = notesQuery.isEmpty || entry.notes.toLowerCase().contains(notesQuery);
                                                  return matchDate && matchPlace && matchNotes;
                                                }).toList();
                                              });

                                              Navigator.pop(context); // Close modal
                                            },
                                            child: const Text(
                                              'Search',
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),

                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.blue, size: 24),
                              onPressed: () {
                                setState(() {
                                  filteredEntries = _entryManager.entries; // Reset to show all entries
                                });
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) {
                    final entry = filteredEntries[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SwimEntryDetailPage(entry: entry,
                              onEdit: (updatedEntry) {
                                _updateEntry(index, updatedEntry);
                              },
                              onDelete: () {
                                _deleteEntry(index);
                                Navigator.pop(context); // Close detail page after delete
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.place,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Add Entry Button at Bottom
              Padding(
                padding: const EdgeInsets.only(right: 24, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddSwimEntryPage(),
                          ),
                        );
                        if (result is SwimEntry) {
                          _addEntry(result);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4DA0FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Add Entry",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ]
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // JournalPage index
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SwimJournalHome()),
                    (route) => false,
              );
              break;
            case 1: // Stay on Journal
              break;
            case 2: // Monthly Summary
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MonthlySummaryPage()),
              );
              break;
            case 3: // Milestones
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
}
