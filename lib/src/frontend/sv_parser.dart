// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Hand-written SystemVerilog scanner and recursive-descent parser for the
// synthesizable subset supported by sv2rohd. Parts of this implementation
// were generated with LLM assistance and reviewed by the maintainer.

import '../analysis/symbol.dart';
import '../common/common.dart';
import '../ir/ir.dart';

/// Token categories produced by [SvScanner].
enum SvTokenType {
  identifier,
  systemIdentifier,
  number,
  string,
  punct,
  eof,
}

/// A single lexical token.
class SvToken {
  final SvTokenType type;
  final String text;
  final int offset;
  final int line;
  final int column;

  const SvToken({
    required this.type,
    required this.text,
    required this.offset,
    required this.line,
    required this.column,
  });

  bool get isEof => type == SvTokenType.eof;

  @override
  String toString() => '$type("$text")@$line:$column';
}

/// Scans SystemVerilog source text into a flat token list.
///
/// Comments, whitespace, and preprocessor directives are dropped; the parser
/// only ever sees meaningful tokens.
class SvScanner {
  final String source;
  final String sourceName;

  int _pos = 0;
  int _line = 1;
  int _col = 1;

  SvScanner(this.source, {this.sourceName = 'unknown'});

  static const _multiCharOps = [
    '<<<=', '>>>=', //
    '<<<', '>>>', '<<=', '>>=', '===', '!==', '==?', '!=?', '<->', //
    '<<', '>>', '<=', '>=', '==', '!=', '&&', '||', '**', '++', '--', //
    '+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=', '~&', '~|', '~^', '^~', //
    '::', '+:', '-:', '.*', '->', //
  ];

  List<SvToken> scan() {
    final tokens = <SvToken>[];
    while (_pos < source.length) {
      final c = source[_pos];

      // Whitespace
      if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
        _advance();
        continue;
      }

      // Comments
      if (c == '/' && _peekAt(1) == '/') {
        while (_pos < source.length && source[_pos] != '\n') {
          _advance();
        }
        continue;
      }
      if (c == '/' && _peekAt(1) == '*') {
        _advance();
        _advance();
        while (_pos < source.length &&
            !(source[_pos] == '*' && _peekAt(1) == '/')) {
          _advance();
        }
        if (_pos < source.length) {
          _advance();
          _advance();
        }
        continue;
      }

      // Preprocessor / compiler directives: skip the rest of the line.
      if (c == '`') {
        while (_pos < source.length && source[_pos] != '\n') {
          _advance();
        }
        continue;
      }

      final startOffset = _pos;
      final startLine = _line;
      final startCol = _col;

      // Strings
      if (c == '"') {
        _advance();
        while (_pos < source.length && source[_pos] != '"') {
          if (source[_pos] == '\\') _advance();
          _advance();
        }
        if (_pos < source.length) _advance();
        tokens.add(SvToken(
          type: SvTokenType.string,
          text: source.substring(startOffset, _pos),
          offset: startOffset,
          line: startLine,
          column: startCol,
        ));
        continue;
      }

      // Numbers, including based literals (8'hFF) and unbased ('0, '1).
      if (_isDigit(c) || (c == "'" && _startsBasedOrUnbased())) {
        _scanNumber();
        tokens.add(SvToken(
          type: SvTokenType.number,
          text: source.substring(startOffset, _pos),
          offset: startOffset,
          line: startLine,
          column: startCol,
        ));
        continue;
      }

      // Identifiers and keywords
      if (_isIdentStart(c)) {
        while (_pos < source.length && _isIdentPart(source[_pos])) {
          _advance();
        }
        tokens.add(SvToken(
          type: SvTokenType.identifier,
          text: source.substring(startOffset, _pos),
          offset: startOffset,
          line: startLine,
          column: startCol,
        ));
        continue;
      }

      // System identifiers ($clog2, $display, ...)
      if (c == r'$') {
        _advance();
        while (_pos < source.length && _isIdentPart(source[_pos])) {
          _advance();
        }
        tokens.add(SvToken(
          type: SvTokenType.systemIdentifier,
          text: source.substring(startOffset, _pos),
          offset: startOffset,
          line: startLine,
          column: startCol,
        ));
        continue;
      }

      // Multi-character operators (longest match first)
      String? matched;
      for (final op in _multiCharOps) {
        if (source.startsWith(op, _pos)) {
          matched = op;
          break;
        }
      }
      if (matched != null) {
        for (var i = 0; i < matched.length; i++) {
          _advance();
        }
        tokens.add(SvToken(
          type: SvTokenType.punct,
          text: matched,
          offset: startOffset,
          line: startLine,
          column: startCol,
        ));
        continue;
      }

      // Single-character punctuation (includes lone ' used by casts).
      _advance();
      tokens.add(SvToken(
        type: SvTokenType.punct,
        text: c,
        offset: startOffset,
        line: startLine,
        column: startCol,
      ));
    }

    tokens.add(SvToken(
      type: SvTokenType.eof,
      text: '',
      offset: _pos,
      line: _line,
      column: _col,
    ));
    return tokens;
  }

  bool _startsBasedOrUnbased() {
    // '0 / '1 / 'x / 'z, or 'b.../'d.../'h.../'o... possibly with s modifier.
    final n1 = _peekAt(1);
    if (n1 == null) return false;
    if ('01xXzZ'.contains(n1)) {
      // Make sure this is not a cast like WIDTH'(1) — next char after tick
      // being a digit or xz means it is a literal.
      return true;
    }
    var i = 1;
    var ch = _peekAt(i);
    if (ch == 's' || ch == 'S') {
      i++;
      ch = _peekAt(i);
    }
    return ch != null && 'bBdDoOhH'.contains(ch) && _peekAt(i + 1) != null;
  }

  void _scanNumber() {
    // Leading size digits (possibly none for unsized based literals).
    while (_pos < source.length &&
        (_isDigit(source[_pos]) || source[_pos] == '_')) {
      _advance();
    }
    // Optional base part.
    if (_pos < source.length &&
        source[_pos] == "'" &&
        _startsBasedOrUnbased()) {
      _advance(); // tick
      if (_pos < source.length &&
          (source[_pos] == 's' || source[_pos] == 'S')) {
        _advance();
      }
      if (_pos < source.length && 'bBdDoOhH'.contains(source[_pos])) {
        _advance();
        while (_pos < source.length &&
            (_isHexDigit(source[_pos]) ||
                source[_pos] == '_' ||
                'xXzZ?'.contains(source[_pos]))) {
          _advance();
        }
      } else if (_pos < source.length && '01xXzZ'.contains(source[_pos])) {
        _advance();
      }
    }
  }

  String? _peekAt(int delta) =>
      _pos + delta < source.length ? source[_pos + delta] : null;

  void _advance() {
    if (source[_pos] == '\n') {
      _line++;
      _col = 1;
    } else {
      _col++;
    }
    _pos++;
  }

  static bool _isDigit(String c) =>
      c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

  static bool _isHexDigit(String c) =>
      _isDigit(c) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x66) ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x46);

  static bool _isIdentStart(String c) {
    final u = c.codeUnitAt(0);
    return (u >= 0x41 && u <= 0x5A) || (u >= 0x61 && u <= 0x7A) || c == '_';
  }

  static bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}

/// Recursive-descent parser producing sv2rohd IR from SystemVerilog source.
///
/// Supported subset: module declarations with parameter and ANSI port lists,
/// signal/localparam/genvar declarations, continuous assignments, always
/// blocks (always_ff / always_comb / always / always_latch), if/case/for
/// statements, blocking and non-blocking assignments, generate regions with
/// for- and if-generate, module instantiations, and the standard expression
/// grammar (including concatenation, replication, part-selects, and casts).
class SvParser {
  final DiagnosticCollector diagnostics;
  final String sourceName;

