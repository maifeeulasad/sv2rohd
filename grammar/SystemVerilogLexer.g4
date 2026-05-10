// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

/*
  SystemVerilog Parser Grammar for SV2ROHD

  This grammar targets the synthesizable subset of IEEE 1800-2017 SystemVerilog.
  Grammar is designed to be compatible with ANTLR4 and the antlr4dart runtime.

  Key features supported:
  - Module declarations with parameters and ports
  - Port declarations (input, output, inout)
  - Signal declarations (wire, reg, logic)
  - Vector ranges [msb:lsb]
  - always_comb and always_ff blocks
  - Blocking (=) and non-blocking (<=) assignments
  - If-else and case statements
  - Module instantiation
  - Generate blocks

  Features excluded (can be added later):
  - Classes and verification constructs
  - Package and library constructs
  - Advanced types (struct, enum)
  - Interfaces
  - Property specifications
*/

lexer grammar SystemVerilogLexer;

// ===== WHITESPACE AND COMMENTS =====

WS : [ \t\r\n]+ -> skip ;
ML_COMMENT : '/*' .*? '*/' -> skip ;
LINE_COMMENT : '//' ~[\r\n]* -> skip ;

// ===== KEYWORDS =====

// Module and interface keywords
MODULE : 'module' ;
ENDMODULE : 'endmodule' ;
PACKAGE : 'package' ;
ENDPACKAGE : 'endpackage' ;
INTERFACE : 'interface' ;
ENDINTERFACE : 'endinterface' ;
MODPORT : 'modport' ;
PROGRAM : 'program' ;
ENDPROGRAM : 'endprogram' ;
CLASS : 'class' ;
ENDCLASS : 'endclass' ;
FUNCTION : 'function' ;
ENDFUNCTION : 'endfunction' ;
TASK : 'task' ;
ENDTASK : 'endtask' ;
BEGIN : 'begin' ;
END : 'end' ;

// Port and signal keywords
INPUT : 'input' ;
OUTPUT : 'output' ;
INOUT : 'inout' ;
LOGIC : 'logic' ;
WIRE : 'wire' ;
REG : 'reg' ;
BIT : 'bit' ;
BYTE : 'byte' ;
INT : 'int' ;
INTEGER : 'integer' ;
SHORTINT : 'shortint' ;
LONGINT : 'longint' ;
SHORTREAL : 'shortreal' ;
REAL : 'real' ;
TIME : 'time' ;
STRING : 'string' ;
VOID : 'void' ;
TYPE : 'type' ;
ENUM : 'enum' ;
STRUCT : 'struct' ;
UNION : 'union' ;
PARAMETER : 'parameter' ;
LOCALPARAM : 'localparam' ;
CONST : 'const' ;
VAR : 'var' ;
SIGNED : 'signed' ;
UNSIGNED : 'unsigned' ;
SUPER : 'super' ;
THIS : 'this' ;
STATIC : 'static' ;
AUTOMATIC : 'automatic' ;

// Procedural keywords
ALWAYS : 'always' ;
ALWAYS_FF : 'always_ff' ;
ALWAYS_COMB : 'always_comb' ;
ALWAYS_LATCH : 'always_latch' ;
INITIAL : 'initial' ;
ASSIGN : 'assign' ;
DEASSIGN : 'deassign' ;
FORCE : 'force' ;
RELEASE : 'release' ;

// Control flow keywords
IF : 'if' ;
ELSE : 'else' ;
CASE : 'case' ;
ENDCASE : 'endcase' ;
CASEX : 'casex' ;
CASEZ : 'casez' ;
DEFAULT : 'default' ;
FOR : 'for' ;
FOREVER : 'forever' ;
REPEAT : 'repeat' ;
WHILE : 'while' ;
DO : 'do' ;
BREAK : 'break' ;
CONTINUE : 'continue' ;
RETURN : 'return' ;
WAIT : 'wait' ;
FORK : 'fork' ;
JOIN : 'join' ;
JOIN_ANY : 'join_any' ;
JOIN_NONE : 'join_none' ;
DISABLE : 'disable' ;

