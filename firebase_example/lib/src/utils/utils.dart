import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Utils {
  static Future<String> downLoadFile(String url, String fileName) async {
    final directory = await getApplicationCacheDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    await File(filePath).writeAsBytes(response.bodyBytes);

    return filePath;
  }
}
