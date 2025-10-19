// TODimport 'dart:convert';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Add singleton instance wrapper for code that expects DBHelper.instance
  static final DBHelper instance = DBHelper._internal();
  DBHelper._internal();

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'cdip_connect.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE member(
            id TEXT PRIMARY KEY,
            data TEXT,
            updated_at INTEGER
          )
        ''');
      },
    );
  }

  // insert or replace a member record
  static Future<void> insertMember(String id, String data) async {
    final db = await database;
    await db.insert(
      'member',
      {
        'id': id,
        'data': data,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // convenience for inserting from a Map
  static Future<void> insertOrUpdateMemberMap(
      Map<String, dynamic> member) async {
    final id = (member['id'] ?? member['ID'] ?? '').toString();
    if (id.isEmpty) return;
    await insertMember(id, jsonEncode(member));
  }

  // instance convenience methods (call static implementations)
  Future<void> insertOrUpdateMember(Map<String, dynamic> member) async {
    await DBHelper.insertOrUpdateMemberMap(member);
  }

  Future<void> insertMemberRecord(String id, String data) async {
    await DBHelper.insertMember(id, data);
  }

  // get member by id
  static Future<Map<String, dynamic>?> getMember(String id) async {
    final db = await database;
    final res = await db.query('member', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  // get the latest stored member (if any)
  static Future<Map<String, dynamic>?> getLatestMember() async {
    final db = await database;
    final res = await db.query('member', orderBy: 'updated_at DESC', limit: 1);
    if (res.isNotEmpty) return res.first;
    return null;
  }

  // clear all members
  static Future<void> clearMembers() async {
    final db = await database;
    await db.delete('member');
  }
}
