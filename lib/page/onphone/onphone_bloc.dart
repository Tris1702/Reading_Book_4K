import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:reading_book_4k/config/app_route.dart';

import '../../base/bloc_base.dart';

class OnphoneBloc extends BlocBase {
  @override
  void dispose() {}

  @override
  void init() {}

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'docx', 'doc']);

    if (result != null) {
      var path = result.files.single.path;
      if (path != null) {
        PDFDoc doc = await PDFDoc.fromPath(path);
        navigator.popAndPush(
            AppRoute.readingScreen, argument: [await doc.text, '', 'onphone']);
      }
    } else {
      log("Can't pick");
    }
    return null;
  }
}
