// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

/// Source map for tracking mapping between original and processed source locations.
class SourceMap {
  final Map<int, int> _offsetMapping = {};

  /// Adds a mapping from a preprocessed offset to an original offset.
  void addMapping(int preprocessedOffset, int originalOffset) {
    _offsetMapping[preprocessedOffset] = originalOffset;
  }

  /// Converts a preprocessed offset to an original offset.
  int? toOriginalOffset(int preprocessedOffset) {
    // Find the largest preprocessed offset <= this that we have mapping for
    int? result;
    for (final entry in _offsetMapping.entries) {
      if (entry.key <= preprocessedOffset) {
        result = entry.value;
      }
    }
    return result;
  }

  /// Returns all preprocessed offsets in sorted order.
  List<int> get preprocessedOffsets {
    final offsets = _offsetMapping.keys.toList();
    offsets.sort();
    return offsets;
  }

  /// Clears all mappings.
  void clear() {
    _offsetMapping.clear();
  }

  /// Returns the number of mappings.
  int get length => _offsetMapping.length;

  /// Returns true if there are no mappings.
  bool get isEmpty => _offsetMapping.isEmpty;
}

/// Collection of utility functions used throughout the project.
class Utils {
  Utils._();

  /// Returns true if the string is a valid SystemVerilog identifier.
  static bool isValidIdentifier(String s) {
    if (s.isEmpty) return false;

    // First character must be letter or underscore
    final first = s[0];
    if (!RegExp(r'[a-zA-Z_]').hasMatch(first)) return false;

    // Remaining characters can be alphanumeric, underscore, or dollar sign
    for (int i = 1; i < s.length; i++) {
      final c = s[i];
      if (!RegExp(r'[a-zA-Z0-9_$]').hasMatch(c)) return false;
    }

    return true;
  }

  /// Splits text into lines, preserving line continuation.
  static List<String> splitLinesPreserveContinuation(String text) {
    final lines = <String>[];
    final buffer = StringBuffer();
    bool backslashFound = false;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      if (char == '\\' && i + 1 < text.length && text[i + 1] == '\n') {
        backslashFound = true;
        i++; // Skip the newline
        continue;
      }

      if (char == '\n' && !backslashFound) {
        lines.add(buffer.toString());
        buffer.clear();
      } else {
        if (char != '\n' || backslashFound) {
          buffer.write(char);
        }
        backslashFound = false;
      }
    }

    if (buffer.isNotEmpty) {
      lines.add(buffer.toString());
    }

    return lines;
  }

  /// Trims whitespace from a string safely.
  static String? trim(String? s) => s?.trim();

  /// Returns true if the string is empty or whitespace only.
  static bool isBlank(String? s) => s?.trim().isEmpty ?? true;

  /// Repeats a string [times] times.
  static String repeat(String s, int times) {
    if (times <= 0) return '';
    return s * times;
  }

  /// Converts a string to snake_case.
  static String toSnakeCase(String identifier) {
    final buffer = StringBuffer();
    bool lastWasUnderscore = true;

    for (int i = 0; i < identifier.length; i++) {
      final char = identifier[i];

      if (RegExp(r'[A-Z]').hasMatch(char)) {
        if (!lastWasUnderscore) {
          buffer.write('_');
        }
        buffer.write(char.toLowerCase());
        lastWasUnderscore = false;
      } else if (char == '_') {
        buffer.write('_');
        lastWasUnderscore = true;
      } else {
        buffer.write(char);
        lastWasUnderscore = false;
      }
    }

    var result = buffer.toString();
    if (result.endsWith('_')) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }

  /// Converts a string to PascalCase (capitalized words).
  static String toPascalCase(String s) {
    if (s.isEmpty) return s;

    final words = s.split(RegExp(r'[_\s]+'));
    final buffer = StringBuffer();

    for (final word in words) {
      if (word.isNotEmpty) {
        buffer.write(word[0].toUpperCase());
        if (word.length > 1) {
          buffer.write(word.substring(1).toLowerCase());
        }
      }
    }

    return buffer.toString();
  }

  /// Converts a string to camelCase.
  static String toCamelCase(String s) {
    final pascal = toPascalCase(s);
    if (pascal.isEmpty) return s;

    return pascal[0].toLowerCase() + pascal.substring(1);
  }
}