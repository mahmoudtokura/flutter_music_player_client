import 'dart:io';

class ServerConstants {
  static String serverURL =
      Platform.isAndroid ? '10.0.2.2:8000' : '127.0.0.1:8000';
}
