import 'dart:io';

import 'package:flutter/foundation.dart';

class EtcFunction {
  static void outputProjectStructure(String path) async {
    // 아래 코드가 디버그 모드일 때만 실행되도록 변경
    if (kDebugMode) {
      var directory = Directory(path);
      var outputFile = File('output.txt');

      if (directory.existsSync()) {
        List<FileSystemEntity> entities = directory.listSync();
        var outputBuffer = StringBuffer();

        for (var entity in entities) {
          outputBuffer.writeln(entity.uri.pathSegments.last);
        }

        await outputFile.writeAsString(outputBuffer.toString());
        print('Output written to output.txt');
      } else {
        print('Directory does not exist.');
      }
    }
  }
}
// /Users/soon/IdeaProjects/nutripeek/lib
