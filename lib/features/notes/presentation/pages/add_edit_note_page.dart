// lib/features/notes/presentation/pages/add_edit_note_page.dart

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
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle ?? '';
    _content = widget.initialContent ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;
    final notesProvider = Provider.of<NotesProvider>(context, listen: false); // Provider usage

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEditing ? 'Edit Note' : 'Add Note',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title TextFormField
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!.trim();
                },
              ),
              SizedBox(height: 8), // Small margin after Title

              // Content TextFormField
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5, // Set a reasonable number of lines
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Content is required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!.trim();
                },
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate();
                  if (isValid != null && isValid) {
                    _formKey.currentState?.save();
                    if (isEditing) {
                      await notesProvider.updateNote(
                        widget.noteId!,
                        _title,
                        _content,
                      );
                    } else {
                      await notesProvider.addNote(_title, _content);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(isEditing ? 'Update' : 'Add'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
