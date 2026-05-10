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

parser grammar SystemVerilogParser;

options { tokenVocab = SystemVerilogLexer; }

// ===== SOURCE TEXT =====

source_text
    : timeunits_declaration? description*
    ;

description
    : module_declaration
    | interface_declaration
    | package_declaration
    | program_declaration
    ;

// ===== MODULE DECLARATIONS =====

module_declaration
    : MODULE lifetime? module_identifier
      ( module_parameter_port_list )?
      ( module_port_list )?
      module_item*
      ENDMODULE ( attribute )*
    ;

module_identifier
    : IDENTIFIER
    | ESCAPED_IDENTIFIER
    ;

module_parameter_port_list
    : HASH LPAREN ( parameter_port_declaration ( COMMA parameter_port_declaration )* )? RPAREN
    ;

module_port_list
    : LPAREN ( port ( COMMA port )* )? RPAREN
    ;

parameter_port_declaration
    : parameter_declaration
    | local_parameter_declaration
    ;

port
    : ( attribute )* ( inout_declaration | input_declaration | output_declaration )
    | ( attribute )* ( port_identifier ( unpacked_dimension )* )
    ;

module_item
    : module_common_item
    | module_generate_region
    | port_declaration
    ;

module_common_item
    : always_construct
    | continuous_assign
    | module_instantiation
    | initial_construct
    | comment
    ;

// ===== PORT DECLARATIONS =====

port_declaration
    : ( attribute )* ( inout_declaration | input_declaration | output_declaration )
    ;

// ===== PARAMETER AND LOCALPARAM =====

parameter_declaration
    : PARAMETER ( data_type_or_implicit )? list_of_param_assignments
    ;

local_parameter_declaration
    : LOCALPARAM ( data_type_or_implicit )? list_of_param_assignments
    ;

list_of_param_assignments
    : param_assignment ( COMMA param_assignment )*
    ;

param_assignment
    : IDENTIFIER ( dimension )? ( EQUALS expression )?
    ;

// ===== SIGNAL DECLARATIONS =====

data_declaration
    : ( const_declaration | var_declaration | net_declaration )
    ;

const_declaration
    : CONST ( data_type_or_implicit )? list_of_definitions
    ;

var_declaration
    : VAR ( data_type_or_implicit )? list_of_variables
    ;

list_of_definitions
    : list_of_definitions COMMA def_struct_or_union_or_enum
    | list_of_definitions COMMA data_pattern_or_implicit
    | def_struct_or_union_or_enum
    | data_pattern_or_implicit
    ;

list_of_variables
    : variable_decl_assignment ( COMMA variable_decl_assignment )*
    ;

variable_decl_assignment
    : IDENTIFIER ( dimension )* ( EQUALS expression )?
    ;

def_struct_or_union_or_enum
    : data_pattern_or_implicit
    ;

data_pattern_or_implicit
    : expression
    | data_type
    ;

net_declaration
    : ( supply0_declaration | supply1_declaration | wire_declaration | tri_declaration )
    ;

wire_declaration
    : WIRE ( net_type )? ( data_type_or_implicit )? ( drive_strength )?
      ( charge_strength )? ( vectored_or_scalared )?
      list_of_net_decl_assignments
    ;

tri_declaration
    : TRI ( net_type )? ( data_type_or_implicit )? ( vectored_or_scalared )?
      list_of_net_decl_assignments
    ;

list_of_net_decl_assignments
    : net_decl_assignment ( COMMA net_decl_assignment )*
    ;

net_decl_assignment
    : IDENTIFIER ( dimension )* ( EQUALS expression )?
    ;

supply0_declaration
    : SUPPLY0 ( drive_strength )? list_of_definitions
    ;

supply1_declaration
    : SUPPLY1 ( drive_strength )? list_of_definitions
    ;

// ===== INPUT/OUTPUT/INOUT =====

input_declaration
    : INPUT ( net_type )? ( data_type_or_implicit )? ( signedness )?
      ( dimension )* list_of_port_identifiers
    ;

output_declaration
    : OUTPUT ( net_type )? ( data_type_or_implicit )? ( signedness )?
      ( dimension )* list_of_port_identifiers
    ;

