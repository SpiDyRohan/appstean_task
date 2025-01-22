import 'package:appstean_test/database/db_constant.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDBHelper {
  // make this a singleton class
  MyDBHelper._privateConstructor();

  static final MyDBHelper instance = MyDBHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? db;

  Future<Database> database() async {
    if (db != null) return db!;
    db = await initDb();
    return db!;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDb() async {
    String path = join(await getDatabasesPath(), DBConstants.databaseName);
    return await openDatabase(path, version: DBConstants.databaseVersion,
        onCreate: (db, version) {
      db.execute('''
          CREATE TABLE ${DBConstants.table} (
            ${DBConstants.columnId} INTEGER PRIMARY KEY,
            ${DBConstants.columnName} TEXT NOT NULL,
            ${DBConstants.password} TEXT NOT NULL
          )
          ''');
    });
  }

  Future<int> saveUser(Map<String, dynamic> user) async {
    final dbClient = await database();
    int res = await dbClient.insert(DBConstants.table, user);
    debugPrint("save-user-called-->$res");
    return res;
  }

  Future<bool> checkExistingUser(name) async {
    final dbClient = await database();
    final List<Map<String, dynamic>> list = await dbClient.query(
      DBConstants.table,
      where: 'userName = ?',
      whereArgs: [name],
    );
    debugPrint("list----->$list");
    return list.isNotEmpty;
  }

  Future<bool> checkUserAndPassword(name, password) async {
    final dbClient = await database();
    final List<Map<String, dynamic>> list = await dbClient.query(
      DBConstants.table,
      where: 'userName = ? AND password = ?',
      whereArgs: [name, password],
    );
    debugPrint("list----->$list");
    return list.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUser() async {
    final dbClient = await database();
    final List<Map<String, Object?>> queryResult =
        await dbClient.query(DBConstants.table);
    return queryResult;
  }
}
