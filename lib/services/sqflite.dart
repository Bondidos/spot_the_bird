import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dateBaseName = 'MyDatabase.db';
  static const _databaseVersion = 1;
  static const table = "my_table";
  static const columnId = "id";
  static const columnTitle = "birdName";
  static const columnDescription = "birdDescription";
  static const columnUrl = "url";
  static const longitude = "longitude";
  static const latitude = "latitude";

  // singleTone
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // only one app-wide reference to database
  static Database? _database;
  Future<Database?> get database async {
    if(database != null){
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    // join 2 strings path + _databaseName
    String path = join(documentDirectory.path, _dateBaseName);
    return await openDatabase(path, version: _databaseVersion,onCreate: _onCreate);
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute(
      """
      CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnUrl TEXT NOT NULL,
      $longitude REAL NOT NULL,
      $latitude REAL NOT NULL )
      """
    );
  }

  Future<int> insert(Map<String, dynamic> row) async{
    Database? db = await instance.database;
    return db!.insert(table, row);
  }

  Future<List<Map<String,dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return db!.query(table);
  }
  
  Future<int> deleteRow(int id) async {
    Database? db = await instance.database;
    return db!.delete(table,where: "$columnId = ?", whereArgs: [id]);
  }
}