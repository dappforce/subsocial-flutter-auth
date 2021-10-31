import 'dart:typed_data';

/// Uint8List utils
extension Uint8ListX on Uint8List {
  /// Zeroes the list
  void fillWithZeros() {
    for (var i = 0; i < length; i++) {
      this[i] = 0;
    }
  }
}
