// lib/features/notes/domain/usecases/update_note.dart

import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class UpdateNote {
  final NotesRepository repository;

  UpdateNote(this.repository);

  Future<void> call(Note note) async {
    return repository.updateNote(note);
  }
}
