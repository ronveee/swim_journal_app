import 'package:flutter/material.dart';
import 'dart:io';

import 'AddSwimEntryPage.dart';
import 'EditSwimEntryPage.dart';
import 'SwimEntry.dart';

class SwimEntryDetailPage extends StatelessWidget {
  final SwimEntry entry;
  final Function(SwimEntry)? onEdit;
  final VoidCallback onDelete;

  const SwimEntryDetailPage({
    super.key,
    required this.entry,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Arrow
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Spacer (optional: for better spacing between icons)
                  const Spacer(),

                  // Edit and Delete Buttons
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final updatedEntry = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditSwimEntryPage(entry: entry),
                            ),
                          );

                          if (updatedEntry != null && updatedEntry is SwimEntry) {
                            onEdit?.call(updatedEntry); // update the entry in the list
                            Navigator.pop(context); // go back to journal after edit
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.tealAccent, size: 26),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirm Deletion"),
                              content: const Text("Are you sure you want to delete this entry?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(), // Cancel
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2F96FD),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close modal
                                    onDelete(); // Delete the entry via callback
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.tealAccent, size: 26),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            // Image
            if (entry.image != null)
              Container(
                margin: const EdgeInsets.all(16),
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: FileImage(entry.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Date, Time & Place
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.date,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.time,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.place,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  const Text(
                    "Notes",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      entry.notes,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}