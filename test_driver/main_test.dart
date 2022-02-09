//import 'package:dailygurus/main.dart' as app;
//import 'package:flutter_driver/driver_extension.dart';
//import 'package:flutter_driver/flutter_driver.dart';
//import 'package:test/test.dart';
//
//void main() {
//  enableFlutterDriverExtension();
//  app.main();
//
//  group('Welcome Screen Test', () {
//    FlutterDriver driver;
//    setUpAll(() async {
//      driver = await FlutterDriver.connect();
//    });
//
//    tearDownAll(() async {
//      if (driver != null) {
//        driver.close();
//      }
//    });
//
//    test('Verify Text on Home Screen', () async {
//      SerializableFinder message;
//      message = find.text('Welcome to DailyGurus');
//      await driver.waitFor(message);
//      expect(await driver.getText(message), 'Welcome to DailyGurus');
//    });
//  });
//}
