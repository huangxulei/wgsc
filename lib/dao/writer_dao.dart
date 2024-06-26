import 'package:gsc/utils.dart';

import '../bean/writer.dart';
import '../sql_helper.dart';

class WriterDao {
  //获取所有作者信息
  static Future<List<Writer>> fetchWriters() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> maps =
        await db.query('Writer', orderBy: 'writerid');
    return List.generate(maps.length, (i) => Writer.fromMap(maps[i]));
  }

  static Future<List<Writer>> getWritersByDynastyid(int dynastyid) async {
    final db = await SQLHelper.db();
    String sql = "select * from writer where 1=1 ";
    if (dynastyid != 0) {
      sql += "and dynastyid = ${dynastyid}";
    }
    print(sql);
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => Writer.fromMap(maps[i]));
  }

  // List<int>   writersNum  [11,22,]

  static Future<List<int>> dynastyAndNum() async {
    final db = await SQLHelper.db();
    String sql = "select count(*) as num from Writer group by dynastyid";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => maps[i]["num"]);
  }

  static Future<int> getDyidByWrid(int writerid) async {
    final db = await SQLHelper.db();
    String sql = "select dynastyid from Writer where writerid=$writerid";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return maps[0]["dynastyid"];
  }
}
