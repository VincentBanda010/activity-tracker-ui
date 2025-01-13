// lib/features/notes/domain/repositories/notes_repository.dart

import '../entities/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}
