// lib/features/notes/domain/usecases/delete_note.dart

import '../repositories/notes_repository.dart';

class DeleteNote {
  final NotesRepository repository;

  DeleteNote(this.repository);

  Future<void> call(String id) async {
    return repository.deleteNote(id);
  }
}
