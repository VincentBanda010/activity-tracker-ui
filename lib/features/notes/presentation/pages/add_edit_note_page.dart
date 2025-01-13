import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

class AddEditNotePage extends StatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  const AddEditNotePage({
    Key? key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late String _title;
  late String _content;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _contentHistory = [];
  int _historyIndex = 0;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle ?? '';
    _content = widget.initialContent ?? '';
    _titleController.text = _title;
    _contentController.text = _content;

    // Initialize content history
    _contentHistory.add(_content);
  }

  void _saveContentToHistory() {
    if (_historyIndex < _contentHistory.length - 1) {
      _contentHistory.removeRange(_historyIndex + 1, _contentHistory.length);
    }
    _contentHistory.add(_contentController.text);
    _historyIndex = _contentHistory.length - 1;
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _contentController.text = _contentHistory[_historyIndex];
      });
    }
  }

  void _redo() {
    if (_historyIndex < _contentHistory.length - 1) {
      setState(() {
        _historyIndex++;
        _contentController.text = _contentHistory[_historyIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          isEditing ? 'Edit Note' : 'Add Note',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.done, color: Colors.green),
            onPressed: () async {
              if (_titleController.text.trim().isEmpty ||
                  _contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Title and Content cannot be empty')),
                );
                return;
              }
              if (isEditing) {
                await notesProvider.updateNote(
                  widget.noteId!,
                  _titleController.text.trim(),
                  _contentController.text.trim(),
                );
              } else {
                await notesProvider.addNote(
                  _titleController.text.trim(),
                  _contentController.text.trim(),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            Divider(color: Colors.grey),
            // Content Input
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Start typing here...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 16),
                onChanged: (value) {
                  _saveContentToHistory();
                },
              ),
            ),
            // Undo and Redo Toolbar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.undo, color: Colors.black),
                  onPressed: _undo,
                ),
                IconButton(
                  icon: Icon(Icons.redo, color: Colors.black),
                  onPressed: _redo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