  late final List<SvToken> _tokens;
  int _pos = 0;

  /// User-defined enum typedef names mapped to their bit width, so later
  /// declarations using the type (e.g. `state_t state;`) are recognized.
  final Map<String, int> _enumTypeWidths = {};

  SvParser(
    String source, {
    required this.diagnostics,
    this.sourceName = 'unknown',
  }) {
    _tokens = SvScanner(source, sourceName: sourceName).scan();
  }

  // ── Token helpers ────────────────────────────────────────────────

  SvToken get _current => _tokens[_pos];

  SvToken _peek([int delta = 1]) {
    final i = _pos + delta;
    return i < _tokens.length ? _tokens[i] : _tokens.last;
  }

  bool _check(String text) => _current.text == text;

  bool _checkIdentifier() =>
      _current.type == SvTokenType.identifier && !_isKeyword(_current.text);

  bool _match(String text) {
    if (_check(text)) {
      _pos++;
      return true;
    }
    return false;
  }

  SvToken _advance() {
    final t = _current;
    if (!t.isEof) _pos++;
    return t;
  }

  SvToken _expect(String text) {
    if (_check(text)) return _advance();
    _error("expected '$text' but found '${_current.text}'");
    return _current;
  }

  String _expectIdentifier(String what) {
    if (_current.type == SvTokenType.identifier) {
      return _advance().text;
    }
    _error("expected $what but found '${_current.text}'");
    return '_missing_';
  }

  void _error(String message) {
    diagnostics.error(
      '$sourceName:${_current.line}:${_current.column}: $message',
      code: 'PARSE001',
    );
  }

  void _warn(String message) {
    diagnostics.warning(
      '$sourceName:${_current.line}:${_current.column}: $message',
      code: 'PARSE002',
    );
  }

  SourceLocation _loc([SvToken? token]) {
    final t = token ?? _current;
    return SourceLocation(
      sourceName: sourceName,
      line: t.line,
      column: t.column,
      offset: t.offset,
    );
  }

  static const _keywords = {
    'module', 'macromodule', 'endmodule', 'input', 'output', 'inout', //
    'parameter', 'localparam', 'logic', 'wire', 'reg', 'bit', 'byte', //
    'int', 'integer', 'longint', 'shortint', 'genvar', 'generate', //
    'endgenerate', 'assign', 'always', 'always_ff', 'always_comb', //
    'always_latch', 'initial', 'final', 'begin', 'end', 'if', 'else', //
    'case', 'casez', 'casex', 'endcase', 'default', 'for', 'while', //
    'repeat', 'forever', 'do', 'posedge', 'negedge', 'or', 'and', //
    'signed', 'unsigned', 'var', 'typedef', 'enum', 'struct', 'union', //
    'function', 'endfunction', 'task', 'endtask', 'return', 'break', //
    'continue', 'unique', 'priority', 'wait', 'disable', 'timeunit', //
    'timeprecision', 'package', 'endpackage', 'import', 'export',
  };

  static bool _isKeyword(String text) => _keywords.contains(text);

  static const _netTypes = {'wire', 'tri', 'wand', 'wor', 'supply0', 'supply1'};
  static const _varTypes = {'logic', 'reg', 'bit'};
  static const _intTypes = {'int', 'integer', 'byte', 'longint', 'shortint'};

  // ── Compilation unit ─────────────────────────────────────────────

  /// Parses the whole source and returns every module found.
  List<ModuleDeclaration> parseCompilationUnit() {
    final modules = <ModuleDeclaration>[];
    while (!_current.isEof) {
      if (_check('module') || _check('macromodule')) {
        modules.add(_parseModule());
      } else if (_check('interface')) {
        _warn('interface declarations are not supported; skipped '
            '(ROHD has no interface concept)');
        _skipToMatching('interface', 'endinterface');
      } else if (_check('package')) {
        _warn('package declarations are not supported; skipped');
        _skipToMatching('package', 'endpackage');
      } else if (_check('program')) {
        _warn('program blocks are not supported; skipped');
        _skipToMatching('program', 'endprogram');
      } else if (_check('checker')) {
        _warn('checker declarations are not supported; skipped');
        _skipToMatching('checker', 'endchecker');
      } else {
        _advance();
      }
    }
    return modules;
  }

  static bool _isAssertKeyword(String text) =>
      text == 'assert' ||
      text == 'assume' ||
      text == 'cover' ||
      text == 'restrict' ||
      text == 'expect';

  /// Skips an assertion statement, including a trailing `else` action.
  void _skipAssertion() {
    _skipPast(';');
    if (_check('else')) _skipPast(';');
  }

  // ── Module ───────────────────────────────────────────────────────

  ModuleDeclaration _parseModule() {
    final start = _current;
    _advance(); // module / macromodule
    final name = _expectIdentifier('module name');

    final parameters = <ParameterDeclaration>[];
    if (_match('#')) {
      _expect('(');
      parameters.addAll(_parseParameterPortList());
      _expect(')');
    }

    final ports = <PortDeclaration>[];
    if (_match('(')) {
      ports.addAll(_parsePortList());
      _expect(')');
    }
    _expect(';');

    final items = <IrNode>[];
    while (!_check('endmodule') && !_current.isEof) {
      items.addAll(_parseModuleItems(ports, parameters));
    }
    _expect('endmodule');
    if (_match(':')) {
      _expectIdentifier('module label');
    }

    return ModuleDeclaration(
      location: _loc(start),
      name: name,
      parameters: parameters,
      ports: ports,
      items: items,
    );
  }

  List<ParameterDeclaration> _parseParameterPortList() {
    final parameters = <ParameterDeclaration>[];
    var isLocal = false;
    while (!_check(')') && !_current.isEof) {
      if (_match('parameter')) {
        isLocal = false;
      } else if (_match('localparam')) {
        isLocal = true;
      }
      _skipDataTypeForParameter();
      final start = _current;
      final name = _expectIdentifier('parameter name');
      IrExpression? defaultValue;
      if (_match('=')) {
        defaultValue = _parseExpression();
      }
      parameters.add(ParameterDeclaration(
        location: _loc(start),
        name: name,
        defaultValue: defaultValue,
        isLocal: isLocal,
      ));
      if (!_match(',')) break;
    }
    return parameters;
  }

  void _skipDataTypeForParameter() {
    // Optional type between `parameter` and the name: `int`, `integer`,
    // `logic [..]`, `type`, signedness, etc.
    while (_intTypes.contains(_current.text) ||
        _varTypes.contains(_current.text) ||
        _current.text == 'signed' ||
        _current.text == 'unsigned' ||
        _current.text == 'type') {
      _advance();
      while (_check('[')) {
        _skipBrackets();
      }
    }
  }

  List<PortDeclaration> _parsePortList() {
    final ports = <PortDeclaration>[];
    var direction = PortDirection.inout;
    VectorWidth? width;
    var isSigned = false;

    while (!_check(')') && !_current.isEof) {
      if (_check('input')) {
        _advance();
        direction = PortDirection.input;
        width = null;
        isSigned = false;
      } else if (_check('output')) {
        _advance();
        direction = PortDirection.output;
        width = null;
        isSigned = false;
      } else if (_check('inout')) {
        _advance();
        direction = PortDirection.inout;
        width = null;
        isSigned = false;
      }

      // Optional net/var type keywords + signedness.
      var sawType = false;
      var sawSigned = false;
      while (_varTypes.contains(_current.text) ||
          _netTypes.contains(_current.text) ||
          _intTypes.contains(_current.text) ||
          _check('var') ||
          _check('signed') ||
          _check('unsigned')) {
        if (_check('signed')) sawSigned = true;
        _advance();
        sawType = true;
      }
      if (sawType) {
        width = null;
        isSigned = sawSigned;
      }

      // Optional packed dimension(s); the first is the vector width.
      if (_check('[')) {
        width = _parseVectorWidth();
        while (_check('[')) {
          _skipBrackets();
        }
      }

      final start = _current;
      final name = _expectIdentifier('port name');

      // Ignore unpacked dimensions on ports for now.
      while (_check('[')) {
        _skipBrackets();
      }

      ports.add(PortDeclaration(
        location: _loc(start),
        name: name,
        direction: direction,
        width: width,
        isSigned: isSigned,
      ));

      if (!_match(',')) break;
    }
    return ports;
  }

