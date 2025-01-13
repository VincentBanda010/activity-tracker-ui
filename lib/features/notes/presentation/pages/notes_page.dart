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
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'All notes',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.green),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: NotesSearchDelegate(notesProvider),
                    );
                  },
                ),
                Icon(Icons.more_vert, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<NotesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            if (provider.notes.isEmpty) {
              return Center(
                child: Text(
                  'No notes available.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  provider.notes.length == 1
                      ? '1 note'
                      : '${provider.notes.length} notes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.notes.length,
                    itemBuilder: (context, index) {
                      final note = provider.notes[index];
                      return NoteCard(note: note);
                    },
                  ),
                ),
              ],
            );
          },
        ),
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
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class NotesSearchDelegate extends SearchDelegate {
  final NotesProvider notesProvider;

  NotesSearchDelegate(this.notesProvider);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    notesProvider.searchNotes(query);
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        if (provider.notes.isEmpty) {
          return Center(child: Text('No notes found.'));
        }
        return ListView.builder(
          itemCount: provider.notes.length,
          itemBuilder: (context, index) {
            final note = provider.notes[index];
            return NoteCard(note: note);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    notesProvider.searchNotes(query);
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.notes.length,
          itemBuilder: (context, index) {
            final note = provider.notes[index];
            return ListTile(
              title: Text(note.title),
              onTap: () {
                query = note.title;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
