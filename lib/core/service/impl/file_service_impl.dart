import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:todo_list/core/core.dart';

class FileServiceImpl extends FileService {
  FileServiceImpl({required ImagePicker imagePicker})
      : _imagePicker = imagePicker;

  final ImagePicker _imagePicker;

  @override
  Future<File?> pickFile(FileSource source) async {
    final xFile = await _imagePicker.pickImage(source: _mapSource(source));
    if (xFile == null) {
      return null;
    }
    return File(xFile.path);
  }

  ImageSource _mapSource(FileSource source) => switch (source) {
        FileSource.gallery => ImageSource.gallery,
        FileSource.camera => ImageSource.camera,
      };
}