inout_declaration
    : INOUT ( net_type )? ( data_type_or_implicit )? ( signedness )?
      ( dimension )* list_of_port_identifiers
    ;

list_of_port_identifiers
    : IDENTIFIER ( dimension )* ( COMMA IDENTIFIER ( dimension )* )*
    ;

// ===== DATA TYPES =====

data_type_or_implicit
    : data_type
    | implicitly_declared_data_type
    ;

implicitly_declared_data_type
    : ( signing )? ( dimension )*
    ;

data_type
    : integer_atom_type ( dimension )*
    | integer_vector_type ( signing )? ( dimension )*
    | struct_union ( dimension )*
    | enum_identifier ( dimension )*
    ;

integer_atom_type
    : BYTE | SHORTINT | INT | INTEGER | LONGINT | SHORTREAL | REAL | TIME
    ;

integer_vector_type
    : BIT | REG | LOGIC
    ;

signing
    : SIGNED | UNSIGNED
    ;

signedness
    : signing
    ;

net_type
    : WIRE | TRI | TRI0 | TRI1 | TRIAND | TRIOR | TRIREG
    ;

drive_strength
    : LPAREN ( strength0 COMMA strength1 | strength1 COMMA strength0 ) RPAREN
    ;

charge_strength
    : LPAREN ( SMALL | MEDIUM | LARGE ) RPAREN
    ;

strength0
    : SUPPLY0 | PULL0 | STRONG0 | PULLDOWN | WEAK0 | HIGHZ0
    ;

strength1
    : SUPPLY1 | PULL1 | STRONG1 | PULLUP | WEAK1 | HIGHZ1
    ;

vectored_or_scalared
    : VECTORED | SCALARED
    ;

// ===== DIMENSIONS =====

dimension
    : LBRACKET expression COLON expression RBRACKET
    ;

unpacked_dimension
    : dimension
    ;

// ===== ALWAYS BLOCKS =====

always_construct
    : always_statement
    ;

always_statement
    : ALWAYS ( ALWAYS_COMB | ALWAYS_FF | ALWAYS_LATCH ) statement
    ;

// ===== CONTINUOUS ASSIGNMENTS =====

continuous_assign
    : ASSIGN ( drive_strength )? ( delay3 )? list_of_assignments
    ;

list_of_assignments
    : assignment ( COMMA assignment )*
    ;

assignment
    : variable_lvalue EQUALS expression
    ;

// ===== PROCEDURAL BLOCKS =====

initial_construct
    : INITIAL statement_or_null
    ;

// ===== STATEMENTS =====

statement
    : ( block_item_declaration )* statement_item
    ;

statement_or_null
    : statement
    | NULL SEMICOLON
    ;

statement_item
    : seq_block
    | procedural_timing_control_statement
    | conditional_statement
    | case_statement
    | loop_statement
    | procedural_statement
    | jump_statement
    | disable_statement
    ;

procedural_statement
    : blocking_assignment SEMICOLON
    | non_blocking_assignment SEMICOLON
    | procedural_continuous_assignment SEMICOLON
    | inc_dec_statement SEMICOLON
    | procedure_call SEMICOLON
    | assertion_statement
    ;

blocking_assignment
    : ( variable_identifier | variable_lvalue ) EQUALS expression
    ;

non_blocking_assignment
    : ( variable_identifier | variable_lvalue ) LTE expression
    ;

procedural_continuous_assignment
    : DEASSIGN variable_lvalue
    | FORCE ( variable_lvalue | function_subroutine_call ) EQUALS expression
    ;

inc_dec_statement
    : ( variable_identifier | variable_lvalue ) ( PLUS_PLUS | MINUS_MINUS )
    ;

// ===== CONTROL FLOW =====

conditional_statement
    : IF LPAREN condition RPAREN statement_or_null ( ELSE statement_or_null )?
    ;

condition
    : expression
    ;

case_statement
    : ( CASE | CASEX | CASEZ ) LPAREN expression RPAREN case_item+ ENDCASE
    ;

case_item
    : expression ( COMMA expression )* COLON statement_or_null
    | DEFAULT ( COLON )? statement_or_null
    ;

