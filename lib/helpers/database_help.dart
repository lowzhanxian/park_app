import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/vehicle.dart';

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
      version: 2, // Increment version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        username TEXT,
        contact_number TEXT,
        email_address TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS vehicle_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        vehicle_plateNum TEXT NOT NULL,
        vehicle_name TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS vehicle_details(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          vehicle_plateNum TEXT NOT NULL,
          vehicle_name TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    await databaseFactory.deleteDatabase(path);
  }

  // User methods
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

  // Vehicle methods

  //vehicle insert database
  Future<int> insertVehicleDetail(Vehicle vehicle) async {
    Database db = await database;
    return await db.insert('vehicle_details', vehicle.toMap());
  }

  //vehicle get vehicle database which follow user id
  Future<List<Vehicle>> getVehicleDetails(int userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicle_details',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Vehicle.fromMap(maps[i]);
    });
  }


  //update vehicle details follow userid
  Future<int> updateVehicleDetail(Vehicle vehicle) async {
    Database db = await database;
    return await db.update(
      'vehicle_details',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }


  //delete vehicle details
  Future<int> deleteVehicleDetail(int id) async {
    Database db = await database;
    return await db.delete(
      'vehicle_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
