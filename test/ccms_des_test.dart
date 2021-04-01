import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ccms_des/ccms_des.dart';

void main() {
  const MethodChannel channel = MethodChannel('ccms_des');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('crypt', () async {
    expect(await CcmsDes.encryptToHex('string', 'key'), '42');
  });
}
