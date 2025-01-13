// lib/features/notes/presentation/pages/notes_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late NotesProvider notesProvider;

  @override
  void initState() {
    super.initState();
    notesProvider = Provider.of<NotesProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notesProvider.fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notes',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<NotesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.notes.isEmpty) {
            return Center(child: Text('No notes available.'));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchNotes,
            child: ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index];
                return NoteCard(note: note);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(
            Icons.add,
            color: Colors.white,
        ),
      ),
    );
  }
}
