// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'source_text.dart';

/// Preprocessor for SystemVerilog source files.
///
/// Handles include directives and basic macro substitution.
class Preprocessor {
  final DiagnosticCollector _diagnostics;
  final List<IncludePath> _includePaths;
  final Map<String, String> _definedMacros;

  /// Creates a new preprocessor.
  Preprocessor({
    required DiagnosticCollector diagnostics,
    List<IncludePath> includePaths = const [],
    Map<String, String>? predefinedMacros,
  })  : _diagnostics = diagnostics,
        _includePaths = includePaths,
        _definedMacros = Map.from(predefinedMacros ?? {});

  /// Preprocesses the source text.
  SourceText preprocess(String source, {String? sourceName}) {
    final lines = source.split('\n');
    final output = StringBuffer();
    final sourceMap = SourceMap();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineOffset = _calculateOffset(lines, i);

      // Handle include directives
      if (line.trim().startsWith('`include')) {
        final includeResult = _handleInclude(line, sourceMap, output.length);
        output.write(includeResult.content);
        sourceMap.addMapping(output.length, lineOffset);
      }
      // Handle define directives
      else if (line.trim().startsWith('`define')) {
        _handleDefine(line);
        sourceMap.addMapping(output.length, lineOffset);
      }
      // Handle undef directive
      else if (line.trim().startsWith('`undef')) {
        _handleUndef(line);
        sourceMap.addMapping(output.length, lineOffset);
      }
      // Handle ifdef/endif
      else if (line.trim().startsWith('`ifdef')) {
        output.write(line);
        output.write('\n');
        sourceMap.addMapping(output.length, lineOffset);
      } else if (line.trim().startsWith('`ifndef')) {
        output.write(line);
        output.write('\n');
        sourceMap.addMapping(output.length, lineOffset);
      } else if (line.trim().startsWith('`endif')) {
        output.write(line);
        output.write('\n');
        sourceMap.addMapping(output.length, lineOffset);
      }
      // Handle else/elsif
      else if (line.trim().startsWith('`else') ||
          line.trim().startsWith('`elsif')) {
        output.write(line);
        output.write('\n');
        sourceMap.addMapping(output.length, lineOffset);
      }
      // Regular line - apply macro substitution
      else {
        final processed = _substituteMacros(line);
        output.write(processed);
        output.write('\n');
        sourceMap.addMapping(output.length, lineOffset);
      }
    }

    return SourceText(
      sourceName ?? 'unknown',
      output.toString(),
      sourceMap: sourceMap,
    );
  }

  /// Handles include directive.
  ({String content, int originalOffset}) _handleInclude(
    String line,
    SourceMap sourceMap,
    int currentOffset,
  ) {
    // Extract include path
    final match = RegExp(r'`include\s+"?([^"]+)"?').firstMatch(line);
    if (match == null) {
      _diagnostics.warning(
        'Invalid include directive: $line',
        code: 'SV0001',
      );
      return (content: '', originalOffset: currentOffset);
    }

    final includePath = match.group(1)!;

    // Try to find the include file
    String? includedContent;
    for (final path in _includePaths) {
      final fullPath = '${path.path}/$includePath';
      try {
        includedContent = _readFile(fullPath);
        break;
      } catch (_) {
        // Try next path
      }
    }

    if (includedContent == null) {
      _diagnostics.error(
        'Include file not found: $includePath',
        code: 'SV0002',
      );
      return (content: '', originalOffset: currentOffset);
    }

    // Recursively preprocess the included file
    final preprocessed = preprocess(includedContent, sourceName: includePath);

    // Add mappings for the included content
    for (final offset in preprocessed.sourceMap.preprocessedOffsets) {
      sourceMap.addMapping(currentOffset + offset, offset);
    }

    return (content: preprocessed.text, originalOffset: currentOffset);
  }

  /// Handles define directive.
  void _handleDefine(String line) {
    final match = RegExp(r'`define\s+(\w+)(\(.*?\))?\s*(.*)$').firstMatch(line);
    if (match == null) {
      _diagnostics.warning(
        'Invalid define directive: $line',
        code: 'SV0003',
      );
      return;
    }

    final name = match.group(1)!;
    final args = match.group(2);
    final value = match.group(3) ?? '';

    if (args != null) {
      // Macro with arguments
      _definedMacros['$name$args'] = value;
    } else {
      // Simple macro
      _definedMacros[name] = value;
    }
  }

  /// Handles undef directive.
  void _handleUndef(String line) {
    final match = RegExp(r'`undef\s+(\w+)').firstMatch(line);
    if (match == null) {
      _diagnostics.warning(
        'Invalid undef directive: $line',
        code: 'SV0004',
      );
      return;
    }

    _definedMacros.remove(match.group(1));
  }

  /// Substitutes defined macros in a line.
  String _substituteMacros(String line) {
    var result = line;

    for (final entry in _definedMacros.entries) {
      // Simple text replacement
      if (!entry.key.contains('(')) {
        result = result.replaceAll('`${entry.key}', entry.value);
      }
    }

    return result;
  }

  /// Calculates the offset of a line.
  int _calculateOffset(List<String> lines, int lineIndex) {
    int offset = 0;
    for (int i = 0; i < lineIndex; i++) {
      offset += lines[i].length + 1; // +1 for newline
    }
    return offset;
  }

  /// Reads a file content.
  String _readFile(String path) {
    // This would be implemented with file system access
    // For now, just throw an error
    throw Exception('File not found: $path');
  }
}

/// Represents an include path.
class IncludePath {
  final String path;

  const IncludePath(this.path);
}
