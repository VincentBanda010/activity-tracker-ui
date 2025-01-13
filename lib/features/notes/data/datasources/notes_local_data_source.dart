// lib/features/notes/data/datasources/notes_local_data_source.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note_model.dart';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  static const String _databaseName = "notes.db";
  static const int _databaseVersion = 1;
  static const String table = 'notes';

  static final NotesLocalDataSourceImpl _instance =
  NotesLocalDataSourceImpl._internal();

  factory NotesLocalDataSourceImpl() {
    return _instance;
  }

  NotesLocalDataSourceImpl._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<void> addNote(NoteModel note) async {
    final db = await database;
    await db.insert(
      table,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return NoteModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final db = await database;
    await db.update(
      table,
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
