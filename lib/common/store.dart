import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class GStorage {
  static late final Box<int> setting;
  static late final Box<int> like;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    await Hive.initFlutter('$path/hive');
    setting = await Hive.openBox('setting');
    like = await Hive.openBox('like');
  }

  static Future<void> close() async {
    setting.compact();
    setting.close();
    like.compact();
    like.close();
  }

  static List<int> getLikes() {
    List<int> list = [0, 0];
    list[0] = like.get("writerid") ?? 0;
    list[1] = like.get("kindid") ?? 0;
    return list;
  }
}