loop_statement
    : FOR LPAREN for_initialization SEMICOLON condition SEMICOLON for_step RPAREN statement_or_null
    | WHILE LPAREN expression RPAREN statement_or_null
    | DO statement_or_null WHILE LPAREN expression RPAREN SEMICOLON
    | REPEAT LPAREN expression RPAREN statement_or_null
    | FOREACH LPAREN IDENTIFIER LBRACKET loop_variables RBRACKET RPAREN statement_or_null
    ;

for_initialization
    : list_of_variables
    | for_declaration
    ;

for_declaration
    : for_variable_declaration ( COMMA for_variable_declaration )*
    ;

for_variable_declaration
    : IDENTIFIER ( dimension )* EQUALS expression
    ;

for_step
    : for_step_assignment ( COMMA for_step_assignment )*
    ;

for_step_assignment
    : variable_lvalue ( PLUS_EQ | MINUS_EQ | MULT_EQ | DIV_EQ | MOD_EQ | AND_EQ | OR_EQ | XOR_EQ ) expression
    | variable_lvalue ( PLUS_PLUS | MINUS_MINUS )
    ;

loop_variables
    : IDENTIFIER ( COMMA IDENTIFIER )*
    ;

jump_statement
    : BREAK SEMICOLON
    | CONTINUE SEMICOLON
    | RETURN ( expression )? SEMICOLON
    ;

disable_statement
    : DISABLE ( IDENTIFIER | hierarchy_identifier ) SEMICOLON
    ;

// ===== PROCEDURAL TIMING =====

procedural_timing_control_statement
    : procedural_timing_control statement_or_null
    ;

procedural_timing_control
    : delay_control
    | event_control
    ;

delay_control
    : HASH delay_value
    ;

delay_value
    : primary
    | INTEGER_LITERAL
    ;

event_control
    : AT ( sensitivity_list | IDENTIFIER | hierarchy_identifier )
    ;

sensitivity_list
    : STAR
    | LPAREN ( event_expression ( COMMA event_expression )* | COMMA )? RPAREN
    ;

event_expression
    : ( POSEDGE | NEGEDGE )? expression
    ;

// ===== SEQUENTIAL BLOCKS =====

seq_block
    : BEGIN ( COLON IDENTIFIER )? ( block_item_declaration )* statement_item* END
    ;

block_item_declaration
    : block_data_declaration
    ;

block_data_declaration
    : ( data_declaration | local_parameter_declaration )
    ;

// ===== MODULE INSTANTIATION =====

module_instantiation
    : IDENTIFIER ( parameter_value_assignment )? module_instance ( COMMA module_instance )*
    ;

parameter_value_assignment
    : HASH LPAREN ( ordered_parameter_assignment ( COMMA ordered_parameter_assignment )* )? RPAREN
    | HASH ( ordered_parameter_assignment ( COMMA ordered_parameter_assignment )* )?
    ;

ordered_parameter_assignment
    : expression
    ;

module_instance
    : IDENTIFIER ( LPAREN ( named_port_connection ( COMMA named_port_connection )* )? RPAREN )
    ;

named_port_connection
    : ( DOT IDENTIFIER LPAREN RPAREN )
    | DOT IDENTIFIER LPAREN expression RPAREN
    ;

// ===== GENERATE BLOCKS =====

module_generate_region
    : GENERATE module_generate_item* ENDGENERATE
    ;

module_generate_item
    : genvar_declaration
    | loop_generate_construct
    | conditional_generate_construct
    | generate_block
    | module_common_item
    ;

genvar_declaration
    : GENVAR IDENTIFIER ( COMMA IDENTIFIER )* SEMICOLON
    ;

loop_generate_construct
    : FOR LPAREN for_initialization SEMICOLON condition SEMICOLON for_step RPAREN
      generate_block
    ;

conditional_generate_construct
    : if_generate_construct
    | case_generate_construct
    ;

if_generate_construct
    : IF LPAREN expression RPAREN generate_block ( ELSE generate_block )?
    ;

case_generate_construct
    : CASE LPAREN expression RPAREN case_generate_item+ ENDCASE
    ;

