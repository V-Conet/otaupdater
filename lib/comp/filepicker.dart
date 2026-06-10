import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


Future<String> PickFile() async {
  FilePickerResult? result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['bin', 'zip'],
  );

  if (result != null && result.files.single.path != null) {
    return result.files.single.path!;
  } else {
    return "";
  }
}