// Generate keywords
GENVAR : 'genvar' ;
GENERATE : 'generate' ;
ENDGENERATE : 'endgenerate' ;

// Operators
PLUS : '+' ;
MINUS : '-' ;
MULT : '*' ;
DIV : '/' ;
MOD : '%' ;
EQ : '==' ;
NEQ : '!=' ;
CEQ : '===' ;
CNEQ : '!==' ;
LT : '<' ;
LE : '<=' ;
GT : '>' ;
GE : '>=' ;
AND : '&&' ;
OR : '||' ;
NOT : '!' ;
BNOT : '~' ;
BAND : '&' ;
BOR : '|' ;
BXOR : '^' ;
XNOR : '~^' ;
LXOR : '^~' ;
QUESTION : '?' ;
COLON : ':' ;
SEMICOLON : ';' ;
COMMA : ',' ;
DOT : '.' ;
HASH : '#' ;
AT : '@' ;
LPAREN : '(' ;
RPAREN : ')' ;
LBRACKET : '[' ;
RBRACKET : ']' ;
LBRACE : '{' ;
RBRACE : '}' ;
EQUALS : '=' ;
PLUSEQ : '+=' ;
MINUSEQ : '-=' ;
MULTEQ : '*=' ;
DIVEQ : '/=' ;
MODEQ : '%=' ;
ANDEQ : '&=' ;
OREQ : '|=' ;
XOREQ : '^=' ;
SLEFT : '<<' ;
SRIGHT : '>>' ;
SLEFT_ARITH : '<<<' ;
SRIGHT_ARITH : '>>>' ;

// ===== IDENTIFIERS AND LITERALS =====

// Simple identifiers
fragment LETTER : [a-zA-Z] ;
fragment UNDERSCORE : '_' ;
fragment DOLLAR : '$' ;
fragment IDENTIFIER_START : LETTER | UNDERSCORE | DOLLAR ;
fragment IDENTIFIER_PART : LETTER | UNDERSCORE | DOLLAR | [0-9] ;
IDENTIFIER : IDENTIFIER_START IDENTIFIER_PART* ;

// Escaped identifiers
ESCAPED_IDENTIFIER : '\\' ~[ \t\r\n]+ ;

// Integer literals
fragment DIGIT : [0-9] ;
fragment BINARY_DIGIT : [0-1] ;
fragment OCTAL_DIGIT : [0-7] ;
fragment HEX_DIGIT : [0-9a-fA-F] ;

INTEGER_LITERAL : DECIMAL_INTEGER | BASED_INTEGER ;

fragment DECIMAL_INTEGER : [0-9]+ ('_' [0-9]+)* ;
fragment BASED_INTEGER :
    (BINARY_DIGIT | OCTAL_DIGIT | HEX_DIGIT) ('_'? (BINARY_DIGIT | OCTAL_DIGIT | HEX_DIGIT | [xXzZ]))*
    (\'' [bBoOxXzZ]) ;

// Real literals
REAL_LITERAL :
    DECIMAL_INTEGER '.' DECIMAL_INTEGER
    | DECIMAL_INTEGER ('.' DECIMAL_INTEGER)? [eE] [+-]? DECIMAL_INTEGER
    | DECIMAL_INTEGER [eE] [+-]? DECIMAL_INTEGER ;

// Time literals
TIME_LITERAL : REAL_LITERAL [npu]? 's' ;

// String literals
STRING_LITERAL : '"' (~["\r\n] | '""')* '"' ;

// ===== PREPROCESSOR DIRECTIVES =====

DIRECTIVE : '`' IDENTIFIER (~[\r\n]*)? ;

// ===== ERROR TOKEN =====

ERROR : . ;