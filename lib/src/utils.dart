import 'dart:convert';
import 'dart:typed_data';

/// String utils
extension StringX on String {
  /// Indent string by spaces.
  String indent({
    int level = 2,
    int start = 0,
  }) {
    final indentation = ' ' * level;
    final lines = LineSplitter.split(this);
    final unindentedLines = lines.take(start);
    final indentedLines = lines.skip(start).map((line) => '$indentation$line');
    return unindentedLines.followedBy(indentedLines).join('\n');
  }
}

/// Uint8List utils
extension Uint8ListX on Uint8List {
  /// Zeroes the list
  void fillWithZeros() {
    for (var i = 0; i < length; i++) {
      this[i] = 0;
    }
  }
}
