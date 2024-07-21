import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

Future<File?> pickAudio() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      final file = File(result.files.first.xFile.path);
      return file;
    }
    return null;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      final file = File(result.files.first.xFile.path);
      return file;
    }
    return null;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}
