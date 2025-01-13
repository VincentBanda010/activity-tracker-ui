// lib/features/notes/presentation/providers/notes_provider.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/update_note.dart';

class NotesProvider with ChangeNotifier {
  final GetNotes getNotesUseCase;
  final AddNote addNoteUseCase;
  final UpdateNote updateNoteUseCase;
  final DeleteNote deleteNoteUseCase;

  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  NotesProvider({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  });

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await getNotesUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load notes';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final note = Note(
      id: Uuid().v4(),
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await addNoteUseCase(note);
    await fetchNotes();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final note = _notes.firstWhere((note) => note.id == id);
    final updatedNote = Note(
      id: id,
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await updateNoteUseCase(updatedNote);
    await fetchNotes();
  }

  Future<void> deleteNote(String id) async {
    await deleteNoteUseCase(id);
    await fetchNotes();
  }
}