  VectorWidth _parseVectorWidth() {
    final start = _expect('[');
    final msb = _parseExpression();
    _expect(':');
    final lsb = _parseExpression();
    _expect(']');
    return VectorWidth(location: _loc(start), msb: msb, lsb: lsb);
  }

  void _skipBrackets() {
    _expect('[');
    var depth = 1;
    while (depth > 0 && !_current.isEof) {
      if (_check('[')) depth++;
      if (_check(']')) depth--;
      _advance();
    }
  }

  // ── Module items ─────────────────────────────────────────────────

  List<IrNode> _parseModuleItems(
    List<PortDeclaration> ports,
    List<ParameterDeclaration> parameters,
  ) {
    final t = _current.text;

    // Non-ANSI body port declarations refine existing header ports.
    if (t == 'input' || t == 'output' || t == 'inout') {
      _parseBodyPortDeclaration(ports);
      return const [];
    }

    if (t == 'typedef') {
      return _parseTypedef();
    }

    if (t == 'enum') {
      // Anonymous inline enum: `enum logic [1:0] {A,B} sig;`
      return _parseInlineEnumDeclaration();
    }

    // Declaration using a previously defined enum typedef, e.g.
    // `state_t state, next_state;`
    if (_checkIdentifier() && _enumTypeWidths.containsKey(t)) {
      return _parseTypedefSignalDeclaration();
    }

    if (_varTypes.contains(t) ||
        _netTypes.contains(t) ||
        _intTypes.contains(t)) {
      return _parseSignalDeclaration();
    }

    if (t == 'parameter' || t == 'localparam') {
      final isLocal = t == 'localparam';
      _advance();
      _skipDataTypeForParameter();
      while (true) {
        final start = _current;
        final name = _expectIdentifier('parameter name');
        IrExpression? defaultValue;
        if (_match('=')) {
          defaultValue = _parseExpression();
        }
        parameters.add(ParameterDeclaration(
          location: _loc(start),
          name: name,
          defaultValue: defaultValue,
          isLocal: isLocal,
        ));
        if (!_match(',')) break;
      }
      _expect(';');
      return const [];
    }

    if (t == 'genvar') {
      _advance();
      final decls = <IrNode>[];
      while (true) {
        final start = _current;
        final name = _expectIdentifier('genvar name');
        decls.add(GenvarDeclaration(location: _loc(start), name: name));
        if (!_match(',')) break;
      }
      _expect(';');
      return decls;
    }

    if (t == 'assign') {
      return _parseContinuousAssign();
    }

    if (t == 'always_ff' ||
        t == 'always_comb' ||
        t == 'always_latch' ||
        t == 'always') {
      return [_parseAlwaysBlock()];
    }

    if (t == 'initial') {
      final start = _advance();
      final body = _parseStatement();
      return [InitialBlock(location: _loc(start), body: body)];
    }

    if (t == 'generate') {
      _advance();
      final items = <IrNode>[];
      while (!_check('endgenerate') && !_current.isEof) {
        items.addAll(_parseGenerateItem());
      }
      _expect('endgenerate');
      return items;
    }

    if (t == 'for' || t == 'if') {
      // Generate constructs are allowed without the generate keyword.
      return _parseGenerateItem();
    }

    if (t == 'function') {
      return _parseFunction();
    }

    if (t == 'task') {
      _skipToMatching('task', 'endtask');
      _warn('task declarations are not supported; skipped');
      return const [];
    }

    if (t == 'timeunit' || t == 'timeprecision' || t == 'import') {
      _skipPast(';');
      return const [];
    }

    // SystemVerilog assertions (immediate or concurrent), including a
    // leading `label :`. Not synthesizable logic; skip with a diagnostic.
    if (_isAssertKeyword(t) ||
        (_checkIdentifier() &&
            _peek().text == ':' &&
            _isAssertKeyword(_peek(2).text))) {
      _warn('SystemVerilog assertions are not supported; skipped');
      _skipAssertion();
      return const [];
    }

    if (t == 'property' || t == 'sequence') {
      _warn('$t declarations are not supported; skipped');
      _skipToMatching(t, t == 'property' ? 'endproperty' : 'endsequence');
      return const [];
    }

    if (t == 'modport') {
      _warn('modport declarations are not supported; skipped');
      _skipPast(';');
      return const [];
    }

    // Module instantiation: `Name #(...)? inst (...);`
    if (_checkIdentifier() &&
        (_peek().text == '#' ||
            (_peek().type == SvTokenType.identifier && _peek(2).text == '('))) {
      return [_parseInstantiation()];
    }

    _warn("skipping unsupported construct near '${_current.text}'");
    _skipPast(';');
    return const [];
  }

  void _parseBodyPortDeclaration(List<PortDeclaration> ports) {
    final direction = switch (_advance().text) {
      'input' => PortDirection.input,
      'output' => PortDirection.output,
      _ => PortDirection.inout,
    };
    var isSigned = false;
    while (_varTypes.contains(_current.text) ||
        _netTypes.contains(_current.text) ||
        _check('signed') ||
        _check('unsigned')) {
      if (_check('signed')) isSigned = true;
      _advance();
    }
    VectorWidth? width;
    if (_check('[')) {
      width = _parseVectorWidth();
    }
    while (true) {
      final name = _expectIdentifier('port name');
      final index = ports.indexWhere((p) => p.name == name);
      final updated = PortDeclaration(
        location: index >= 0 ? ports[index].location : _loc(),
        name: name,
        direction: direction,
        width: width,
        isSigned: isSigned,
      );
      if (index >= 0) {
        ports[index] = updated;
      } else {
        ports.add(updated);
      }
      if (!_match(',')) break;
    }
    _expect(';');
  }

  /// Parses `typedef enum [base] { members } name;`. The enum members are
  /// emitted as `localparam`-style constants (available in the int domain)
  /// and the type name is registered so later declarations resolve to a
  /// vector of the enum's width. Non-enum typedefs are skipped with a warning.
  List<IrNode> _parseTypedef() {
    _expect('typedef');
    if (!_check('enum')) {
      _warn('only `typedef enum` is supported; skipping this typedef');
      _skipPast(';');
      return const [];
    }
    final (width, members) = _parseEnumBody();
    final typeName = _expectIdentifier('typedef name');
    while (_check('[')) {
      _skipBrackets(); // unpacked dims on the typedef itself are ignored
    }
    _expect(';');
    _enumTypeWidths[typeName] = width;
    return members;
  }

  /// Parses an anonymous inline enum declaration, e.g.
  /// `enum logic [1:0] { A, B } state, next;`.
  List<IrNode> _parseInlineEnumDeclaration() {
    final (width, members) = _parseEnumBody();
    final items = <IrNode>[...members];
    while (true) {
      final start = _current;
      final name = _expectIdentifier('signal name');
      items.add(SignalDeclaration(
        location: _loc(start),
        name: name,
        signalType: SignalType.logic,
        width: _constWidth(width, start),
      ));
      if (!_match(',')) break;
    }
    _expect(';');
    return items;
  }

