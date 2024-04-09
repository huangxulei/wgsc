import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<int> getFileSize(String filePath) async {
  // 获取文件路径
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filePath');

  try {
    // 获取文件大小
    final fileStat = await file.stat();
    return fileStat.size;
  } catch (e) {
    // 处理错误，例如文件不存在
    print('Error getting file size: $e');
    return -1;
  }
}
