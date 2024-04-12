import 'package:gsc/bean/poetry.dart';

import '../bean/info.dart';
import '../bean/poem.dart';
import '../sql_helper.dart';

class PoetryDao {
  //获取某作者下面所有作品
  static Future<List<Poetry>> getPoetrysByWriterid(int writerid) async {
    final db = await SQLHelper.db();
    String sql = "select * from poetry where writerid = $writerid";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => Poetry.fromMap(maps[i]));
  }

  static Future<List<Poetry>> getAllPoetrys() async {
    final db = await SQLHelper.db();
    String sql = "select * from poetry order by poetryid desc";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => Poetry.fromMap(maps[i]));
  }

  static Future<Poetry> getPoetrysByid(int pid) async {
    final db = await SQLHelper.db();
    String sql = "select * from poetry where poetryid=${pid}";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    print(maps);
    return Poetry.fromMap(maps[0]);
  }

  static Future<List<Poem>> getAllPoem() async {
    final db = await SQLHelper.db();
    String sql =
        "select p.kindid,p.typeid,p.poetryid,w.dynastyid,w.writerid,w.writername,p.title,p.content from Poetry p join Writer w on p.writerid = w.writerid order by p.poetryid asc";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => Poem.fromMap(maps[i]));
  }

  static Future<List<Info>> findInfoByPid(int pid) async {
    final db = await SQLHelper.db();
    String sql = "select * from Info where cateid=1 and fid = $pid";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => Info.fromMap(maps[i]));
  }
}
