// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'source_location.dart';

/// Represents a range of source code from start to end location.
class SourceRange {
  final SourceLocation start;
  final SourceLocation end;

  const SourceRange({
    required this.start,
    required this.end,
  });

  /// Creates a source range for a single point.
  factory SourceRange.point(SourceLocation location) {
    return SourceRange(start: location, end: location);
  }

  /// Creates a source range from offsets.
  factory SourceRange.fromOffsets(
    String sourceName,
    String sourceText,
    int startOffset,
    int endOffset,
  ) {
    return SourceRange(
      start: SourceLocation.fromOffset(sourceName, sourceText, startOffset),
      end: SourceLocation.fromOffset(sourceName, sourceText, endOffset),
    );
  }

  /// Returns true if the given offset is within this range.
  bool containsOffset(int offset) {
    return offset >= start.offset && offset <= end.offset;
  }

  /// Returns the length of this range in characters.
  int get length => end.offset - start.offset;

  /// Returns true if this range contains [other].
  bool containsRange(SourceRange other) {
    return start.offset <= other.start.offset && end.offset >= other.end.offset;
  }

  /// Returns true if this range overlaps with [other].
  bool overlaps(SourceRange other) {
    return start.offset <= other.end.offset && end.offset >= other.start.offset;
  }

  /// Returns a string representation for display.
  String get formatted => '${start.formatted}-${end.shortFormatted}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SourceRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() => 'SourceRange($formatted)';

  /// Creates a copy with optional field updates.
  SourceRange copyWith({
    SourceLocation? start,
    SourceLocation? end,
  }) {
    return SourceRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
