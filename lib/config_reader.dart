import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

/// - contains the initalization for the firebase emulator suite
///- Added only for mobile platforms
/// - this will get all the data required to setup from
/// `./configs/emulator_config.json` if this is not added will use default settings
/// - HACK: must be added via a provider later when having different endpoints
class ConfigReader {
  final Map<String, dynamic> _config = {};
  Future<void> initializeConfigReader() async {
    try {
      final configurationOpitons =
          await rootBundle.loadString('configs/emulator_config.json');
      final jsonValue =
          jsonDecode(configurationOpitons) as Map<String, dynamic>;
      _config.addAll(jsonValue);
    } on Exception catch (_) {
      print(
          'initializeConfigReader | Error | No emulator_config.json found using defaults');
    }
  }

  ///- if this is not provided it will use default which are used by the platforms
  ///andorid emualtors `10.0.2.2` and ios simulators `localhost`
  String get getIp => _config["ip"] ?? _buildIp();

  /// - if this is not provided default will be used `9099` which firebase
  /// emulators use by default
  int get authenticationPort =>
      int.tryParse(_config['auth_port'].toString()) ?? 9099;

  /// - if this is not provided default will be used `8080` which firebase
  /// emulators use by default
  int get firestorePort =>
      int.tryParse(_config['firestore_port'].toString()) ?? 8080;

  ///- builds platform specific hosts
  String _buildIp() {
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }
}
