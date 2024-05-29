import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';

class Db_Helper {
  static final Db_Helper _instance = Db_Helper._internal();
  factory Db_Helper() => _instance;
  static Database? _database;

  Db_Helper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        username TEXT,
        contact_number TEXT,
        email_address TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('users');
    return results.map((map) => User.fromMap(map)).toList();
  }
}
