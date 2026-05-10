// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';

/// Represents preprocessed source text with source mapping.
class SourceText {
  final String sourceName;
  final String text;
  final SourceMap _sourceMap;

  const SourceText(
    this.sourceName,
    this.text, {
    SourceMap? sourceMap,
  }) : _sourceMap = sourceMap ?? const _EmptySourceMap();

  /// Returns the length of the source text.
  int get length => text.length;

  /// Returns the source map for tracking original positions.
  SourceMap get sourceMap => _sourceMap;

  /// Returns the source location for a given offset.
  SourceLocation getLocation(int offset) {
    if (offset < 0 || offset > text.length) {
      return SourceLocation(sourceName, 0, 0, offset);
    }

    int line = 1;
    int column = 1;
    int currentOffset = 0;

    for (int i = 0; i < text.length && currentOffset < offset; i++) {
      if (text[i] == '\n') {
        line++;
        column = 1;
      } else {
        column++;
      }
      currentOffset++;
    }

    return SourceLocation(sourceName, line, column, offset);
  }

  /// Returns the original offset for a preprocessed offset.
  int toOriginalOffset(int preprocessedOffset) {
    return _sourceMap.toOriginalOffset(preprocessedOffset) ??
        preprocessedOffset;
  }
}

class _EmptySourceMap implements SourceMap {
  const _EmptySourceMap();

  @override
  void addMapping(int preprocessedOffset, int originalOffset) {}

  @override
  int? toOriginalOffset(int preprocessedOffset) => null;

  @override
  List<int> get preprocessedOffsets => [];

  @override
  void clear() {}

  @override
  int get length => 0;

  @override
  bool get isEmpty => true;
}
