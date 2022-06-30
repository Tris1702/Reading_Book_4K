import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/config/app_route.dart';

import '../../assets/app_string.dart';
import '../../base/bloc_base.dart';

class OnphoneBloc extends BlocBase {
  @override
  void dispose() {}

  @override
  void init() {}

  void pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      var path = result.files.single.path;
      if (path != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  color: AppColor.selectedColor,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(AppString.uploading)
              ],
            ),
          ),
        );
        PDFDoc doc = await PDFDoc.fromPath(path);
        navigator.pop();
        navigator.pushed(AppRoute.readingScreen,
            argument: [await doc.text, '', 'onphone']);
      }
    } else {
      log("Can't pick");
    }
    return null;
  }
}
