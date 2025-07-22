import 'dart:io';

class SwimEntry {
  final String date;
  final String time;
  final String place;
  final String notes;
  final File? image;

  SwimEntry({
    required this.date,
    required this.time,
    required this.place,
    required this.notes,
    this.image,
  });
}

class SwimEntryManager {
  static final SwimEntryManager _instance = SwimEntryManager._internal();
  factory SwimEntryManager() => _instance;
  SwimEntryManager._internal();

  List<SwimEntry> _entries = [];
  List<Function()> _listeners = [];

  List<SwimEntry> get entries => List.unmodifiable(_entries);



  void addEntry(SwimEntry entry) {
    _entries.insert(0, entry);
    _notifyListeners();
  }

  void updateEntry(int index, SwimEntry updatedEntry) {
    if (index >= 0 && index < _entries.length) {
      _entries[index] = updatedEntry;
      _notifyListeners();
    }
  }

  void deleteEntry(int index) {
    if (index >= 0 && index < _entries.length) {
      _entries.removeAt(index);
      _notifyListeners();
    }
  }

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
} 