  /// Parses declarations of the form `state_t state, next_state;` where
  /// `state_t` is a known enum typedef.
  List<IrNode> _parseTypedefSignalDeclaration() {
    final typeName = _advance().text;
    final width = _enumTypeWidths[typeName]!;
    final signals = <IrNode>[];
    while (true) {
      final start = _current;
      final name = _expectIdentifier('signal name');
      final unpackedDims = <VectorWidth>[];
      while (_check('[')) {
        unpackedDims.add(_parseVectorWidth());
      }
      signals.add(SignalDeclaration(
        location: _loc(start),
        name: name,
        signalType: SignalType.logic,
        width: _constWidth(width, start),
        unpackedDims: unpackedDims,
      ));
      if (!_match(',')) break;
    }
    _expect(';');
    return signals;
  }

  /// Parses `enum [base_type] { A, B=val, C }`, returning the enum bit width
  /// and one localparam-style [ParameterDeclaration] per member. Members
  /// without an explicit value continue numbering from the previous one.
  (int, List<ParameterDeclaration>) _parseEnumBody() {
    _expect('enum');
    int? explicitWidth;
    // Optional base type: `logic [W-1:0]`, `int`, `bit [3:0]`, etc.
    if (_varTypes.contains(_current.text) ||
        _intTypes.contains(_current.text)) {
      final baseIsInt = _intTypes.contains(_current.text);
      _advance();
      while (_check('signed') || _check('unsigned')) {
        _advance();
      }
      if (_check('[')) {
        final w = _parseVectorWidth();
        explicitWidth = _widthFromVector(w);
      } else if (baseIsInt) {
        explicitWidth = 32;
      }
    }

    _expect('{');
    final members = <ParameterDeclaration>[];
    var nextValue = 0;
    while (!_check('}') && !_current.isEof) {
      final start = _current;
      final name = _expectIdentifier('enum member');
      if (_match('=')) {
        final valueExpr = _parseExpression();
        members.add(ParameterDeclaration(
          location: _loc(start),
          name: name,
          defaultValue: valueExpr,
          isLocal: true,
        ));
        if (valueExpr is LiteralExpression && valueExpr.value is int) {
          nextValue = (valueExpr.value as int) + 1;
        }
      } else {
        members.add(ParameterDeclaration(
          location: _loc(start),
          name: name,
          defaultValue: LiteralExpression(
            location: _loc(start),
            kind: LiteralKind.integer,
            value: nextValue,
          ),
          isLocal: true,
        ));
        nextValue++;
      }
      if (!_match(',')) break;
    }
    _expect('}');

    final width = explicitWidth ?? _minWidthFor(members.length);
    if (explicitWidth == null) {
      _warn('enum has no explicit base type; inferring a ${width}-bit width '
          'from ${members.length} members');
    }
    return (width, members);
  }

  /// Minimum number of bits needed to represent [count] distinct values.
  int _minWidthFor(int count) {
    if (count <= 1) return 1;
    var bits = 0;
    var capacity = 1;
    while (capacity < count) {
      capacity <<= 1;
      bits++;
    }
    return bits;
  }

  int _widthFromVector(VectorWidth w) {
    final msb = w.msb;
    final lsb = w.lsb;
    if (msb is LiteralExpression &&
        lsb is LiteralExpression &&
        msb.value is int &&
        lsb.value is int) {
      return ((msb.value as int) - (lsb.value as int)).abs() + 1;
    }
    return 1;
  }

  VectorWidth _constWidth(int width, SvToken start) => VectorWidth(
        location: _loc(start),
        msb: LiteralExpression(
          location: _loc(start),
          kind: LiteralKind.integer,
          value: width - 1,
        ),
        lsb: LiteralExpression(
          location: _loc(start),
          kind: LiteralKind.integer,
          value: 0,
        ),
      );

  /// Parses a `function [automatic] [return_type] name (ports); body
  /// endfunction`. The function is captured as a [FunctionDeclaration] whose
  /// body is inlined at call sites during code generation (see
  /// `FunctionInliner`); tasks are not supported.
  List<IrNode> _parseFunction() {
    final start = _expect('function');
    _match('automatic');
    _match('static');
    _match('void');

    // Consume return-type tokens (keywords, signedness, a type name) until
    // the function name — the identifier immediately followed by `(` or `;`.
    // A packed dimension seen along the way is the return width.
    VectorWidth? returnWidth;
    while (!(_current.type == SvTokenType.identifier &&
        (_peek().text == '(' || _peek().text == ';'))) {
      if (_current.isEof || _check('endfunction')) break;
      if (_check('[')) {
        returnWidth = _parseVectorWidth();
        continue;
      }
      _advance();
    }
    final name = _expectIdentifier('function name');

    final params = <FunctionPort>[];
    if (_match('(')) {
      params.addAll(_parseFunctionPortList());
      _expect(')');
    }
    _expect(';');

    final body = <IrStatement>[];
    while (!_check('endfunction') && !_current.isEof) {
      final t = _current.text;
      if (t == 'input' || t == 'output' || t == 'inout') {
        // Non-ANSI parameter declarations inside the body.
        params.addAll(_parseFunctionBodyPorts());
      } else if (_varTypes.contains(t) ||
          _netTypes.contains(t) ||
          _intTypes.contains(t)) {
        // Local variable declaration; consumed and discarded (locals are
        // resolved by forward substitution during inlining).
        _parseSignalDeclaration();
      } else {
        body.add(_parseStatement());
      }
    }
    _expect('endfunction');
    if (_match(':')) {
      _expectIdentifier('function label');
    }

    return [
      FunctionDeclaration(
        location: _loc(start),
        name: name,
        ports: params,
        returnWidth: returnWidth,
        body: body,
      ),
    ];
  }

  List<FunctionPort> _parseFunctionPortList() {
    final params = <FunctionPort>[];
    var direction = PortDirection.input;
    VectorWidth? width;
    while (!_check(')') && !_current.isEof) {
      if (_match('input')) {
        direction = PortDirection.input;
        width = null;
      } else if (_match('output')) {
        direction = PortDirection.output;
        width = null;
      } else if (_match('inout')) {
        direction = PortDirection.inout;
        width = null;
      }
      while (_varTypes.contains(_current.text) ||
          _intTypes.contains(_current.text) ||
          _check('signed') ||
          _check('unsigned')) {
        _advance();
      }
      if (_check('[')) {
        width = _parseVectorWidth();
      }
      final start = _current;
      final name = _expectIdentifier('parameter name');
      params.add(FunctionPort(
        location: _loc(start),
        name: name,
        direction: direction,
        width: width,
      ));
      if (!_match(',')) break;
    }
    return params;
  }

  List<FunctionPort> _parseFunctionBodyPorts() {
    final direction = switch (_advance().text) {
      'output' => PortDirection.output,
      'inout' => PortDirection.inout,
      _ => PortDirection.input,
    };
    while (_varTypes.contains(_current.text) ||
        _intTypes.contains(_current.text) ||
        _check('signed') ||
        _check('unsigned')) {
      _advance();
    }
    VectorWidth? width;
    if (_check('[')) {
      width = _parseVectorWidth();
    }
    final params = <FunctionPort>[];
    while (true) {
      final start = _current;
      final name = _expectIdentifier('parameter name');
      params.add(FunctionPort(
        location: _loc(start),
        name: name,
        direction: direction,
        width: width,
      ));
      if (!_match(',')) break;
    }
    _expect(';');
    return params;
  }

