import 'package:conveneapp/config_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conveneapp/core/type_defs/type_defs.dart';

void main() {
  late ConfigReader reader;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    reader = ConfigReader();
  });
  group('initializeConfigReader', () {
    const inValidAssetPath = 'configs/test_emulator_config_nofile.json';
    const validAssetPath = 'configs/test_emulator_config.json';
    const androidDefaultIp = '10.0.2.2';
    const iosDefaultIp = 'localhost';
    const configIp = '192.168.8.131';
    const defaultFirestorePort = 8080;
    const defaultFirebaseAuthPort = 9099;

    test('should return [void] when [configs/test_emulator_config.json] is available', () {
      expect(reader.initializeConfigReader(validAssetPath), isA<FutureVoid>());
    });

    test(
        'should throw [NoEmulatorConfigException()] when [asset] is not found in path[configs/test_emulator_config_nofile.json]',
        () {
      expect(() => reader.initializeConfigReader(inValidAssetPath), throwsA(const NoEmulatorConfigException()));
    });

    test('should return [192.168.8.131] when [ip] is available in the [configs/test_emulator_config.json]', () async {
      await reader.initializeConfigReader(validAssetPath);
      expect(reader.getIp, configIp);
    });

    test('should return [10.0.2.2] when no [ip] is provided in the [emulator_config] and [target platform] is android',
        () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(reader.getIp, equals(androidDefaultIp));
    });

    test('should return [localhost] when no [ip] is provided in the [emulator_config] and [target platform] is ios',
        () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(reader.getIp, equals(iosDefaultIp));
    });

    test('should return [9099] when no [auth_port] is provided in the [emulator_config]', () {
      expect(reader.authenticationPort, equals(defaultFirebaseAuthPort));
    });
    test('should return [8080] when no [firestore_port] is provided in the [emulator_config]', () {
      expect(reader.firestorePort, equals(defaultFirestorePort));
    });

    test(
        'should return [initializeConfigReader | Error | No emulator_config.json found using defaults] when (NoEmulatorConfigException).toString is called',
        () {
      expect(const NoEmulatorConfigException().toString(),
          equals('initializeConfigReader | Error | No emulator_config.json found using defaults'));
    });
  });
}
