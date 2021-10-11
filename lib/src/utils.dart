import 'dart:convert';

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