case_generate_item
    : expression ( COMMA expression )* COLON generate_block
    | DEFAULT ( COLON )? generate_block
    ;

generate_block
    : BEGIN ( COLON IDENTIFIER )? ( module_generate_item )* END
    | module_item
    ;

// ===== INTERFACE DECLARATIONS =====

interface_declaration
    : INTERFACE lifetime? IDENTIFIER ( interface_port_list )? interface_item* ENDINTERFACE
    ;

interface_port_list
    : LPAREN ( interface_port ( COMMA interface_port )* )? RPAREN
    ;

interface_port
    : ( attribute )* ( IDENTIFIER ( dimension )* )?
    ;

interface_item
    : interface_common_item
    | modport_declaration
    ;

interface_common_item
    : continuous_assign
    | module_instantiation
    | comment
    ;

// ===== MODPORT =====

modport_declaration
    : MODPORT IDENTIFIER LPAREN modport_item ( COMMA modport_item )* RPAREN SEMICOLON
    ;

modport_item
    : IDENTIFIER ( LPAREN ( expression ( COMMA expression )* )? RPAREN )?
    ;

// ===== PACKAGE DECLARATIONS =====

package_declaration
    : PACKAGE lifetime? IDENTIFIER SEMICOLON package_item* ENDPACKAGE
    ;

package_item
    : package_common_item
    | function_declaration
    | task_declaration
    ;

package_common_item
    : data_declaration
    | net_declaration
    ;

// ===== PROGRAM DECLARATIONS =====

program_declaration
    : PROGRAM lifetime? IDENTIFIER ( program_port_list )? program_item* ENDPROGRAM
    ;

program_port_list
    : LPAREN ( program_port ( COMMA program_port )* )? RPAREN
    ;

program_port
    : ( attribute )* ( program_variable_direction )? ( data_type_or_implicit )? IDENTIFIER ( dimension )*
    ;

program_variable_direction
    : INPUT | OUTPUT | INOUT | REF
    ;

program_item
    : program_common_item
    | function_declaration
    | task_declaration
    ;

program_common_item
    : data_declaration
    | net_declaration
    | continuous_assign
    | initial_construct
    ;

// ===== FUNCTIONS AND TASKS =====

function_declaration
    : FUNCTION ( lifetime )? ( function_data_type_or_implicit )? IDENTIFIER
      ( LPAREN ( function_port_list )? RPAREN )? SEMICOLON
      function_item_declaration* function_statement* ENDFUNCTION
    ;

function_data_type_or_implicit
    : data_type
    | VOID
    | implicitly_declared_data_type
    ;

function_port_list
    : function_port_item ( COMMA function_port_item )*
    ;

function_port_item
    : ( attribute )* ( function_port_direction )? ( data_type_or_implicit )? ( IDENTIFIER ( dimension )* )?
    ;

function_port_direction
    : INPUT | OUTPUT | INOUT | REF
    ;

function_item_declaration
    : block_item_declaration
    ;

function_statement
    : statement
    ;

task_declaration
    : TASK ( lifetime )? IDENTIFIER
      ( LPAREN ( task_port_list )? RPAREN )? SEMICOLON
      task_item_declaration* statement* ENDTASK
    ;

task_port_list
    : task_port_item ( COMMA task_port_item )*
    ;

task_port_item
    : ( attribute )* ( task_port_direction )? ( data_type_or_implicit )? ( IDENTIFIER ( dimension )* )?
    ;

task_port_direction
    : INPUT | OUTPUT | INOUT | REF
    ;

task_item_declaration
    : block_item_declaration
    ;

// ===== LIFETIME =====

lifetime
    : STATIC | AUTOMATIC
    ;

// ===== EXPRESSIONS =====

expression
    : primary
    | expression ( BAND | BOR | BXOR | NAND | NOR | NXOR ) expression
    | expression ( EQ | NEQ | CEQ | CNEQ | LT | LE | GT | GE | SLEFT | SRIGHT | SLEFT_ARITH | SRIGHT_ARITH ) expression
    | expression ( PLUS | MINUS | MULT | DIV | MOD ) expression
    | expression ( AND | OR ) expression
    | expression QUESTION expression COLON expression
    | unary_operator ( primary | function_subroutine_call )
    | LPAREN expression RPAREN
    ;

