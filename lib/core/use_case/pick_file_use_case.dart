import 'dart:async';
import 'dart:io';

import 'package:todo_list/core/core.dart';

class PickFileUseCase extends UseCase<File?, FileSource> {
  PickFileUseCase({
    required FileService fileService,
  }) : _fileService = fileService;
  final FileService _fileService;

  @override
  FutureOr<File?> execute([FileSource? params]) {
    if (params == null) {
      ArgumentError.checkNotNull(params, 'FileSource');
    }
    return _fileService.pickFile(params!);
  }
}
