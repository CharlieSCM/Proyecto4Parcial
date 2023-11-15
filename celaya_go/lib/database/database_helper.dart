import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final nameDB = 'Markers';
  static final versionDB = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String pathDB = join(documentsDirectory.path, nameDB);

    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: _createTables
    );
  }

  FutureOr<void> _createTables(Database db, int version)  {
    String query='''
      CREATE TABLE markers(
        id INTEGER PRIMARY KEY,
        latitude REAL,
        longitude REAL,
        title TEXT
      )
    ''';
    db.execute(query);
  }

  Future<void> insertMarker(Map<String, dynamic> markerData) async {
    final db = await database;
    await db!.insert('markers', markerData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getMarkers() async {
    final db = await database;
    return db!.query('markers');
  }

  Future<void> deleteMarker(int id) async {
    final db = await database;
    await db!.delete('markers', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateMarker(Map<String, dynamic> updatedMarker) async {
    final db = await database;
    await db!.update('markers', updatedMarker,
        where: 'id = ?', whereArgs: [updatedMarker['id']]);
  }
}


/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'markers_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE markers(id INTEGER PRIMARY KEY, latitude REAL, longitude REAL, title TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertMarker(Map<String, dynamic> markerData) async {
    final db = await database;
    await db.insert('markers', markerData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getMarkers() async {
    final db = await database;
    return db.query('markers');
  }
}*/