primary
    : literal
    | IDENTIFIER
    | hierarchy_identifier
    | module_path
    | LPAREN expression RPAREN
    | concatenation
    ;

literal
    : INTEGER_LITERAL
    | REAL_LITERAL
    | STRING_LITERAL
    | TIME_LITERAL
    ;

variable_identifier
    : IDENTIFIER ( dimension )*
    ;

variable_lvalue
    : IDENTIFIER ( dimension )*
    | hierarchy_identifier ( dimension )*
    | LPAREN variable_lvalue RPAREN
    ;

hierarchy_identifier
    : IDENTIFIER ( DOT IDENTIFIER )*
    ;

module_path
    : IDENTIFIER ( DOT IDENTIFIER )*
    ;

concatenation
    : LBRACE expression ( COMMA expression )* RBRACE
    ;

function_subroutine_call
    : IDENTIFIER ( LPAREN ( expression ( COMMA expression )* )? RPAREN )?
    ;

procedure_call
    : IDENTIFIER ( LPAREN ( expression ( COMMA expression )* )? RPAREN )?
    ;

unary_operator
    : PLUS | MINUS | BNOT | NOT
    ;

// ===== IDENTIFIERS AND MISC =====

IDENTIFIER
    : [a-zA-Z_] [a-zA-Z0-9_$]*
    ;

ESCAPED_IDENTIFIER
    : '\\' ~[ \t\r\n]+
    ;

// ===== TIME UNITS =====

timeunits_declaration
    : TIMEUNIT time_literal SEMICOLON
    | TIMEUNIT time_literal COLON time_literal SEMICOLON
    ;

time_literal
    : REAL_LITERAL [npu]? 's'
    ;

// ===== ATTRIBUTES =====

attribute
    : ATTR_LPAREN expression ( COMMA expression )* ATTR_RPAREN
    ;

ATTR_LPAREN
    : '(*'
    ;

ATTR_RPAREN
    : '*)'
    ;

// ===== MISC =====

comment
    : ML_COMMENT
    | LINE_COMMENT
    ;

NULL
    : 'null'
    ;

PLUS_PLUS
    : '++'
    ;

MINUS_MINUS
    : '--'
    ;

PLUS_EQ
    : '+='
    ;

MINUS_EQ
    : '-='
    ;

MULT_EQ
    : '*='
    ;

DIV_EQ
    : '/='
    ;

MOD_EQ
    : '%='
    ;

AND_EQ
    : '&='
    ;

OR_EQ
    : '|='
    ;

XOR_EQ
    : '^='
    ;

LTE
    : '<='
    ;

POSEDGE
    : 'posedge'
    ;

NEGEDGE
    : 'negedge'
    ;

SUPPLY0
    : 'supply0'
    ;

SUPPLY1
    : 'supply1'
    ;

TRI
    : 'tri'
    ;

TRI0
    : 'tri0'
    ;

TRI1
    : 'tri1'
    ;

TRIAND
    : 'triand'
    ;

TRIOR
    : 'trior'
    ;

TRIREG
    : 'trireg'
    ;

SMALL
    : 'small'
    ;

MEDIUM
    : 'medium'
    ;

LARGE
    : 'large'
    ;

STRONG0
    : 'strong0'
    ;

STRONG1
    : 'strong1'
    ;

PULL0
    : 'pull0'
    ;

PULL1
    : 'pull1'
    ;

PULLUP
    : 'pullup'
    ;

PULLDOWN
    : 'pulldown'
    ;

WEAK0
    : 'weak0'
    ;

WEAK1
    : 'weak1'
    ;

HIGHZ0
    : 'highz0'
    ;

HIGHZ1
    : 'highz1'
    ;

VECTORED
    : 'vectored'
    ;

SCALARED
    : 'scalared'
    ;

REF
    : 'ref'
    ;

TIMEUNIT
    : 'timeunit'
    ;

SUPER
    : 'super'
    ;

THIS
    : 'this'
    ;

PULLUP
    : 'pullup'
    ;

PULLDOWN
    : 'pulldown'
    ;