  List<IrNode> _parseSignalDeclaration() {
    final typeToken = _advance();
    final signalType = switch (typeToken.text) {
      'wire' => SignalType.wire,
      'reg' => SignalType.reg,
      'bit' => SignalType.bit,
      _ => SignalType.logic,
    };
    var isSigned = false;
    while (_check('signed') || _check('unsigned')) {
      if (_check('signed')) isSigned = true;
      _advance();
    }
    VectorWidth? width;
    if (_check('[')) {
      width = _parseVectorWidth();
      while (_check('[')) {
        _skipBrackets();
      }
    }

    final signals = <IrNode>[];
    while (true) {
      final start = _current;
      final name = _expectIdentifier('signal name');
      final unpackedDims = <VectorWidth>[];
      while (_check('[')) {
        unpackedDims.add(_parseVectorWidth());
      }
      IrExpression? initialValue;
      if (_match('=')) {
        initialValue = _parseExpression();
      }
      signals.add(SignalDeclaration(
        location: _loc(start),
        name: name,
        signalType: signalType,
        width: width,
        initialValue: initialValue,
        unpackedDims: unpackedDims,
        isSigned: isSigned,
      ));
      if (!_match(',')) break;
    }
    _expect(';');
    return signals;
  }

  List<IrNode> _parseContinuousAssign() {
    final start = _expect('assign');
    final assigns = <IrNode>[];
    while (true) {
      final target = _parseLValue();
      _expect('=');
      final value = _parseExpression();
      assigns.add(ContinuousAssignment(
        location: _loc(start),
        target: target,
        value: value,
      ));
      if (!_match(',')) break;
    }
    _expect(';');
    return assigns;
  }

  IrNode _parseAlwaysBlock() {
    final start = _advance();
    final keyword = start.text;

    // Every edge-triggered signal in the sensitivity list, in source order.
    final edges = <(String signal, bool negedge)>[];

    if (_match('@')) {
      if (_match('*')) {
        // always @* — combinational
      } else if (_match('(')) {
        if (_match('*')) {
          _expect(')');
        } else {
          while (!_check(')') && !_current.isEof) {
            var edgeNeg = false;
            var edge = false;
            if (_match('posedge')) {
              edge = true;
            } else if (_match('negedge')) {
              edge = true;
              edgeNeg = true;
            }
            final signal = _expectIdentifier('sensitivity signal');
            if (edge) {
              edges.add((signal, edgeNeg));
            }
            if (!_match('or') && !_match(',')) break;
          }
          _expect(')');
        }
      }
    }

    final body = _parseStatement();

    final kind = switch (keyword) {
      'always_ff' => BlockKind.alwaysFf,
      'always_comb' => BlockKind.alwaysComb,
      'always_latch' => BlockKind.alwaysLatch,
      _ => edges.isNotEmpty ? BlockKind.alwaysFf : BlockKind.alwaysComb,
    };

    String? clock;
    var negedge = false;
    String? asyncResetSignal;
    var asyncResetActiveLow = false;

    if (edges.isNotEmpty) {
      // A signal literally named clk/clock is preferred as "the" clock;
      // otherwise the first edge in the list is assumed to be the clock,
      // matching how designs conventionally order sensitivity lists.
      final clockIndex = edges.indexWhere((e) {
        final lower = e.$1.toLowerCase();
        return lower == 'clk' || lower == 'clock';
      });
      final clockEdge = edges[clockIndex >= 0 ? clockIndex : 0];
      clock = clockEdge.$1;
      negedge = clockEdge.$2;

      final resetEdges = edges.where((e) => e.$1 != clockEdge.$1).toList();
      if (resetEdges.isNotEmpty) {
        asyncResetSignal = resetEdges.first.$1;
        asyncResetActiveLow = resetEdges.first.$2;
        if (resetEdges.length > 1) {
          _warn(
            'always block has multiple potential async reset signals in its '
            "sensitivity list; only '${asyncResetSignal}' is treated as an "
            'async reset',
          );
        }
      }
    }

    return AlwaysBlock(
      location: _loc(start),
      kind: kind,
      body: body,
      clock: clock,
      negedgeClock: negedge,
      asyncResetSignal: asyncResetSignal,
      asyncResetActiveLow: asyncResetActiveLow,
    );
  }

  IrNode _parseInstantiation() {
    final start = _current;
    final moduleName = _expectIdentifier('module name');

    final paramValues = <IrExpression>[];
    final paramConnections = <PortConnection>[];
    if (_match('#')) {
      _expect('(');
      while (!_check(')') && !_current.isEof) {
        if (_match('.')) {
          final pname = _expectIdentifier('parameter name');
          _expect('(');
          final value = _check(')') ? null : _parseExpression();
          _expect(')');
          paramConnections.add(PortConnection(
            location: _loc(),
            portName: pname,
            value: value,
          ));
        } else {
          paramValues.add(_parseExpression());
        }
        if (!_match(',')) break;
      }
      _expect(')');
    }

    final instanceName = _expectIdentifier('instance name');
    while (_check('[')) {
      _skipBrackets(); // instance arrays unsupported; dims ignored
    }

    final connections = <PortConnection>[];
    _expect('(');
    var positionalIndex = 0;
    while (!_check(')') && !_current.isEof) {
      if (_match('.')) {
        if (_match('*')) {
          _warn('.* connections are not supported');
        } else {
          final pname = _expectIdentifier('port name');
          IrExpression? value;
          if (_match('(')) {
            if (!_check(')')) value = _parseExpression();
            _expect(')');
          } else {
            // .name shorthand connects to a signal of the same name.
            value = IdentifierExpression(location: _loc(), identifier: pname);
          }
          connections.add(PortConnection(
            location: _loc(),
            portName: pname,
            value: value,
          ));
        }
      } else {
        final value = _parseExpression();
        connections.add(PortConnection(
          location: _loc(),
          portName: r'$pos' '$positionalIndex',
          value: value,
        ));
        positionalIndex++;
      }
      if (!_match(',')) break;
    }
    _expect(')');
    _expect(';');

    return ModuleInstantiation(
      location: _loc(start),
      moduleName: moduleName,
      instanceName: instanceName,
      parameterValues: paramValues,
      parameterConnections: paramConnections,
      portConnections: connections,
    );
  }

  // ── Generate constructs ──────────────────────────────────────────

  List<IrNode> _parseGenerateItem() {
    if (_check('for')) {
      return [_parseForGenerate()];
    }
    if (_check('if')) {
      return [_parseIfGenerate()];
    }
    if (_check('case')) {
      return [_parseCaseGenerate()];
    }
    if (_check('begin')) {
      return [_parseGenerateBlock()];
    }
    if (_check('genvar')) {
      final items = <IrNode>[];
      _advance();
      while (true) {
        final start = _current;
        items.add(GenvarDeclaration(
          location: _loc(start),
          name: _expectIdentifier('genvar name'),
        ));
        if (!_match(',')) break;
      }
      _expect(';');
      return items;
    }
    // Any regular module item is legal inside generate.
    return _parseModuleItems([], []);
  }

  IrNode _parseForGenerate() {
    final start = _expect('for');
    _expect('(');
    _match('genvar');
    final varStart = _current;
    final varName = _expectIdentifier('genvar name');
    _expect('=');
    final init = _parseExpression();
    _expect(';');
    final condition = _parseExpression();
    _expect(';');
    final step = _parseGenvarStep(varName);
    _expect(')');
    final body = _parseGenerateBlock();

    return ForGenerateBlock(
      location: _loc(start),
      initialization: AssignmentStatement(
        location: _loc(varStart),
        target:
            IdentifierExpression(location: _loc(varStart), identifier: varName),
        value: init,
        type: AssignmentType.blocking,
      ),
      condition: condition,
      step: step,
      body: body,
    );
  }

