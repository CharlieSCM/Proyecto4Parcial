// import 'dart:async';
// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static final nameDB = 'Markers';
//   static final versionDB = 1;

//   static Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     return _database = await _initDatabase();
//   }

//   Future<Database?> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String pathDB = join(documentsDirectory.path, nameDB);

//     return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
//   }

//   //se debe acomodar la base de datos
//   FutureOr<void> _createTables(Database db, int version) {
//     String query = '''
//       CREATE TABLE markers(
//         id INTEGER PRIMARY KEY,
//         latitude TEXT,
//         longitude TEXT,
//         title TEXT
//       )
//     ''';
//     db.execute(query);
//   }

//   Future<int> INSERT(String tblName, Map<String, dynamic> markerData) async {
//     var conexion = await database;
//     return conexion!.insert(tblName, markerData);
//   }

//   Future<void> insertMarker(Map<String, dynamic> markerData) async {
//     final db = await database;
//     await db!.insert('markers', markerData,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> getMarkers() async {
//     final db = await database;
//     return db!.query('markers');
//   }

//   Future<void> deleteMarker(int id) async {
//     final db = await database;
//     await db!.delete('markers', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> updateMarker(Map<String, dynamic> updatedMarker) async {
//     final db = await database;
//     await db!.update('markers', updatedMarker,
//         where: 'id = ?', whereArgs: [updatedMarker['id']]);
//   }
// }


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

// import 'dart:async';
// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static final nameDB = 'Markers';
//   static final versionDB = 1;

//   static Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     return _database = await _initDatabase();
//   }

//   Future<Database?> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String pathDB = join(documentsDirectory.path, nameDB);

//     return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
//   }

//   FutureOr<void> _createTables(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE markers(
//         id INTEGER PRIMARY KEY,
//         latitude TEXT,
//         longitude TEXT,
//         title TEXT,
//         imagePath TEXT
//       )
//     ''');
//   }

//   Future<int> insertMarker(Map<String, dynamic> markerData) async {
//     var connection = await database;
//     return connection!.insert('markers', markerData);
//   }

//   Future<List<Map<String, dynamic>>> getMarkers() async {
//     var connection = await database;
//     return connection!.query('markers');
//   }

//   Future<void> deleteMarker(int id) async {
//     var connection = await database;
//     await connection!.delete('markers', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> updateMarker(Map<String, dynamic> updatedMarker) async {
//     var connection = await database;
//     await connection!.update('markers', updatedMarker,
//         where: 'id = ?', whereArgs: [updatedMarker['id']]);
//   }
// }


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

    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

  //se debe acomodar la base de datos
  FutureOr<void> _createTables(Database db, int version) {
    String query = '''
      CREATE TABLE markers(
        id INTEGER PRIMARY KEY,
        latitude TEXT,
        longitude TEXT,
        title TEXT
      )
    ''';
    db.execute(query);
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> markerData) async {
    var conexion = await database;
    return conexion!.insert(tblName, markerData);
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
