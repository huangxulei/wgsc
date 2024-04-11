import 'package:gsc/bean/poetry.dart';

import '../sql_helper.dart';

class PoetryDao {
  //获取某作者下面所有作品
  static Future<List<Poetry>> getPoetrysByWriterid(int writerid) async {
    final db = await SQLHelper.db();
    String sql = "select * from poetry where writerid = $writerid";
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return List.generate(maps.length, (i) => Poetry.fromMap(maps[i]));
  }
}
