import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  // Dynamically selects the correct Base URL based on where the app is running
  static String get baseUrl {
    if (kIsWeb) {
      // Chrome / Web Browser
      return 'http://localhost:3000/api';
    } else if (Platform.isAndroid) {
      // Android Emulator (10.0.2.2 maps to the host machine's localhost)
      return 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      // iOS Simulator
      return 'http://localhost:3000/api';
    } else {
      // Fallback (e.g., Physical Devices / Desktop)
      return 'http://YOUR_LOCAL_IP_ADDRESS:3000/api';
    }
  }
}