  IrStatement _parseGenvarStep(String varName) {
    final start = _current;
    // Forms: i++, ++i, i = i + 1, i += 1
    if (_match('++')) {
      final name = _expectIdentifier('genvar name');
      return _incrementStatement(name, start);
    }
    final name = _expectIdentifier('genvar name');
    if (_match('++')) {
      return _incrementStatement(name, start);
    }
    if (_match('+=')) {
      final amount = _parseExpression();
      return AssignmentStatement(
        location: _loc(start),
        target: IdentifierExpression(location: _loc(start), identifier: name),
        value: BinaryExpression(
          location: _loc(start),
          left: IdentifierExpression(location: _loc(start), identifier: name),
          right: amount,
          operator: BinaryOperator.add,
        ),
        type: AssignmentType.blocking,
      );
    }
    _expect('=');
    final value = _parseExpression();
    return AssignmentStatement(
      location: _loc(start),
      target: IdentifierExpression(location: _loc(start), identifier: name),
      value: value,
      type: AssignmentType.blocking,
    );
  }

  IrStatement _incrementStatement(String name, SvToken start) {
    return AssignmentStatement(
      location: _loc(start),
      target: IdentifierExpression(location: _loc(start), identifier: name),
      value: BinaryExpression(
        location: _loc(start),
        left: IdentifierExpression(location: _loc(start), identifier: name),
        right: LiteralExpression(
          location: _loc(start),
          kind: LiteralKind.integer,
          value: 1,
        ),
        operator: BinaryOperator.add,
      ),
      type: AssignmentType.blocking,
    );
  }

  IrNode _parseIfGenerate() {
    final start = _expect('if');
    _expect('(');
    final condition = _parseExpression();
    _expect(')');
    final thenBranch = _parseGenerateBlock();
    GenerateBlock? elseBranch;
    if (_match('else')) {
      if (_check('if')) {
        final nested = _parseIfGenerate();
        elseBranch = GenerateBlock(
          location: _loc(start),
          items: [nested],
          kind: GenerateKind.ifGenerate,
        );
      } else {
        elseBranch = _parseGenerateBlock();
      }
    }
    return IfGenerateBlock(
      location: _loc(start),
      condition: condition,
      thenBranch: thenBranch,
      elseBranch: elseBranch,
    );
  }

  IrNode _parseCaseGenerate() {
    final start = _expect('case');
    _expect('(');
    final expression = _parseExpression();
    _expect(')');

    final items = <GenerateCaseItem>[];
    while (!_check('endcase') && !_current.isEof) {
      final itemStart = _current;
      final values = <IrExpression>[];
      if (_match('default')) {
        _match(':');
        // An empty `values` list marks the default branch.
      } else {
        values.add(_parseExpression());
        while (_match(',')) {
          values.add(_parseExpression());
        }
        _expect(':');
      }
      final body = _parseGenerateBlock();
      items.add(GenerateCaseItem(
        location: _loc(itemStart),
        values: values,
        body: body,
      ));
    }
    _expect('endcase');

    return CaseGenerateBlock(
      location: _loc(start),
      expression: expression,
      items: items,
    );
  }

  GenerateBlock _parseGenerateBlock() {
    final start = _current;
    String? label;
    final items = <IrNode>[];
    if (_match('begin')) {
      if (_match(':')) {
        label = _expectIdentifier('block label');
      }
      while (!_check('end') && !_current.isEof) {
        items.addAll(_parseGenerateItem());
      }
      _expect('end');
      if (_match(':')) {
        _expectIdentifier('block label');
      }
    } else {
      items.addAll(_parseGenerateItem());
    }
    return GenerateBlock(
      location: _loc(start),
      label: label,
      items: items,
    );
  }

  // ── Statements ───────────────────────────────────────────────────

  IrStatement _parseStatement() {
    final start = _current;

    if (_check('begin')) {
      _advance();
      String? label;
      if (_match(':')) {
        label = _expectIdentifier('block label');
      }
      final statements = <IrStatement>[];
      while (!_check('end') && !_current.isEof) {
        statements.add(_parseStatement());
      }
      _expect('end');
      if (_match(':')) {
        _expectIdentifier('block label');
      }
      return SequentialBlock(
        location: _loc(start),
        label: label,
        statements: statements,
      );
    }

    if (_check('return')) {
      _advance();
      IrExpression? value;
      if (!_check(';')) {
        value = _parseExpression();
      }
      _expect(';');
      return ReturnStatement(location: _loc(start), value: value);
    }

    if (_check('unique') || _check('priority')) {
      _advance();
    }

    if (_check('if')) {
      _expect('if');
      _expect('(');
      final condition = _parseExpression();
      _expect(')');
      final thenBranch = _parseStatement();
      IrStatement? elseBranch;
      if (_match('else')) {
        elseBranch = _parseStatement();
      }
      return IfStatement(
        location: _loc(start),
        condition: condition,
        thenBranch: thenBranch,
        elseBranch: elseBranch,
      );
    }

    if (_check('case') || _check('casez') || _check('casex')) {
      return _parseCaseStatement();
    }

    if (_check('for')) {
      _advance();
      _expect('(');
      IrStatement? init;
      if (!_check(';')) {
        _match('int');
        _match('integer');
        init = _parseSimpleAssignmentStatement();
      }
      _expect(';');
      IrExpression? condition;
      if (!_check(';')) {
        condition = _parseExpression();
      }
      _expect(';');
      IrStatement? step;
      if (!_check(')')) {
        step = _parseGenvarStep('_i');
      }
      _expect(')');
      final body = _parseStatement();
      return ForLoopStatement(
        location: _loc(start),
        initialization: init,
        condition: condition,
        step: step,
        body: body,
      );
    }

    if (_check('while')) {
      _advance();
      _expect('(');
      final condition = _parseExpression();
      _expect(')');
      final body = _parseStatement();
      return WhileLoopStatement(
        location: _loc(start),
        condition: condition,
        body: body,
      );
    }

    if (_check('repeat')) {
      _advance();
      _expect('(');
      final count = _parseExpression();
      _expect(')');
      final body = _parseStatement();
      return RepeatLoopStatement(
        location: _loc(start),
        count: count,
        body: body,
      );
    }

    if (_check(';')) {
      _advance();
      return EmptyStatement(location: _loc(start));
    }

    if (_check('#')) {
      _advance();
      IrExpression? delay;
      if (_current.type == SvTokenType.number) {
        delay = _parsePrimary();
      }
      // A delayed statement may follow; parse and discard the delay.
      if (!_check(';')) {
        return _parseStatement();
      }
      _expect(';');
      return DelayStatement(location: _loc(start), delay: delay);
    }

    if (_current.type == SvTokenType.systemIdentifier) {
      // System task call, e.g. $display(...);
      _advance();
      if (_check('(')) {
        _skipParens();
      }
      _expect(';');
      return EmptyStatement(location: _loc(start));
    }

    // Assignment statement.
    final stmt = _parseSimpleAssignmentStatement();
    _expect(';');
    return stmt;
  }

  /// Parses an assignment target: an identifier with optional selects, or a
  /// concatenation. Deliberately not a full expression so that the `<=` of a
  /// non-blocking assignment is not consumed as a comparison.
  IrExpression _parseLValue() {
    if (_check('{')) {
      return _parseConcatenation();
    }
    final start = _current;
    final name = _expectIdentifier('assignment target');
    IrExpression expr =
        IdentifierExpression(location: _loc(start), identifier: name);
    while (_check('[')) {
      final selStart = _current;
      _advance();
      final first = _parseExpression();
      if (_match(':')) {
        final lsb = _parseExpression();
        _expect(']');
        expr = PartSelectExpression(
          location: _loc(selStart),
          base: expr,
          msb: first,
          lsb: lsb,
        );
      } else {
        _expect(']');
        expr = IndexedPartSelectExpression(
          location: _loc(selStart),
          base: expr,
          index: first,
        );
      }
    }
    return expr;
  }

