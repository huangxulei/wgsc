import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SQLHelper {
  static Future<sql.Database> db() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'poem.db');
    return await sql.openDatabase(path);
  }

  static Future<List<Map<String, dynamic>>> getWriters() async {
    final db = await SQLHelper.db();
    return db.query('Writer', orderBy: 'writerid');
  }

  static Future<void> initialDatabase() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var databasesPath = await databaseFactory.getDatabasesPath();
    var path = join(databasesPath, "poem.db");
    var exists = await databaseFactory.databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load('assets/poem.db');
      // ByteData data = await rootBundle.load(join('assets','express.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
  }
}
