// lib/features/notes/data/repositories/notes_repository_impl.dart

import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addNote(Note note) async {
    final noteModel = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      date: note.date,
    );
    await localDataSource.addNote(noteModel);
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }

  @override
  Future<List<Note>> getNotes() async {
    return await localDataSource.getNotes();
  }

  @override
  Future<void> updateNote(Note note) async {
    final noteModel = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      date: note.date,
    );
    await localDataSource.updateNote(noteModel);
  }
}
