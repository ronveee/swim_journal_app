import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'SwimEntry.dart';

class AddSwimEntryPage extends StatefulWidget {
  const AddSwimEntryPage({super.key});

  @override
  State<AddSwimEntryPage> createState() => _AddSwimEntryPageState();
}

class _AddSwimEntryPageState extends State<AddSwimEntryPage> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController =
        TextEditingController(text: DateFormat('MMM dd, yyyy').format(now));
    _timeController =
        TextEditingController(text: DateFormat('hh:mm a').format(now));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4DA0FF), Color(0xFF76C5FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Add Swim Entry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Date"),
                    _input(_dateController, readOnly: true),

                    _label("Time"),
                    _input(_timeController, readOnly: true),

                    _label("Place"),
                    _input(_placeController),

                    _label("Notes"),
                    _input(_notesController, maxLines: 2),

                    const SizedBox(height: 10),
                    _photoButton(),

                    if (_selectedImage != null)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: double.infinity,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                    _saveButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _input(TextEditingController controller,
      {bool readOnly = false, int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _photoButton() => GestureDetector(
    onTap: _pickImage,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            "Add Photo",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )
        ],
      ),
    ),
  );

  Widget _saveButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        final newEntry = SwimEntry(
          date: _dateController.text,
          time: _timeController.text,
          place: _placeController.text,
          notes: _notesController.text,
          image: _selectedImage,
        );

        // This will return the entry to the JournalPage
        Navigator.pop(context, newEntry);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4DA0FF),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Save",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
