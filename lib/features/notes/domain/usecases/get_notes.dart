// lib/features/notes/domain/usecases/get_notes.dart

import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNotes {
  final NotesRepository repository;

  GetNotes(this.repository);

  Future<List<Note>> call() async {
    return repository.getNotes();
  }
}
