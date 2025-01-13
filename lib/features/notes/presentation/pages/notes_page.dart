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
      backgroundColor: Colors.grey[100], // Match the light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'All notes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
            Row(
              children: [
                Icon(Icons.search, color: Colors.black),
                SizedBox(width: 16),
                Icon(Icons.more_vert, color: Colors.black),
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
                  '${provider.notes.length} notes',
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
        backgroundColor: Colors.yellow[700], // Matches the FAB in the image
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note, color: Colors.black),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box, color: Colors.black),
            label: 'To do',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}
