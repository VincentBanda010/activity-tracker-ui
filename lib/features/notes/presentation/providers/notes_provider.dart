import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/update_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/search_notes.dart';

class NotesProvider with ChangeNotifier {
  final GetNotes getNotesUseCase;
  final AddNote addNoteUseCase;
  final UpdateNote updateNoteUseCase;
  final DeleteNote deleteNoteUseCase;

  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = false;
  String? _errorMessage;

  NotesProvider({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  });

  // Getters
  List<Note> get notes => _filteredNotes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all notes
  Future<void> fetchNotes() async {
    _isLoading = true;
    _errorMessage = null; // Clear any previous errors
    notifyListeners();

    try {
      _allNotes = await getNotesUseCase();
      _filteredNotes = _allNotes;
    } catch (e) {
      _errorMessage = 'Failed to load notes';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search notes by query
  void searchNotes(String query) {
    final searchNotesUseCase = SearchNotes(_allNotes);
    _filteredNotes = searchNotesUseCase(query);
    notifyListeners();
  }

  // Add a new note
  Future<void> addNote(String title, String content) async {
    try {
      final newNote = Note(
        id: DateTime.now().toString(),
        title: title,
        content: content,
        date: DateTime.now(),
      );
      await addNoteUseCase(newNote);
      _allNotes.add(newNote);
      _filteredNotes = _allNotes; // Refresh filtered notes
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add note';
      notifyListeners();
    }
  }

  // Update an existing note
  Future<void> updateNote(String id, String title, String content) async {
    try {
      final updatedNote = Note(
        id: id,
        title: title,
        content: content,
        date: DateTime.now(),
      );
      await updateNoteUseCase(updatedNote);

      // Update the local list
      final index = _allNotes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _allNotes[index] = updatedNote;
      }
      _filteredNotes = _allNotes; // Refresh filtered notes
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update note';
      notifyListeners();
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    try {
      await deleteNoteUseCase(id);

      // Remove from the local list
      _allNotes.removeWhere((note) => note.id == id);
      _filteredNotes = _allNotes; // Refresh filtered notes
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete note';
      notifyListeners();
    }
  }
}
