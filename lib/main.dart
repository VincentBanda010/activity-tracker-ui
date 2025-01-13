// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/notes/data/datasources/notes_local_data_source.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/usecases/add_note.dart';
import 'features/notes/domain/usecases/delete_note.dart';
import 'features/notes/domain/usecases/get_notes.dart';
import 'features/notes/domain/usecases/update_note.dart';
import 'features/notes/presentation/pages/notes_page.dart';
import 'features/notes/presentation/providers/notes_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NotesRepositoryImpl notesRepository = NotesRepositoryImpl(
    localDataSource: NotesLocalDataSourceImpl(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
          create: (context) => NotesProvider(
            getNotesUseCase: GetNotes(notesRepository),
            addNoteUseCase: AddNote(notesRepository),
            updateNoteUseCase: UpdateNote(notesRepository),
            deleteNoteUseCase: DeleteNote(notesRepository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clean Notes App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: NotesPage(),
      ),
    );
  }
}