  IrStatement _parseSimpleAssignmentStatement() {
    final start = _current;
    final target = _parseLValue();
    if (_match('<=')) {
      final value = _parseExpression();
      return AssignmentStatement(
        location: _loc(start),
        target: target,
        value: value,
        type: AssignmentType.nonBlocking,
      );
    }
    if (_match('=')) {
      final value = _parseExpression();
      return AssignmentStatement(
        location: _loc(start),
        target: target,
        value: value,
        type: AssignmentType.blocking,
      );
    }
    if (_match('++')) {
      return AssignmentStatement(
        location: _loc(start),
        target: target,
        value: BinaryExpression(
          location: _loc(start),
          left: target,
          right: LiteralExpression(
            location: _loc(start),
            kind: LiteralKind.integer,
            value: 1,
          ),
          operator: BinaryOperator.add,
        ),
        type: AssignmentType.blocking,
      );
    }
    _error("expected assignment but found '${_current.text}'");
    return EmptyStatement(location: _loc(start));
  }

  IrStatement _parseCaseStatement() {
    final start = _advance();
    final kind = switch (start.text) {
      'casez' => CaseKind.z,
      'casex' => CaseKind.x,
      _ => CaseKind.normal,
    };
    _expect('(');
    final expression = _parseExpression();
    _expect(')');

    final items = <CaseItem>[];
    IrStatement? defaultCase;
    while (!_check('endcase') && !_current.isEof) {
      if (_match('default')) {
        _match(':');
        defaultCase = _parseStatement();
        continue;
      }
      final itemStart = _current;
      final values = <IrExpression>[_parseExpression()];
      while (_match(',')) {
        values.add(_parseExpression());
      }
      _expect(':');
      final statement = _parseStatement();
      items.add(CaseItem(
        location: _loc(itemStart),
        values: values,
        statement: statement,
      ));
    }
    _expect('endcase');

    return CaseStatement(
      location: _loc(start),
      expression: expression,
      items: items,
      kind: kind,
      defaultCase: defaultCase,
    );
  }

  // ── Expressions ──────────────────────────────────────────────────

  IrExpression _parseExpression() => _parseConditional();

  IrExpression _parseConditional() {
    final condition = _parseLogicalOr();
    if (_match('?')) {
      final trueExpr = _parseExpression();
      _expect(':');
      final falseExpr = _parseExpression();
      return ConditionalExpression(
        location: condition.location,
        condition: condition,
        trueExpr: trueExpr,
        falseExpr: falseExpr,
      );
    }
    return condition;
  }

