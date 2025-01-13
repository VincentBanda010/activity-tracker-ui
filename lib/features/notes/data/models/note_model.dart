// lib/features/notes/data/models/note_model.dart

import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required String id,
    required String title,
    required String content,
    required DateTime date,
  }) : super(id: id, title: title, content: content, date: date);

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
