import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';

/// - contains the initalization for the firebase emulator suite
///- Added only for mobile platforms
/// - this will get all the data required to setup from
/// `./configs/emulator_config.json` if this is not added will use default settings
/// - HACK: must be added via a provider later when having different endpoints
class ConfigReader {
  final Map<String, dynamic> _config = {};

  FutureVoid initializeConfigReader([String path = 'configs/emulator_config.json']) async {
    try {
      final configOptions = await rootBundle.loadString(path);
      final jsonValue = jsonDecode(configOptions) as Map<String, dynamic>;
      _config.addAll(jsonValue);
    } catch (_) {
      throw const NoEmulatorConfigException();
    }
  }

  ///- if this is not provided it will use default which are used by the platforms
  ///andorid emualtors `10.0.2.2` and ios simulators `localhost`
  String get getIp => _config["ip"] ?? _buildIp();

  /// - if this is not provided default will be used `9099` which firebase
  /// emulators use by default
  int get authenticationPort => int.tryParse(_config['auth_port'].toString()) ?? 9099;

  /// - if this is not provided default will be used `8080` which firebase
  /// emulators use by default
  int get firestorePort => int.tryParse(_config['firestore_port'].toString()) ?? 8080;

  ///- builds platform specific hosts
  String _buildIp() {
    return defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
  }
}

@visibleForTesting
class NoEmulatorConfigException implements Exception {
  const NoEmulatorConfigException();
  @override
  String toString() {
    return 'initializeConfigReader | Error | No emulator_config.json found using defaults';
  }
}
