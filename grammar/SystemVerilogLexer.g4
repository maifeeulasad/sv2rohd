// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

/*
  SystemVerilog Parser Grammar for SV2ROHD

  This grammar targets the synthesizable subset of IEEE 1800-2017 SystemVerilog.
  Grammar is designed to be compatible with ANTLR4 and the antlr4dart runtime.
  ref:
    - https://rfsoc.mit.edu/6S965/_static/F25/documentation/1800-2017.pdf
    - https://ece.uah.edu/~gaede/cpe526/2012%20System%20Verilog%20Language%20Reference%20Manual.pdf
*/

// SystemVerilog Lexer Grammar (IEEE 1800-2017 LRM, Annex A)
// Companion: SystemVerilogParser.g4
//
// Layout
//   §1  Skipped channels
//   §2  String & DPI literals
//   §3  Operators & punctuation
//   §4  Number bases & digit tokens     (A.8.7 – kept here so parser is literal-free)
//   §5  Keywords                        (grouped by domain, α-sorted within each group)
//   §6  Identifiers                     (must follow all keyword rules)

lexer grammar SystemVerilogLexer;


// ════════════════════════════════════════════════════════════════
// §1  SKIPPED CHANNELS
// ════════════════════════════════════════════════════════════════

BlockComment : '/*' .*? '*/'   -> skip;
LineComment  : '//' ~[\r\n]*   -> skip;
WhiteSpace   : [ \t\r\n]+      -> skip;


// ════════════════════════════════════════════════════════════════
// §2  STRING & DPI LITERALS
// ════════════════════════════════════════════════════════════════

