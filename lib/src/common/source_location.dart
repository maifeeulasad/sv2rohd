// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

/// Represents a location in source code with file, line, and column information.
class SourceLocation {
  static const SourceLocation _dummy = SourceLocation(
    sourceName: 'unknown',
    line: 0,
    column: 0,
    offset: 0,
  );
  final String sourceName;
  final int line;
  final int column;
  final int offset;

  const SourceLocation({
    required this.sourceName,
    required this.line,
    required this.column,
    required this.offset,
  });

  /// Creates a source location for the start of a file.
  factory SourceLocation.start(String sourceName) {
    return SourceLocation(
      sourceName: sourceName,
      line: 1,
      column: 1,
      offset: 0,
    );
  }

  /// Creates a dummy source location for tests or placeholders.
  factory SourceLocation.dummy() => _dummy;

  /// Creates a source location from offset in source text.
  factory SourceLocation.fromOffset(
      String sourceName, String sourceText, int offset) {
    if (offset < 0 || offset > sourceText.length) {
      throw RangeError.range(offset, 0, sourceText.length, 'offset');
    }

    int line = 1;
    int column = 1;
    int currentOffset = 0;

    for (int i = 0; i < offset; i++) {
      if (sourceText[i] == '\n') {
        line++;
        column = 1;
      } else {
        column++;
      }
      currentOffset = i + 1;
    }

    return SourceLocation(
      sourceName: sourceName,
      line: line,
      column: column,
      offset: offset,
    );
  }

  /// Returns a formatted string representation: "filename:line:column"
  String get formatted => '$sourceName:$line:$column';

  /// Returns a human-readable string with line and column only.
  String get shortFormatted => '$line:$column';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SourceLocation &&
        other.sourceName == sourceName &&
        other.line == line &&
        other.column == column &&
        other.offset == offset;
  }

  @override
  int get hashCode =>
      sourceName.hashCode ^ line.hashCode ^ column.hashCode ^ offset.hashCode;

  @override
  String toString() => 'SourceLocation($formatted)';

  /// Creates a copy with optional field updates.
  SourceLocation copyWith({
    String? sourceName,
    int? line,
    int? column,
    int? offset,
  }) {
    return SourceLocation(
      sourceName: sourceName ?? this.sourceName,
      line: line ?? this.line,
      column: column ?? this.column,
      offset: offset ?? this.offset,
    );
  }
}
