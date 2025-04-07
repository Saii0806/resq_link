// database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:resq_link/models/emergency_contact.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If database doesn't exist, create it
    _database = await _initDB('emergency_contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDb = join(dbPath, path);
    return await openDatabase(pathToDb, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        district TEXT
      )
    ''');
  }

  // Method to insert a contact into the database
  Future<void> insertContact(EmergencyContact contact) async {
    final db = await instance.database;

    // Insert the contact into the 'contacts' table
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to fetch all contacts from the database
  Future<List<EmergencyContact>> getAllContacts() async {
    final db = await instance.database;
    final result = await db.query('contacts');
    
    return result.isNotEmpty
        ? result.map((e) => EmergencyContact.fromMap(e)).toList()
        : [];
  }

  // Method to clear all contacts from the database
  Future<void> clearContacts() async {
    final db = await instance.database;
    await db.delete('contacts');
  }
}