// §2.1  String literal (A.8.8)
StringLiteral : '"' ( '\\' . | ~[\\"] )* '"';

// §2.2  DPI spec strings  (more-specific double-quoted forms; ANTLR longest-match wins)
TDPIC : '"DPI-C"';
TDPI  : '"DPI"';


// ════════════════════════════════════════════════════════════════
// §3  OPERATORS & PUNCTUATION
// Within each sub-group: longest token first so ANTLR maximal-munch
// never splits '<<=' into '<<' + '='.
// ════════════════════════════════════════════════════════════════

// §3.1  Attribute delimiters
AttrEnd   : '*)';
AttrStart : '(*';

// §3.2  Arithmetic
OpAdd : '+';
OpDiv : '/';
OpMod : '%';
OpMul : '*';
OpPow : '**';
OpSub : '-';

// §3.3  Increment / decrement
OpDec : '--';
OpInc : '++';

// §3.4  Relational  (longer tokens first)
OpCaseEq : '===';
OpCaseNe : '!==';
OpGe     : '>=';
OpLe     : '<=';
OpEq     : '==';
OpNe     : '!=';
OpWildEq : '==?';
OpWildNe : '!=?';
OpGt     : '>';
OpLt     : '<';

// §3.5  Logical
OpLogAnd : '&&';
OpLogNot : '!';
OpLogOr  : '||';

// §3.6  Bitwise  (longer tokens first to avoid '~^' matching '~' + '^')
OpBitAnd  : '&';
OpBitNot  : '~';
OpBitOr   : '|';
OpBitXor  : '^';
OpNand    : '~&';
OpNor     : '~|';
OpXnor    : '^~';
OpXnorAlt : '~^';

// §3.7  Shift  (longer tokens first)
OpArithShl : '<<<';
OpArithShr : '>>>';
OpShl      : '<<';
OpShr      : '>>';

// §3.8  Compound assignment  (longest first within each leading character)
OpAddAssign      : '+=';
OpAndAssign      : '&=';
OpArithShlAssign : '<<<=';
OpArithShrAssign : '>>>=';
OpAssign         : '=';
OpDivAssign      : '/=';
OpModAssign      : '%=';
OpMulAssign      : '*=';
OpOrAssign       : '|=';
OpShlAssign      : '<<=';
OpShrAssign      : '>>=';
OpSubAssign      : '-=';
OpXorAssign      : '^=';

// §3.9  Non-blocking assignment (same characters as OpLe; named separately for clarity)
OpNBA : '<=';

// §3.10  Property / sequence operators  (longer / more-specific first)
OpEquiv          : '<->';
OpFollowedBy     : '#-#';
OpFollowedByNO   : '#=#';
OpImplication    : '->';
OpNonOverlapImpl : '|=>';
OpNonOverlapSeq  : '->>';
OpOverlapImpl    : '|->';

// §3.11  Sequence repetition tokens  (longer / more-specific first)
RepConsecOpen    : '[*';
RepGotoOpen      : '[->';
RepNonConsecOpen : '[=';
RepeatPlus       : '[+]';
RepeatStar       : '[*]';
SeqDelay         : '##';
SeqDelayAny      : '##[*]';
SeqDelayPlus     : '##[+]';

// §3.12  Casting / assignment-pattern tick
Tick : '\'';

// §3.13  Scope & hierarchy
DotOp   : '.';
DotStar : '.*';
ScopeOp : '::';

// §3.14  Miscellaneous punctuation  (α-sorted by token name)
At           : '@';
Colon        : ':';
Comma        : ',';
Dollar       : '$';
Hash         : '#';
LBrace       : '{';
LBracket     : '[';
LParen       : '(';
QuestionMark : '?';
RBrace       : '}';
RBracket     : ']';
RParen       : ')';
Semi         : ';';


// ════════════════════════════════════════════════════════════════
// §4  NUMBER BASES & DIGIT TOKENS  (A.8.7)
// Kept in the lexer so the parser contains no raw character literals.
// ════════════════════════════════════════════════════════════════

// §4.1  Sized-literal base tokens  (α-sorted)
BinBase : '\'' [sS]? [bB];
DecBase : '\'' [sS]? [dD];
HexBase : '\'' [sS]? [hH];
OctBase : '\'' [sS]? [oO];

// §4.2  Unsized literals
UnbasedOne  : '\'1';
UnbasedZero : '\'0';
// '\'z / \'x / \'Z / \'X' → produced by Tick + z/x digit tokens below

// §4.3  Individual digit characters  (needed for digit-sequence parser rules)
Digit0 : '0';
Digit1 : '1';
Digit2 : '2';
Digit3 : '3';
Digit4 : '4';
Digit5 : '5';
Digit6 : '6';
Digit7 : '7';
Digit8 : '8';
Digit9 : '9';

HexDigitLower : [a-f];
HexDigitUpper : [A-F];

XDigitLower : 'x';
XDigitUpper : 'X';
ZDigitLower : 'z';
ZDigitUpper : 'Z';

// §4.4  Auxiliary characters for real-number / digit-sequence rules
ExpLower   : 'e';
ExpUpper   : 'E';
Underscore : '_';


// ════════════════════════════════════════════════════════════════
// §5  KEYWORDS
//
// Grouped by semantic domain; α-sorted within each group.
// Longer keywords MUST precede any keyword that is their prefix
//   (e.g. always_comb before always, endmodule before end).
// ════════════════════════════════════════════════════════════════

// ── §5.1  Top-level structure ────────────────────────────────────
TChecker      : 'checker';
TClass        : 'class';
TConfig       : 'config';
TEndchecker   : 'endchecker';
TEndclass     : 'endclass';
TEndconfig    : 'endconfig';
TEndgenerate  : 'endgenerate';
TEndgroup     : 'endgroup';
TEndinterface : 'endinterface';
Tendmodule    : 'endmodule';
TEndpackage   : 'endpackage';
TEndprimitive : 'endprimitive';
TEndprogram   : 'endprogram';
TEndproperty  : 'endproperty';
TEndsequence  : 'endsequence';
TEndspecify   : 'endspecify';
TEndtable     : 'endtable';
TGenerate     : 'generate';
TInterface    : 'interface';
TMacromodule  : 'macromodule';
TModule       : 'module';
TPackage      : 'package';
TPrimitive    : 'primitive';
TProgram      : 'program';

// ── §5.2  Declarations & lifetime ───────────────────────────────
TAutomatic  : 'automatic';
TBind       : 'bind';
TCell       : 'cell';
TConst      : 'const';
TDesign     : 'design';
TExport     : 'export';
TExtern     : 'extern';
TGenvar     : 'genvar';
TGlobal     : 'global';
TImport     : 'import';
TIncdir     : 'incdir';
TInclude    : 'include';
TInstance   : 'instance';
TLiblist    : 'liblist';
TLibrary    : 'library';
TLocal      : 'local';
TLocalparam : 'localparam';
TNettype    : 'nettype';
TParameter  : 'parameter';
TSpecparam  : 'specparam';
TStatic     : 'static';
TTypedef    : 'typedef';
TUse        : 'use';
TVar        : 'var';

// ── §5.3  Data types ─────────────────────────────────────────────
TBit        : 'bit';
TByte       : 'byte';
TChandle    : 'chandle';
TEnum       : 'enum';
TEvent      : 'event';
TInt        : 'int';
TInteger    : 'integer';
TLogic      : 'logic';
TLongint    : 'longint';
TPacked     : 'packed';
TReal       : 'real';
TRealtime   : 'realtime';
TReg        : 'reg';
TShortint   : 'shortint';
TShortreal  : 'shortreal';
TSigned     : 'signed';
TString     : 'string';
TStruct     : 'struct';
TTime       : 'time';
TTypeOption : 'type_option';
TType       : 'type';
TUnion      : 'union';
TUnsigned   : 'unsigned';
TVoid       : 'void';

// ── §5.4  Net types ──────────────────────────────────────────────
// (tri0/tri1/triand/trior/trireg before tri to prevent prefix clash)
TInterconnect : 'interconnect';
TSupply0      : 'supply0';
TSupply1      : 'supply1';
TTri0         : 'tri0';
TTri1         : 'tri1';
TTriand       : 'triand';
TTrior        : 'trior';
TTrireg       : 'trireg';
TTri          : 'tri';
TUwire        : 'uwire';
TWand         : 'wand';
TWire         : 'wire';
TWor          : 'wor';

// ── §5.5  Drive & charge strengths ──────────────────────────────
THighz0   : 'highz0';
THighz1   : 'highz1';
TLarge    : 'large';
TMedium   : 'medium';
TPull0    : 'pull0';
TPull1    : 'pull1';
TPulldown : 'pulldown';
TPullup   : 'pullup';
TScalared : 'scalared';
TSmall    : 'small';
TStrong0  : 'strong0';
TStrong1  : 'strong1';
TStrong   : 'strong';
TVectored : 'vectored';
TWeak0    : 'weak0';
TWeak1    : 'weak1';
TWeak     : 'weak';

// ── §5.6  Gate-level primitives ──────────────────────────────────
// (bufif0/bufif1 before buf; notif0/notif1 before not; rtranif* before rtran; tranif* before tran)
TBufif0   : 'bufif0';
TBufif1   : 'bufif1';
TBuf      : 'buf';
TCmos     : 'cmos';
TNand     : 'nand';
TNmos     : 'nmos';
TNor      : 'nor';
TNotif0   : 'notif0';
TNotif1   : 'notif1';
TNot      : 'not';
TPmos     : 'pmos';
TRcmos    : 'rcmos';
TRnmos    : 'rnmos';
TRpmos    : 'rpmos';
TRtranif0 : 'rtranif0';
TRtranif1 : 'rtranif1';
TRtran    : 'rtran';
TTranif0  : 'tranif0';
TTranif1  : 'tranif1';
TTran     : 'tran';

// ── §5.7  Procedural & behavioral ───────────────────────────────
// (always_* before always; endfunction/endtask before end; forkjoin before fork; foreach/forever before for)
TAlias       : 'alias';
TAlwaysComb  : 'always_comb';
TAlwaysFF    : 'always_ff';
TAlwaysLatch : 'always_latch';
TAlways      : 'always';
TAssign      : 'assign';
TBegin       : 'begin';
TBreak       : 'break';
TContinue    : 'continue';
TDeassign    : 'deassign';
TDefault     : 'default';
TDefparam    : 'defparam';
TDisable     : 'disable';
TDo          : 'do';
TEndfunction : 'endfunction';
TEndtask     : 'endtask';
TEnd         : 'end';
TFinal       : 'final';
TForeach     : 'foreach';
TForever     : 'forever';
TForkjoin    : 'forkjoin';
TFor         : 'for';
TForce       : 'force';
TFork        : 'fork';
TFunction    : 'function';
TIf          : 'if';
TInitial     : 'initial';
TJoinAny     : 'join_any';
TJoinNone    : 'join_none';
TJoin        : 'join';
TRelease     : 'release';
TRepeat      : 'repeat';
TReturn      : 'return';
TTask        : 'task';
TWhile       : 'while';

// ── §5.8  Port & direction ───────────────────────────────────────
TInout   : 'inout';
TInput   : 'input';
TModport : 'modport';
TOutput  : 'output';
TRef     : 'ref';

// ── §5.9  Class & OOP ────────────────────────────────────────────
TExtends    : 'extends';
TImplements : 'implements';
TNew        : 'new';
TNull       : 'null';
TProtected  : 'protected';
TPure       : 'pure';
TSuper      : 'super';
TThis       : 'this';
TVirtual    : 'virtual';

// ── §5.10  Randomization & constraints ──────────────────────────
TBefore       : 'before';
TConstraint   : 'constraint';
TDist         : 'dist';
TRandc        : 'randc';
TRandcase     : 'randcase';
TRandsequence : 'randsequence';
TRandomize    : 'randomize';
TRand         : 'rand';
TSoft         : 'soft';
TSolve        : 'solve';
TUnique0      : 'unique0';
TUnique       : 'unique';

// ── §5.11  Assertions & properties ──────────────────────────────
// (s_until_with before s_until; sync_* before their roots)
TAcceptOn     : 'accept_on';
TAssert       : 'assert';
TAssume       : 'assume';
TCovergroup   : 'covergroup';
TCoverpoint   : 'coverpoint';
TCover        : 'cover';
TCross        : 'cross';
TEventually   : 'eventually';
TExpect       : 'expect';
TFirstMatch   : 'first_match';
TNexttime     : 'nexttime';
TRejectOn     : 'reject_on';
TRestrict     : 'restrict';
TSAlways      : 's_always';
TSEventually  : 's_eventually';
TSNexttime    : 's_nexttime';
TSUntilWith   : 's_until_with';
TSUntil       : 's_until';
TSequence     : 'sequence';
TSyncAcceptOn : 'sync_accept_on';
TSyncRejectOn : 'sync_reject_on';
TUntilWith    : 'until_with';
TUntil        : 'until';
TUntyped      : 'untyped';
TWithin       : 'within';

// ── §5.12  Clocking ──────────────────────────────────────────────
TClocking    : 'clocking';
TEndclocking : 'endclocking';

// ── §5.13  Coverage bins ─────────────────────────────────────────
// (binsof before bins; ignore_bins/illegal_bins before bins)
TBinsOf      : 'binsof';
TBins        : 'bins';
TIgnoreBins  : 'ignore_bins';
TIllegalBins : 'illegal_bins';
TOption      : 'option';
TSample      : 'sample';
TWildcard    : 'wildcard';

// ── §5.14  Timing & specify ──────────────────────────────────────
// (timeprecision before timeunit since they share no common prefix issue, but keep long ones first)
T1step              : '1step';
TEdge               : 'edge';
TNegedge            : 'negedge';
TNoshowcancelled    : 'noshowcancelled';
TPathpulse          : 'PATHPULSE$';
TPosedge            : 'posedge';
TPulsestyleOndetect : 'pulsestyle_ondetect';
TPulsestyleOnevent  : 'pulsestyle_onevent';
TShowcancelled      : 'showcancelled';
TSpecify            : 'specify';
TTimeprecision      : 'timeprecision';
TTimeunit           : 'timeunit';

// ── §5.15  Miscellaneous / shared keywords ───────────────────────
// (casex/casez before case; endcase is separate)
TAnd        : 'and';
TCasex      : 'casex';
TCasez      : 'casez';
TCase       : 'case';
TContext    : 'context';
TElse       : 'else';
TEndcase    : 'endcase';
TIff        : 'iff';
TIfnone     : 'ifnone';
TImplies    : 'implies';
TInside     : 'inside';
TIntersect  : 'intersect';
TLet        : 'let';
TMatches    : 'matches';
TOr         : 'or';
TPriority   : 'priority';
TProperty   : 'property';
TTable      : 'table';
TTagged     : 'tagged';
TThroughout : 'throughout';
TWith       : 'with';
TXnor       : 'xnor';
TXor        : 'xor';


// ════════════════════════════════════════════════════════════════
// §6  IDENTIFIERS
// Must appear AFTER all keyword rules; rule-order priority lets
// keywords win over the general identifier patterns.
// ════════════════════════════════════════════════════════════════

SystemTFIdentifier : '$' [a-zA-Z0-9_$] [a-zA-Z0-9_$]*;
CIdentifier        : [a-zA-Z_] [a-zA-Z0-9_]*;
SimpleIdentifier   : [a-zA-Z_] [a-zA-Z0-9_$]*;
