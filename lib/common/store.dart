import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class GStorage {
  static late final Box<dynamic> setting;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    print(path);
    await Hive.initFlutter('$path/hive');
    setting = await Hive.openBox('setting');
  }

  static Future<void> close() async {
    setting.compact();
    setting.close();
  }
}
