import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SQLHelper {
  static Future<sql.Database> db() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'poem.db');
    print("数据库路径${path}");
    return await sql.openDatabase(path);
  }

  static Future<void> copyDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'poem.db');

    // 检查SQLite .db文件是否已复制到设备
    bool exists = await databaseExists(path);

    if (!exists) {
      // 如果SQLite .db文件不存在，则复制它
      try {
        // 从assets目录复制SQLite .db文件到设备上的合适位置
        ByteData data = await rootBundle.load('assets/database/poem.db');
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes);
      } catch (e) {
        print("数据复制错误: ${e}");
      }
    }
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

    print(path);
    var exists = await databaseFactory.databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load('assets/poem.db');
      print(join('assets', 'poem.db'));
      // ByteData data = await rootBundle.load(join('assets','express.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // // open the database
    // return await databaseFactory.openDatabase(path);
    // print(databasesPath);
  }
}