  IrExpression _parseLogicalOr() {
    var left = _parseLogicalAnd();
    while (_match('||')) {
      final right = _parseLogicalAnd();
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: BinaryOperator.logicalOr,
      );
    }
    return left;
  }

  IrExpression _parseLogicalAnd() {
    var left = _parseBitwiseOr();
    while (_match('&&')) {
      final right = _parseBitwiseOr();
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: BinaryOperator.logicalAnd,
      );
    }
    return left;
  }

  IrExpression _parseBitwiseOr() {
    var left = _parseBitwiseXor();
    while (_check('|') && !_check('||')) {
      _advance();
      final right = _parseBitwiseXor();
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: BinaryOperator.or,
      );
    }
    return left;
  }

  IrExpression _parseBitwiseXor() {
    var left = _parseBitwiseAnd();
    while (_check('^') || _check('~^') || _check('^~')) {
      final op = _advance().text;
      final right = _parseBitwiseAnd();
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: op == '^' ? BinaryOperator.xor : BinaryOperator.xnor,
      );
    }
    return left;
  }

  IrExpression _parseBitwiseAnd() {
    var left = _parseEquality();
    while (_check('&') && !_check('&&')) {
      _advance();
      final right = _parseEquality();
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: BinaryOperator.and,
      );
    }
    return left;
  }

  IrExpression _parseEquality() {
    var left = _parseRelational();
    while (_check('==') ||
        _check('!=') ||
        _check('===') ||
        _check('!==') ||
        _check('==?') ||
        _check('!=?')) {
      final op = _advance().text;
      final right = _parseRelational();
      final operator = switch (op) {
        '==' || '==?' => BinaryOperator.equal,
        '===' => BinaryOperator.caseEqual,
        '!==' => BinaryOperator.caseNotEqual,
        _ => BinaryOperator.notEqual,
      };
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: operator,
      );
    }
    return left;
  }

  IrExpression _parseRelational() {
    var left = _parseShift();
    while (_check('<') || _check('>') || _check('<=') || _check('>=')) {
      final op = _advance().text;
      final right = _parseShift();
      final operator = switch (op) {
        '<' => BinaryOperator.lessThan,
        '<=' => BinaryOperator.lessThanOrEqual,
        '>' => BinaryOperator.greaterThan,
        _ => BinaryOperator.greaterThanOrEqual,
      };
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: operator,
      );
    }
    return left;
  }

  IrExpression _parseShift() {
    var left = _parseAdditive();
    while (_check('<<') || _check('>>') || _check('<<<') || _check('>>>')) {
      final op = _advance().text;
      final right = _parseAdditive();
      final operator = switch (op) {
        '<<' => BinaryOperator.shiftLeft,
        '>>' => BinaryOperator.shiftRight,
        '<<<' => BinaryOperator.arithmeticShiftLeft,
        _ => BinaryOperator.arithmeticShiftRight,
      };
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: operator,
      );
    }
    return left;
  }

  IrExpression _parseAdditive() {
    var left = _parseMultiplicative();
    while (_check('+') || _check('-')) {
      final op = _advance().text;
      final right = _parseMultiplicative();
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: op == '+' ? BinaryOperator.add : BinaryOperator.subtract,
      );
    }
    return left;
  }

  IrExpression _parseMultiplicative() {
    var left = _parseUnary();
    while (_check('*') || _check('/') || _check('%')) {
      final op = _advance().text;
      final right = _parseUnary();
      final operator = switch (op) {
        '*' => BinaryOperator.multiply,
        '/' => BinaryOperator.divide,
        _ => BinaryOperator.modulo,
      };
      left = BinaryExpression(
        location: left.location,
        left: left,
        right: right,
        operator: operator,
      );
    }
    return left;
  }

  IrExpression _parseUnary() {
    final start = _current;
    if (_match('!')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.logicalNot,
      );
    }
    if (_match('~')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.bitwiseNot,
      );
    }
    if (_match('-')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.minus,
      );
    }
    if (_match('+')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.plus,
      );
    }
    if (_match('&')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.reductionAnd,
      );
    }
    if (_match('|')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.reductionOr,
      );
    }
    if (_match('^')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.reductionXor,
      );
    }
    if (_match('~&')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.reductionNand,
      );
    }
    if (_match('~|')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.reductionNor,
      );
    }
    if (_match('~^') || _match('^~')) {
      return UnaryExpression(
        location: _loc(start),
        operand: _parseUnary(),
        operator: UnaryOperator.reductionXnor,
      );
    }
    return _parsePostfix();
  }

  IrExpression _parsePostfix() {
    var expr = _parsePrimary();
    while (true) {
      if (_check('[')) {
        final start = _current;
        _advance();
        final first = _parseExpression();
        if (_match(':')) {
          final lsb = _parseExpression();
          _expect(']');
          expr = PartSelectExpression(
            location: _loc(start),
            base: expr,
            msb: first,
            lsb: lsb,
          );
        } else if (_match('+:') || _match('-:')) {
          // Indexed part select base[start +: width]; approximate with a
          // plain part select using the width expression only.
          final width = _parseExpression();
          _expect(']');
          expr = PartSelectExpression(
            location: _loc(start),
            base: expr,
            msb: BinaryExpression(
              location: _loc(start),
              left: BinaryExpression(
                location: _loc(start),
                left: first,
                right: width,
                operator: BinaryOperator.add,
              ),
              right: LiteralExpression(
                location: _loc(start),
                kind: LiteralKind.integer,
                value: 1,
              ),
              operator: BinaryOperator.subtract,
            ),
            lsb: first,
          );
        } else {
          _expect(']');
          expr = IndexedPartSelectExpression(
            location: _loc(start),
            base: expr,
            index: first,
          );
        }
        continue;
      }
      if (_check("'") && _peek().text == '(') {
        // Size cast such as WIDTH'(1): the value keeps its expression, the
        // cast width is contextual and handled by width fitting later.
        _advance();
        _advance();
        final inner = _parseExpression();
        _expect(')');
        expr = inner;
        continue;
      }
      break;
    }
    return expr;
  }

  IrExpression _parsePrimary() {
    final start = _current;

    if (_current.type == SvTokenType.number) {
      _advance();
      return _literalFromText(start);
    }

    if (_current.type == SvTokenType.string) {
      _advance();
      final text = start.text;
      return LiteralExpression(
        location: _loc(start),
        kind: LiteralKind.string,
        value: text.length >= 2 ? text.substring(1, text.length - 1) : '',
      );
    }

    if (_current.type == SvTokenType.systemIdentifier) {
      final name = _advance().text;
      final args = <IrExpression>[];
      if (_match('(')) {
        while (!_check(')') && !_current.isEof) {
          args.add(_parseExpression());
          if (!_match(',')) break;
        }
        _expect(')');
      }
      return FunctionCallExpression(
        location: _loc(start),
        functionName: name,
        arguments: args,
      );
    }

    if (_match('(')) {
      final inner = _parseExpression();
      _expect(')');
      return inner;
    }

    if (_check('{')) {
      return _parseConcatenation();
    }

    if (_checkIdentifier()) {
      final name = _advance().text;
      if (_check('(')) {
        // Function call
        _advance();
        final args = <IrExpression>[];
        while (!_check(')') && !_current.isEof) {
          args.add(_parseExpression());
          if (!_match(',')) break;
        }
        _expect(')');
        return FunctionCallExpression(
          location: _loc(start),
          functionName: name,
          arguments: args,
        );
      }
      return IdentifierExpression(location: _loc(start), identifier: name);
    }

    _error("unexpected token '${_current.text}' in expression");
    _advance();
    return LiteralExpression(
      location: _loc(start),
      kind: LiteralKind.integer,
      value: 0,
    );
  }

  IrExpression _parseConcatenation() {
    final start = _expect('{');
    final first = _parseExpression();

    // Replication: {count{expr}}
    if (_check('{')) {
      _advance();
      final parts = <IrExpression>[_parseExpression()];
      while (_match(',')) {
        parts.add(_parseExpression());
      }
      _expect('}');
      _expect('}');
      final operand = parts.length == 1
          ? parts.first
          : ConcatenationExpression(location: _loc(start), expressions: parts);
      return ReplicationExpression(
        location: _loc(start),
        count: first,
        operand: operand,
      );
    }

    final parts = <IrExpression>[first];
    while (_match(',')) {
      parts.add(_parseExpression());
    }
    _expect('}');
    if (parts.length == 1) return parts.first;
    return ConcatenationExpression(location: _loc(start), expressions: parts);
  }

  LiteralExpression _literalFromText(SvToken token) {
    final text = token.text.replaceAll('_', '');

    // Unbased unsized literals.
    if (text == "'0") {
      return LiteralExpression(
        location: _loc(token),
        kind: LiteralKind.integer,
        value: 0,
      );
    }
    if (text == "'1") {
      // All ones: -1 maps onto an all-ones constant of contextual width.
      return LiteralExpression(
        location: _loc(token),
        kind: LiteralKind.bitVector,
        value: -1,
      );
    }
    if (text == "'x" || text == "'X" || text == "'z" || text == "'Z") {
      _warn("x/z literal '$text' converted to 0");
      return LiteralExpression(
        location: _loc(token),
        kind: LiteralKind.integer,
        value: 0,
      );
    }

    final tickIndex = text.indexOf("'");
    if (tickIndex < 0) {
      return LiteralExpression(
        location: _loc(token),
        kind: LiteralKind.integer,
        value: int.tryParse(text) ?? 0,
      );
    }

    final sizeText = text.substring(0, tickIndex);
    var rest = text.substring(tickIndex + 1);
    if (rest.startsWith('s') || rest.startsWith('S')) {
      rest = rest.substring(1);
    }
    final baseChar = rest.isNotEmpty ? rest[0].toLowerCase() : 'd';
    final rawDigits = rest.length > 1 ? rest.substring(1) : '';

    final radix = switch (baseChar) {
      'b' => 2,
      'o' => 8,
      'h' => 16,
      _ => 10,
    };
    final width = sizeText.isNotEmpty ? int.tryParse(sizeText) : null;

    String? wildcardBits;
    var valueText = rawDigits;
    if (rawDigits.contains(RegExp('[xXzZ?]'))) {
      if (width != null) {
        wildcardBits = _expandToBitString(rawDigits, radix, width);
      }
      if (wildcardBits == null) {
        _warn("x/z digits in '${token.text}' converted to 0");
      }
      valueText = rawDigits.replaceAll(RegExp('[xXzZ?]'), '0');
    }

    final value = int.tryParse(valueText, radix: radix) ?? 0;

    return LiteralExpression(
      location: _loc(token),
      kind: LiteralKind.bitVector,
      value: value,
      width: width,
      wildcardBits: wildcardBits,
    );
  }

  /// Expands [digits] (in the given [radix]: 2, 8, or 16) into an MSB-first
  /// four-state bit string of exactly [width] bits, treating `x`/`z`/`?`
  /// digits as fully unknown/wildcard across all bits they represent (e.g.
  /// a single `z` hex digit becomes `zzzz`). Returns null when the radix
  /// can't be expanded per-bit (decimal) or a digit is invalid.
  String? _expandToBitString(String digits, int radix, int width) {
    final bitsPerDigit = switch (radix) {
      2 => 1,
      8 => 3,
      16 => 4,
      _ => 0,
    };
    if (bitsPerDigit == 0) return null;

    final buffer = StringBuffer();
    for (final ch in digits.split('')) {
      final lower = ch.toLowerCase();
      if (lower == 'x') {
        buffer.write('x' * bitsPerDigit);
        continue;
      }
      if (lower == 'z' || lower == '?') {
        buffer.write('z' * bitsPerDigit);
        continue;
      }
      final digitValue = int.tryParse(ch, radix: radix);
      if (digitValue == null) return null;
      buffer.write(digitValue.toRadixString(2).padLeft(bitsPerDigit, '0'));
    }

    var bits = buffer.toString();
    if (bits.length < width) {
      bits = bits.padLeft(width, '0');
    } else if (bits.length > width) {
      bits = bits.substring(bits.length - width);
    }
    return bits;
  }

  // ── Recovery helpers ─────────────────────────────────────────────

  void _skipPast(String text) {
    while (!_current.isEof && !_check(text)) {
      _advance();
    }
    _match(text);
  }

  void _skipToMatching(String open, String close) {
    var depth = 0;
    while (!_current.isEof) {
      if (_check(open)) depth++;
      if (_check(close)) {
        depth--;
        _advance();
        if (depth <= 0) return;
        continue;
      }
      _advance();
    }
  }

  void _skipParens() {
    _expect('(');
    var depth = 1;
    while (depth > 0 && !_current.isEof) {
      if (_check('(')) depth++;
      if (_check(')')) depth--;
      _advance();
    }
  }
}
