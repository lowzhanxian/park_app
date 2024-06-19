import 'dart:async';
import 'package:park_app/models/parking_details.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/vehicle.dart';
import '../models/violation.dart';
import '../models/compound.dart';

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
      version: 6,
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

    await db.execute('''
      CREATE TABLE IF NOT EXISTS feedback_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        contact_info TEXT,
        feedback_type TEXT,
        feedback_details TEXT NOT NULL,
        full_name TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');


    await db.execute('''
      CREATE TABLE IF NOT EXISTS compounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS paid_compounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS wallet_balance(
        user_id INTEGER PRIMARY KEY,
        balance REAL NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS reload_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS parking_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        vehicle_plateNum TEXT NOT NULL,
        vehicle_type TEXT NOT NULL,
        parking_location TEXT NOT NULL,
        road_name TEXT NOT NULL,
        duration REAL NOT NULL,
        total_price REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
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
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS reload_history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS feedback_details(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          location TEXT,
          contact_info TEXT,
          feedback_type TEXT,
          feedback_details TEXT NOT NULL,
          full_name TEXT,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS parking_details(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          vehicle_plateNum TEXT NOT NULL,
          vehicle_type TEXT NOT NULL,
          parking_location TEXT NOT NULL,
          road_name TEXT NOT NULL,
          duration REAL NOT NULL,
          total_price REAL NOT NULL,
          date TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS compounds(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          description TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS paid_compounds(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          description TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT
        )
      ''');
    }
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    await databaseFactory.deleteDatabase(path);
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

  Future<User?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
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

  Future<void> updateUserPassword(int userId, String newPassword) async {
    Database db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  Future<void> updateUser(User user) async {
    Database db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }


  // Vehicle methods
  Future<int> insertVehicleDetail(Vehicle vehicle) async {
    Database db = await database;
    return await db.insert('vehicle_details', vehicle.toMap());
  }

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

  Future<int> updateVehicleDetail(Vehicle vehicle) async {
    Database db = await database;
    return await db.update(
      'vehicle_details',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<int> deleteVehicleDetail(int id) async {
    Database db = await database;
    return await db.delete(
      'vehicle_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Feedback methods
  Future<int> insertFeedbackDetails(UserFeedback feedback) async {
    final db = await database;
    return await db.insert('feedback_details', feedback.toMap());
  }

  Future<List<UserFeedback>> getFeedbackDetails(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'feedback_details',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return UserFeedback.fromMap(maps[i]);
    });
  }

  Future<int> updateFeedbackDetails(UserFeedback feedback) async {
    final db = await database;
    return await db.update(
      'feedback_details',
      feedback.toMap(),
      where: 'id = ?',
      whereArgs: [feedback.id],
    );
  }

  Future<int> deleteFeedbackDetails(int id) async {
    final db = await database;
    return await db.delete(
      'feedback_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  // Parking Details methods
  Future<int> insertParkingDetails(ParkingDetails parkingDetails) async {
    Database db = await database;
    var map = parkingDetails.toMap();
    map.remove('id'); // Ensure the id is not included in the map
    return await db.insert('parking_details', map);
  }

  Future<ParkingDetails?> getLatestParkingDetails(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'parking_details',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (results.isNotEmpty) {
      return ParkingDetails.fromMap(results.first);
    }
    return null;
  }

  Future<List<ParkingDetails>> getParkingHistory(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'parking_details',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return ParkingDetails.fromMap(maps[i]);
    });
  }

  Future<int> deleteParkingDetail(int id) async {
    final db = await database;
    return await db.delete(
      'parking_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  // Wallet balance methods
  Future<void> updateWalletBalance(int userId, double balance) async {
    final db = await database;
    await db.insert(
      'wallet_balance',
      {'user_id': userId, 'balance': balance},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<double?> getWalletBalance(int userId) async {
    final db = await database;
    final result = await db.query(
      'wallet_balance',
      columns: ['balance'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first['balance'] as double?;
    }
    return null;
  }

  // Reload history methods
  Future<void> insertReloadHistory(int userId, double amount) async {
    final db = await database;
    await db.insert('reload_history', {
      'user_id': userId,
      'amount': amount,
      'date': DateTime.now().toIso8601String()
    });
  }

  Future<List<Map<String, dynamic>>> getReloadHistory(int userId) async {
    final db = await database;
    return await db.query('reload_history',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC');
  }

  Future<void> deleteReloadHistory(int userId) async {
    final db = await database;
    await db.delete(
      'reload_history',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Compound methods
  Future<void> insertCompound(Compound compound) async {
    final db = await database;
    await db.insert('compounds', compound.toMap());
  }

  Future<void> insertPaidCompound(Compound compound) async {
    final db = await database;
    await db.insert('paid_compounds', compound.toMap());
  }

  Future<List<Compound>> getCompounds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('compounds');
    return List.generate(maps.length, (i) {
      return Compound.fromMap(maps[i]);
    });
  }

  Future<List<Compound>> getPaidCompounds(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'paid_compounds',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Compound.fromMap(maps[i]);
    });
  }

  Future<void> deletePaidCompound(int id) async {
    final db = await database;
    await db.delete(
      'paid_compounds',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
