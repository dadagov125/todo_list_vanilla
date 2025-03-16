import 'dart:io';

import 'package:todo_list/core/core.dart';

abstract class FileService {
  Future<File?> pickFile(FileSource source);
}
