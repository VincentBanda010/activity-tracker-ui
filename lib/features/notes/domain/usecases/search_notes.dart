// lib/features/notes/domain/usecases/search_notes.dart

import '../entities/note.dart';

class SearchNotes {
  final List<Note> allNotes;

  SearchNotes(this.allNotes);

  List<Note> call(String query) {
    if (query.isEmpty) {
      return allNotes; // Return all notes if no query is provided
    }

    return allNotes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
