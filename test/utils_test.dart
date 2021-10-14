import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_auth/src/utils.dart';

void main() {
  test('Uint8List.fillWithZeros', () {
    final bytes = SecureRandom(255).bytes;

    expect(bytes, isNot(everyElement(0)));

    bytes.fillWithZeros();

    expect(bytes, everyElement(0));
  });
}
