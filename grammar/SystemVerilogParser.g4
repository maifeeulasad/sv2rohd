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
// Parser grammar – SystemVerilog (IEEE 1800-2017 LRM, Annex A)
// Companion file: SystemVerilogLexer.g4
// All token literals live in the lexer; this file is pure grammar.

parser grammar SystemVerilogParser;

options { tokenVocab = SystemVerilogLexer; }


// ════════════════════════════════════════════════════════════
// A.1  SOURCE TEXT
// ════════════════════════════════════════════════════════════

// ── A.1.2  SystemVerilog source text ─────────────────────────

source_text
    : timeunits_declaration? description* EOF
    ;

description
    : module_declaration
    // | udp_declaration
    | interface_declaration
    | program_declaration
    | package_declaration
    | attribute_instance* package_item
    | attribute_instance* bind_directive
    | config_declaration
    ;

module_nonansi_header
    : attribute_instance* module_keyword lifetime? module_identifier
      package_import_declaration* parameter_port_list? list_of_ports Semi
    ;

module_ansi_header
    : attribute_instance* module_keyword lifetime? module_identifier
      package_import_declaration* parameter_port_list? list_of_port_declarations? Semi
    ;

module_declaration
    : module_nonansi_header timeunits_declaration? module_item* Tendmodule (Colon module_identifier)?
    | module_ansi_header    timeunits_declaration? non_port_module_item* Tendmodule (Colon module_identifier)?
    | attribute_instance* module_keyword lifetime? module_identifier LParen DotStar RParen Semi
          timeunits_declaration? module_item* Tendmodule (Colon module_identifier)?
    | TExtern module_nonansi_header
    | TExtern module_ansi_header
    ;

module_keyword
    : TModule
    | TMacromodule
    ;

interface_declaration
    : interface_nonansi_header timeunits_declaration? interface_item*
          TEndinterface (Colon interface_identifier)?
    | interface_ansi_header timeunits_declaration? non_port_interface_item*
          TEndinterface (Colon interface_identifier)?
    | attribute_instance* TInterface interface_identifier LParen DotStar RParen Semi
          timeunits_declaration? interface_item* TEndinterface (Colon interface_identifier)?
    | TExtern interface_nonansi_header
    | TExtern interface_ansi_header
    ;

interface_nonansi_header
    : attribute_instance* TInterface lifetime? interface_identifier
      package_import_declaration* parameter_port_list? list_of_ports Semi
    ;

interface_ansi_header
    : attribute_instance? TInterface lifetime? interface_identifier
      package_import_declaration* parameter_port_list? list_of_port_declarations? Semi
    ;

program_declaration
    : program_nonansi_header timeunits_declaration? program_item*
          TEndprogram (Colon program_identifier)?
    | program_ansi_header timeunits_declaration? non_port_program_item*
          TEndprogram (Colon program_identifier)?
    | attribute_instance* TProgram program_identifier LParen DotStar RParen Semi Semi
          timeunits_declaration? program_item* TEndprogram (Colon program_identifier)?
    | TExtern program_nonansi_header
    | TExtern program_ansi_header
    ;

program_nonansi_header
    : attribute_instance* TProgram lifetime? program_identifier
      package_import_declaration* parameter_port_list? list_of_ports Semi
    ;

program_ansi_header
    : attribute_instance* TProgram lifetime? program_identifier
      package_import_declaration* parameter_port_list? list_of_port_declarations? Semi
    ;

checker_declaration
    : TChecker checker_identifier (LParen checker_port_list? RParen)? Semi
      (attribute_instance* checker_or_generate_item)* TEndchecker (Colon checker_identifier)?
    ;

class_declaration
    : TVirtual? TClass lifetime? class_identifier parameter_port_list?
      (TExtends class_type (LParen list_of_arguments RParen)?)?
      (TImplements interface_class_type (Comma interface_class_type)*)? Semi class_item*
      TEndclass (Colon class_identifier)?
    ;

interface_class_type
    : ps_class_identifier parameter_value_assignment?
    ;

interface_class_declaration
    : TInterface TClass class_identifier parameter_port_list?
      (TExtends interface_class_type (Comma interface_class_type)*)? Semi interface_class_item*
      TEndclass (Colon class_identifier)?
    ;

interface_class_item
    : type_declaration
    | attribute_instance* interface_class_method
    | local_parameter_declaration Semi
    | parameter_declaration Semi
    | Semi
    ;

interface_class_method
    : TPure TVirtual method_prototype Semi
    ;

package_declaration
    : attribute_instance* TPackage lifetime? package_identifier Semi timeunits_declaration?
      (attribute_instance* package_item)* TEndpackage (Colon package_identifier)?
    ;

timeunits_declaration
    : TTimeunit  time_literal (Slash time_literal)? Semi
    | TTimeprecision time_literal Semi
    | TTimeunit  time_literal Semi TTimeprecision time_literal Semi
    | TTimeprecision time_literal Semi TTimeunit  time_literal Semi
    ;


// ════════════════════════════════════════════════════════════
// A.1.3  MODULE PORTS
// ════════════════════════════════════════════════════════════

parameter_port_list
    : Hash LParen list_of_param_assignments (Comma parameter_port_declaration)* RParen
    | Hash LParen parameter_port_declaration (Comma parameter_port_declaration)* RParen
    | Hash LParen RParen
    ;

parameter_port_declaration
    : parameter_declaration
    | local_parameter_declaration
    | data_type list_of_param_assignments
    | TType list_of_type_assignments
    ;

list_of_ports
    : LParen port (Comma port)* RParen
    ;

list_of_port_declarations
    : LParen (attribute_instance* ansi_port_declaration
              (Comma attribute_instance* ansi_port_declaration)*)? RParen
    ;

port_declaration
    : attribute_instance* inout_declaration
    | attribute_instance* input_declaration
    | attribute_instance* output_declaration
    | attribute_instance* ref_declaration
    | attribute_instance* interface_port_declaration
    ;

port
    : port_expression
    | DotOp port_identifier LParen port_expression RParen
    ;

port_expression
    : (port_reference (Comma port_reference)*)*
    ;

port_reference
    : port_identifier constant_select
    ;

port_direction
    : TInput
    | TOutput
    | TInout
    | TRef
    ;

net_port_header
    : port_direction? net_port_type
    ;

variable_port_header
    : port_direction? variable_port_type
    ;

interface_port_header
    : interface_identifier (DotOp modport_identifier)?
    | TInterface (DotOp modport_identifier)?
    ;

ansi_port_declaration
    : (net_port_header | interface_port_header) port_identifier unpacked_dimension*
      (OpAssign constant_expression)?
    | variable_port_header? port_identifier variable_dimension* (OpAssign constant_expression)?
    | port_direction? DotOp port_identifier LParen expression? RParen
    ;


// ════════════════════════════════════════════════════════════
// A.1.4  MODULE ITEMS
// ════════════════════════════════════════════════════════════

elaboration_system_task
    : SystemTFIdentifier (LParen finish_number (Comma list_of_arguments)? RParen)? Semi
    ;

finish_number
    : Digit0
    | Digit1
    | Digit2
    ;

module_common_item
    : module_or_generate_item_declaration
    | interface_instantiation
    | program_instantiation
    | assertion_item
    | bind_directive
    | continuous_assign
    | net_alias
    | initial_construct
    | final_construct
    | always_construct
    | loop_generate_construct
    | conditional_generate_construct
    | elaboration_system_task
    ;

module_item
    : port_declaration Semi
    | non_port_module_item
    ;

module_or_generate_item
    : attribute_instance* parameter_override
    // | attribute_instance* gate_instantiation
    // | attribute_instance* udp_instantiation
    | attribute_instance* module_instantiation
    | attribute_instance* module_common_item
    ;

module_or_generate_item_declaration
    : package_or_generate_item_declaration
    | genvar_declaration
    | clocking_declaration
    | TDefault TClocking clocking_identifier Semi
    | TDefault TDisable TIff expression_or_dist Semi
    ;

non_port_module_item
    : generate_region
    | module_or_generate_item
    // | specify_block
    | attribute_instance* specparam_declaration
    | program_declaration
    | module_declaration
    | interface_declaration
    | timeunits_declaration
    ;

parameter_override
    : TDefparam list_of_defparam_assignments Semi
    ;

bind_directive
    : TBind bind_target_scope (Colon bind_target_instance_list)? bind_instantiation Semi
    | TBind bind_target_instance bind_instantiation Semi
    ;

bind_target_scope
    : module_identifier
    | interface_identifier
    ;

bind_target_instance
    : hierarchical_identifier constant_bit_select
    ;

bind_target_instance_list
    : bind_target_instance (Comma bind_target_instance)*
    ;

bind_instantiation
    : program_instantiation
    | module_instantiation
    | interface_instantiation
    | checker_instantiation
    ;


// ════════════════════════════════════════════════════════════
// A.1.5  CONFIGURATION
// ════════════════════════════════════════════════════════════

config_declaration
    : TConfig config_identifier Semi (local_parameter_declaration Semi)* design_statement
      config_rule_statement* TEndconfig (Colon config_identifier)?
    ;

design_statement
    : TDesign ((library_identifier DotOp)? cell_identifier)* Semi
    ;

config_rule_statement
    : default_clause liblist_clause Semi
    | inst_clause liblist_clause Semi
    | inst_clause use_clause Semi
    | cell_clause liblist_clause Semi
    | cell_clause use_clause Semi
    ;

default_clause
    : TDefault
    ;

inst_clause
    : TInstance inst_name
    ;

inst_name
    : topmodule_identifier (DotOp instance_identifier)*
    ;

cell_clause
    : TCell (library_identifier DotOp)? cell_identifier
    ;

liblist_clause
    : TLiblist library_identifier*
    ;

use_clause
    : TUse (library_identifier DotOp)? cell_identifier (Colon TConfig)?
    | TUse named_parameter_assignment (Comma named_parameter_assignment)* (Colon TConfig)?
    | TUse (library_identifier DotOp)? cell_identifier
      named_parameter_assignment (Comma named_parameter_assignment)* (Colon TConfig)?
    ;


// ════════════════════════════════════════════════════════════
// A.1.6  INTERFACE ITEMS
// ════════════════════════════════════════════════════════════

interface_or_generate_item
    : attribute_instance* module_common_item
    | attribute_instance* modport_declaration
    | attribute_instance* extern_tf_declaration
    ;

extern_tf_declaration
    : TExtern method_prototype Semi
    | TExtern TForkjoin task_prototype Semi
    ;

interface_item
    : port_declaration Semi
    | non_port_interface_item
    ;

non_port_interface_item
    : generate_region
    | interface_or_generate_item
    | program_declaration
    | interface_declaration
    | timeunits_declaration
    ;


// ════════════════════════════════════════════════════════════
// A.1.7  PROGRAM ITEMS
// ════════════════════════════════════════════════════════════

program_item
    : port_declaration Semi
    | non_port_program_item
    ;

non_port_program_item
    : attribute_instance* continuous_assign
    | attribute_instance* module_or_generate_item_declaration
    | attribute_instance* initial_construct
    | attribute_instance* final_construct
    | attribute_instance* concurrent_assertion_item
    | timeunits_declaration
    | program_generate_item
    ;

program_generate_item
    : loop_generate_construct
    | conditional_generate_construct
    | generate_region
    | elaboration_system_task
    ;


// ════════════════════════════════════════════════════════════
// A.1.8  CHECKER ITEMS
// ════════════════════════════════════════════════════════════

checker_port_list
    : checker_port_item (Comma checker_port_item)*
    ;

checker_port_item
    : attribute_instance* checker_port_direction? property_formal_type formal_port_identifier
      variable_dimension* (OpAssign property_actual_arg)?
    ;

checker_port_direction
    : TInput
    | TOutput
    ;

checker_or_generate_item
    : checker_or_generate_item_declaration
    | initial_construct
    | always_construct
    | final_construct
    | assertion_item
    | continuous_assign
    | checker_generate_item
    ;

checker_or_generate_item_declaration
    : TRand? data_declaration
    | function_declaration
    | checker_declaration
    | assertion_item_declaration
    | covergroup_declaration
    | overload_declaration
    | genvar_declaration
    | clocking_declaration
    | TDefault TClocking clocking_identifier Semi
    | TDefault TDisable TIff expression_or_dist Semi
    | Semi
    ;

checker_generate_item
    : loop_generate_construct
    | conditional_generate_construct
    | generate_region
    | elaboration_system_task
    ;


// ════════════════════════════════════════════════════════════
// A.1.9  CLASS ITEMS
// ════════════════════════════════════════════════════════════

class_item
    : attribute_instance* class_property
    | attribute_instance* class_method
    | attribute_instance* class_constraint
    | attribute_instance* class_declaration
    | attribute_instance* covergroup_declaration
    | local_parameter_declaration Semi
    | parameter_declaration Semi
    | Semi
    ;

class_property
    : property_qualifier* data_declaration
    | TConst class_item_qualifier* data_type const_identifier (OpAssign constant_expression)? Semi
    ;

class_method
    : method_qualifier* task_declaration
    | method_qualifier* function_declaration
    | TPure TVirtual class_item_qualifier* method_prototype Semi
    | TExtern method_qualifier* method_prototype Semi
    | method_qualifier* class_constructor_declaration
    | TExtern method_qualifier* class_constructor_prototype
    ;

class_constructor_prototype
    : TFunction TNew (LParen tf_port_list RParen)? Semi
    ;

class_constraint
    : constraint_prototype
    | constraint_declaration
    ;

class_item_qualifier
    : TStatic
    | TProtected
    | TLocal
    ;

property_qualifier
    : random_qualifier
    | class_item_qualifier
    ;

random_qualifier
    : TRand
    | TRandc
    ;

method_qualifier
    : TPure? TVirtual
    | class_item_qualifier
    ;

method_prototype
    : task_prototype
    | function_prototype
    ;

class_constructor_declaration
    : TFunction class_scope? TNew (LParen tf_port_list RParen)? Semi block_item_declaration*
      (TSuper DotOp TNew (LParen list_of_arguments RParen)? Semi)?
      function_statement_or_null* TEndfunction (Colon TNew)?
    ;


// ════════════════════════════════════════════════════════════
// A.1.10  CONSTRAINTS
// ════════════════════════════════════════════════════════════

constraint_declaration
    : TStatic? TConstraint constraint_identifier constraint_block
    ;

constraint_block
    : LBrace constraint_block_item* RBrace
    ;

constraint_block_item
    : TSolve solve_before_list TBefore solve_before_list Semi
    | constraint_expression
    ;

solve_before_list
    : constraint_primary (Comma constraint_primary)*
    ;

constraint_primary
    : (implicit_class_handle DotOp | class_scope)? hierarchical_identifier select
    ;

constraint_expression
    : TSoft? expression_or_dist Semi
    | uniqueness_constraint Semi
    | expression OpImplication constraint_set
    | TIf LParen expression RParen constraint_set (TElse constraint_set)?
    | TForeach LParen ps_or_hierarchical_array_identifier LBracket loop_variables RBracket RParen
      constraint_set
    | TDisable TSoft constraint_primary Semi
    ;

uniqueness_constraint
    : TUnique open_range_list*
    ;

constraint_set
    : constraint_expression
    | LBrace constraint_expression* RBrace
    ;

dist_list
    : dist_item (Comma dist_item)*
    ;

dist_item
    : value_range dist_weight?
    ;

dist_weight
    : OpAssign OpAssign expression    // ':='
    | OpDiv expression                // ':/'  — NOTE: parser uses Colon + OpDiv for ':/'
    ;

constraint_prototype
    : constraint_prototype_qualifier? TStatic? TConstraint constraint_identifier Semi
    ;

constraint_prototype_qualifier
    : TExtern
    | TPure
    ;

extern_constraint_declaration
    : TStatic TConstraint class_scope constraint_identifier constraint_block
    ;

identifier_list
    : identifier (Comma identifier)*
    ;


// ════════════════════════════════════════════════════════════
// A.1.11  PACKAGE ITEMS
// ════════════════════════════════════════════════════════════

package_item
    : package_or_generate_item_declaration
    | anonymous_program
    | package_export_declaration
    | timeunits_declaration
    ;

package_or_generate_item_declaration
    : net_declaration
    | data_declaration
    | task_declaration
    | function_declaration
    | checker_declaration
    | dpi_import_export
    | extern_constraint_declaration
    | class_declaration
    | class_constructor_declaration
    | local_parameter_declaration Semi
    | parameter_declaration Semi
    | covergroup_declaration
    | overload_declaration
    | assertion_item_declaration
    | Semi
    ;

anonymous_program
    : TProgram Semi anonymous_program_item* TEndprogram
    ;

anonymous_program_item
    : task_declaration
    | function_declaration
    | class_declaration
    | covergroup_declaration
    | class_constructor_declaration
    | Semi
    ;


// ════════════════════════════════════════════════════════════
// A.2  DECLARATIONS
// ════════════════════════════════════════════════════════════

// ── A.2.1.1  Module parameter declarations ───────────────────

local_parameter_declaration
    : TLocalparam data_type_or_implicit list_of_param_assignments
    | TLocalparam TType list_of_type_assignments
    ;

parameter_declaration
    : TParameter data_type_or_implicit list_of_param_assignments
    | TParameter TType list_of_type_assignments
    ;

specparam_declaration
    : TSpecparam packed_dimension? list_of_specparam_assignments Semi
    ;

// ── A.2.1.2  Port declarations ───────────────────────────────

inout_declaration
    : TInout net_port_type list_of_port_identifiers
    ;

input_declaration
    : TInput net_port_type list_of_port_identifiers
    | TInput variable_port_type list_of_variable_identifiers
    ;

output_declaration
    : TOutput net_port_type list_of_port_identifiers
    | TOutput variable_port_type list_of_variable_port_identifiers
    ;

interface_port_declaration
    : interface_identifier list_of_interface_identifiers
    | interface_identifier DotOp modport_identifier list_of_interface_identifiers
    ;

ref_declaration
    : TRef variable_port_type list_of_variable_identifiers
    ;

// ── A.2.1.3  Type declarations ───────────────────────────────

data_declaration
    : TConst? TVar? lifetime? data_type_or_implicit list_of_variable_decl_assignments Semi
    | type_declaration
    | package_import_declaration net_type_declaration
    ;

package_import_declaration
    : TImport package_import_item (Comma package_import_item)* Semi
    ;

package_import_item
    : package_identifier ScopeOp identifier
    | package_identifier ScopeOp OpMul
    ;

package_export_declaration
    : TExport OpMul ScopeOp OpMul Semi
    | TExport package_import_item (Comma package_import_item)* Semi
    ;

genvar_declaration
    : TGenvar list_of_genvar_identifiers Semi
    ;

net_declaration
    : net_type (drive_strength | charge_strength)? (TVectored | TScalared)?
      data_type_or_implicit delay3? list_of_net_decl_assignments Semi
    | net_type_identifier delay_control? list_of_net_decl_assignments Semi
    | TInterconnect implicit_data_type (Hash delay_value)? net_identifier unpacked_dimension*
      (Comma net_identifier unpacked_dimension*)? Semi
    ;

type_declaration
    : TTypedef data_type type_identifier variable_dimension* Semi
    | TTypedef interface_instance_identifier constant_bit_select DotOp type_identifier type_identifier Semi
    | TTypedef (TEnum | TStruct | TUnion | TClass | TInterface TClass)? type_identifier Semi
    ;

net_type_declaration
    : TNettype data_type net_type_identifier
      (TWith (package_scope | class_scope)? tf_identifier)? Semi
    | TNettype (package_scope | class_scope)? net_type_identifier net_type_identifier Semi
    ;

lifetime
    : TStatic
    | TAutomatic
    ;


// ════════════════════════════════════════════════════════════
// A.2.2  DECLARATION DATA TYPES
// ════════════════════════════════════════════════════════════

// ── A.2.2.1  Net and variable types ──────────────────────────

casting_type
    : simple_type
    | constant_primary
    | signing
    | TString
    | TConst
    ;

data_type
    : integer_vector_type signing? packed_dimension*
    | integer_atom_type signing?
    | non_integer_type
    | struct_union (TPacked signing?)?
      LBrace struct_union_member struct_union_member* RBrace packed_dimension*
    | TEnum enum_base_type?
      LBrace enum_name_declaration (Comma enum_name_declaration)* RBrace packed_dimension*
    | TString
    | TChandle
    | TVirtual TInterface? interface_identifier parameter_value_assignment?
      (DotOp modport_identifier)?
    | (class_scope | package_scope)? type_identifier packed_dimension*
    | class_type
    | TEvent
    | ps_covergroup_identifier
    | type_reference
    ;

data_type_or_implicit
    : data_type
    | implicit_data_type
    ;

implicit_data_type
    : signing? packed_dimension*
    ;

enum_base_type
    : integer_atom_type signing?
    | integer_vector_type signing? packed_dimension?
    | type_identifier packed_dimension?
    ;

enum_name_declaration
    : enum_identifier
      (LBracket integral_number (Colon integral_number)? RBracket)?
      (OpAssign constant_expression)?
    ;

class_scope
    : class_type ScopeOp
    ;

class_type
    : ps_class_identifier parameter_value_assignment?
      (ScopeOp class_identifier parameter_value_assignment?)*
    ;

integer_type
    : integer_vector_type
    | integer_atom_type
    ;

integer_atom_type
    : TByte
    | TShortint
    | TInt
    | TLongint
    | TInteger
    | TTime
    ;

integer_vector_type
    : TBit
    | TLogic
    | TReg
    ;

non_integer_type
    : TShortreal
    | TReal
    | TRealtime
    ;

net_type
    : TSupply0
    | TSupply1
    | TTri
    | TTriand
    | TTrior
    | TTrireg
    | TTri0
    | TTri1
    | TUwire
    | TWire
    | TWand
    | TWor
    ;

net_port_type
    : net_type? data_type_or_implicit
    | net_type_identifier
    | TInterconnect implicit_data_type
    ;

variable_port_type
    : var_data_type
    ;

var_data_type
    : data_type
    | TVar data_type_or_implicit
    ;

signing
    : TSigned
    | TUnsigned
    ;

simple_type
    : integer_type
    | non_integer_type
    | ps_type_identifier
    | ps_parameter_identifier
    ;

struct_union_member
    : attribute_instance* random_qualifier? data_type_or_void list_of_variable_decl_assignments Semi
    ;

data_type_or_void
    : data_type
    | TVoid
    ;

struct_union
    : TStruct
    | TUnion TTagged?
    ;

type_reference
    : TType LParen expression RParen
    | TType LParen data_type RParen
    ;

// ── A.2.2.2  Strengths ───────────────────────────────────────

drive_strength
    : LParen strength0 Comma strength1 RParen
    | LParen strength1 Comma strength0 RParen
    | LParen strength0 Comma THighz1   RParen
    | LParen strength1 Comma THighz0   RParen
    | LParen THighz0   Comma strength1 RParen
    | LParen THighz1   Comma strength0 RParen
    ;

strength0
    : TSupply0
    | TStrong0
    | TPull0
    | TWeak0
    ;

strength1
    : TSupply1
    | TStrong1
    | TPull1
    | TWeak1
    ;

charge_strength
    : LParen TSmall  RParen
    | LParen TMedium RParen
    | LParen TLarge  RParen
    ;

// ── A.2.2.3  Delays ──────────────────────────────────────────

delay3
    : Hash delay_value
    | Hash LParen mintypmax_expression
           (Comma mintypmax_expression (Comma mintypmax_expression)?)? RParen
    ;

delay2
    : Hash delay_value
    | Hash LParen mintypmax_expression (Comma mintypmax_expression)? RParen
    ;

delay_value
    : unsigned_number
    | real_number
    | ps_identifier
    | time_literal
    | T1step
    ;


// ════════════════════════════════════════════════════════════
// A.2.3  DECLARATION LISTS
// ════════════════════════════════════════════════════════════

list_of_defparam_assignments
    : defparam_assignment (Comma defparam_assignment)*
    ;

list_of_genvar_identifiers
    : genvar_identifier (Comma genvar_identifier)*
    ;

list_of_interface_identifiers
    : interface_identifier unpacked_dimension*
      (Comma interface_identifier unpacked_dimension*)*
    ;

list_of_net_decl_assignments
    : net_decl_assignment (Comma net_decl_assignment)*
    ;

list_of_param_assignments
    : param_assignment (Comma param_assignment)*
    ;

list_of_port_identifiers
    : port_identifier unpacked_dimension*
      (Comma port_identifier unpacked_dimension*)*
    ;

list_of_specparam_assignments
    : specparam_assignment (Comma specparam_assignment)*
    ;

list_of_tf_variable_identifiers
    : port_identifier variable_dimension* (OpAssign expression)?
      (Comma port_identifier variable_dimension* (OpAssign expression)?)*
    ;

list_of_type_assignments
    : type_assignment (Comma type_assignment)*
    ;

list_of_udp_port_identifiers
    : port_identifier (Comma port_identifier)*
    ;

list_of_variable_decl_assignments
    : variable_decl_assignment (Comma variable_decl_assignment)*
    ;

list_of_variable_identifiers
    : variable_identifier variable_dimension*
      (Comma variable_identifier variable_dimension*)*
    ;

list_of_variable_port_identifiers
    : port_identifier variable_dimension* (OpAssign constant_expression)?
      (Comma port_identifier variable_dimension* (OpAssign constant_expression)?)*
    ;


// ════════════════════════════════════════════════════════════
// A.2.4  DECLARATION ASSIGNMENTS
// ════════════════════════════════════════════════════════════

defparam_assignment
    : hierarchical_parameter_identifier OpAssign constant_mintypmax_expression
    ;

net_decl_assignment
    : net_identifier unpacked_dimension* (OpAssign expression)?
    ;

param_assignment
    : parameter_identifier unpacked_dimension* (OpAssign constant_param_expression)?
    ;

specparam_assignment
    : specparam_identifier OpAssign constant_mintypmax_expression
    | pulse_control_specparam
    ;

type_assignment
    : type_identifier (OpAssign data_type)?
    ;

pulse_control_specparam
    : TPathpulse OpAssign LParen reject_limit_value (Comma error_limit_value)? RParen
    ;

error_limit_value  : limit_value;
reject_limit_value : limit_value;
limit_value        : constant_mintypmax_expression;

variable_decl_assignment
    : variable_identifier variable_dimension* (OpAssign expression)?
    | dynamic_array_variable_identifier unsized_dimension variable_dimension*
      (OpAssign dynamic_array_new)?
    | class_variable_identifier (OpAssign class_new)?
    ;

class_new
    : class_scope? TNew (LParen list_of_arguments RParen)?
    | TNew expression
    ;

dynamic_array_new
    : TNew expression? (LParen expression RParen)?
    ;


// ════════════════════════════════════════════════════════════
// A.2.5  DECLARATION RANGES
// ════════════════════════════════════════════════════════════

unpacked_dimension
    : LBracket constant_range      RBracket
    | LBracket constant_expression RBracket
    ;

packed_dimension
    : LBracket constant_range RBracket
    | unsized_dimension
    ;

associative_dimension
    : LBracket data_type RBracket
    | LBracket OpMul     RBracket
    ;

variable_dimension
    : unsized_dimension
    | unpacked_dimension
    | associative_dimension
    | queue_dimension
    ;

queue_dimension
    : LBracket Dollar (Colon constant_expression)? RBracket
    ;

unsized_dimension
    : LBracket RBracket
    ;


// ════════════════════════════════════════════════════════════
// A.2.6  FUNCTION DECLARATIONS
// ════════════════════════════════════════════════════════════

function_data_type_or_implicit
    : data_type_or_void
    | implicit_data_type
    ;

function_declaration
    : TFunction lifetime? function_body_declaration
    ;

function_body_declaration
    : function_data_type_or_implicit (interface_identifier DotOp | class_scope)?
      function_identifier Semi tf_item_declaration* function_statement_or_null*
      TEndfunction (Colon function_identifier)?
    | function_data_type_or_implicit (interface_identifier DotOp | class_scope)?
      function_identifier LParen tf_port_list RParen Semi block_item_declaration*
      function_statement_or_null* TEndfunction (Colon function_identifier)?
    ;

function_prototype
    : TFunction data_type_or_void function_identifier (LParen tf_port_list RParen)?
    ;

dpi_import_export
    : TImport dpi_spec_string dpi_function_import_property? (CIdentifier OpAssign)? dpi_function_proto Semi
    | TImport dpi_spec_string dpi_task_import_property?     (CIdentifier OpAssign)? dpi_task_proto    Semi
    | TExport dpi_spec_string (CIdentifier OpAssign)? TFunction function_identifier Semi
    | TExport dpi_spec_string (CIdentifier OpAssign)? TTask    task_identifier      Semi
    ;

dpi_spec_string
    : TDPIC
    | TDPI
    ;

dpi_function_import_property
    : TContext
    | TPure
    ;

dpi_task_import_property
    : TContext
    ;

dpi_function_proto : function_prototype;
dpi_task_proto     : task_prototype;


// ════════════════════════════════════════════════════════════
// A.2.7  TASK DECLARATIONS
// ════════════════════════════════════════════════════════════

task_declaration
    : TTask lifetime? task_body_declaration
    ;

task_body_declaration
    : (interface_identifier DotOp | class_scope)? task_identifier Semi
      tf_item_declaration* statement_or_null* TEndtask (Colon task_identifier)?
    | (interface_identifier DotOp | class_scope)? task_identifier
      LParen tf_port_list RParen Semi block_item_declaration*
      statement_or_null* TEndtask (Colon task_identifier)?
    ;

tf_item_declaration
    : block_item_declaration
    | tf_port_declaration
    ;

tf_port_list
    : tf_port_item (Comma tf_port_item)*
    ;

tf_port_item
    : attribute_instance* tf_port_direction? TVar? data_type_or_implicit
      (port_identifier variable_dimension* (OpAssign expression)?)?
    ;

tf_port_direction
    : port_direction
    | TConst TRef
    ;

tf_port_declaration
    : attribute_instance* tf_port_direction TVar? data_type_or_implicit
      list_of_tf_variable_identifiers Semi
    ;

task_prototype
    : TTask task_identifier (LParen tf_port_list RParen)?
    ;


// ════════════════════════════════════════════════════════════
// A.2.8  BLOCK ITEM DECLARATIONS
// ════════════════════════════════════════════════════════════

block_item_declaration
    : attribute_instance* data_declaration
    | attribute_instance* local_parameter_declaration Semi
    | attribute_instance* parameter_declaration Semi
    | attribute_instance* overload_declaration
    | attribute_instance* let_declaration
    ;

overload_declaration
    : TBind overload_operator TFunction data_type function_identifier
      LParen overload_proto_formals RParen Semi
    ;

overload_operator
    : OpAdd | OpInc | OpSub | OpDec | OpMul | OpPow | OpDiv | OpMod
    | OpEq  | OpNe  | OpLt  | OpLe  | OpGt  | OpGe  | OpAssign
    ;

overload_proto_formals
    : data_type (Comma data_type)*
    ;


// ════════════════════════════════════════════════════════════
// A.2.9  INTERFACE DECLARATIONS (modport)
// ════════════════════════════════════════════════════════════

modport_declaration
    : TModport modport_item (Comma modport_item)* Semi
    ;

modport_item
    : modport_identifier LParen modport_ports_declaration (Comma modport_ports_declaration)* RParen
    ;

modport_ports_declaration
    : attribute_instance* modport_simple_ports_declaration
    | attribute_instance* modport_tf_ports_declaration
    | attribute_instance* modport_clocking_declaration
    ;

modport_clocking_declaration
    : TClocking clocking_identifier
    ;

modport_simple_ports_declaration
    : port_direction modport_simple_port (Comma modport_simple_port)*
    ;

modport_simple_port
    : port_identifier
    | DotOp port_identifier LParen expression? RParen
    ;

modport_tf_ports_declaration
    : import_export modport_tf_port (Comma modport_tf_port)*
    ;

modport_tf_port
    : method_prototype
    | tf_identifier
    ;

import_export
    : TImport
    | TExport
    ;


// ════════════════════════════════════════════════════════════
// A.2.10  ASSERTION DECLARATIONS
// ════════════════════════════════════════════════════════════

concurrent_assertion_item
    : (block_identifier Colon)? concurrent_assertion_statement
    | checker_instantiation
    ;

concurrent_assertion_statement
    : assert_property_statement
    | assume_property_statement
    | cover_property_statement
    | cover_sequence_statement
    | restrict_property_statement
    ;

assert_property_statement
    : TAssert TProperty LParen property_spec RParen action_block
    ;

assume_property_statement
    : TAssume TProperty LParen property_spec RParen action_block
    ;

cover_property_statement
    : TCover TProperty LParen property_spec RParen statement_or_null
    ;

expect_property_statement
    : TExpect LParen property_spec RParen action_block
    ;

cover_sequence_statement
    : TCover TSequence LParen clocking_event?
      (TDisable TIff LParen expression_or_dist RParen)? sequence_expr RParen
      statement_or_null
    ;

restrict_property_statement
    : TRestrict TProperty LParen property_spec RParen Semi
    ;

property_instance
    : ps_or_hierarchical_property_identifier (LParen property_list_of_arguments RParen)?
    ;

property_list_of_arguments
    : property_actual_arg? (Comma property_actual_arg?)*
      (Comma DotOp identifier LParen property_actual_arg? RParen)*
    | DotOp identifier LParen property_actual_arg? RParen
      (Comma DotOp identifier LParen property_actual_arg? RParen)*
    ;

property_actual_arg
    : property_expr
    | sequence_actual_arg
    ;

assertion_item_declaration
    : property_declaration
    | sequence_declaration
    | let_declaration
    ;

property_declaration
    : TProperty property_identifier (LParen property_port_list? RParen)? Semi
      assertion_variable_declaration* property_spec Semi? TEndproperty (Colon property_identifier)?
    ;

property_port_list
    : property_port_item (Comma property_port_item)*
    ;

property_port_item
    : attribute_instance* (TLocal property_lvar_port_direction?)? property_formal_type
      formal_port_identifier variable_dimension* (OpAssign property_actual_arg)?
    ;

property_lvar_port_direction
    : TInput
    ;

property_formal_type
    : sequence_formal_type
    | TProperty
    ;

property_spec
    : clocking_event? (TDisable TIff LParen expression_or_dist RParen)? property_expr
    ;

property_expr
    : sequence_expr
    | TStrong LParen sequence_expr RParen
    | TWeak   LParen sequence_expr RParen
    | LParen property_expr RParen
    | TNot property_expr
    | property_expr TOr  property_expr
    | property_expr TAnd property_expr
    | sequence_expr OpOverlapImpl    property_expr
    | sequence_expr OpNonOverlapImpl property_expr
    | TIf LParen expression_or_dist RParen property_expr (TElse property_expr)?
    | TCase LParen expression_or_dist RParen property_case_item property_case_item* TEndcase
    | sequence_expr OpFollowedBy   property_expr
    | sequence_expr OpFollowedByNO property_expr
    | TNexttime property_expr
    | TNexttime LBracket constant_expression RBracket property_expr
    | TSNexttime property_expr
    | TSNexttime LBracket constant_expression RBracket property_expr
    | TAlways property_expr
    | TAlways LBracket cycle_delay_const_range_expression RBracket property_expr
    | TSAlways LBracket constant_range RBracket property_expr
    | TSEventually property_expr
    | TEventually  LBracket constant_range RBracket property_expr
    | TSEventually LBracket cycle_delay_const_range_expression RBracket property_expr
    | property_expr TUntil     property_expr
    | property_expr TSUntil    property_expr
    | property_expr TSUntilWith property_expr
    | property_expr TImplies property_expr
    | property_expr TIff     property_expr
    | TAcceptOn    LParen expression_or_dist RParen property_expr
    | TRejectOn    LParen expression_or_dist RParen property_expr
    | TSyncAcceptOn LParen expression_or_dist RParen property_expr
    | TSyncRejectOn LParen expression_or_dist RParen property_expr
    | property_instance
    | clocking_event property_expr
    ;

property_case_item
    : expression_or_dist (Comma expression_or_dist)* Colon property_expr Semi?
    | TDefault Colon? property_expr Semi?
    ;

sequence_declaration
    : TSequence sequence_identifier (LParen sequence_port_list? RParen)? Semi
      assertion_variable_declaration* sequence_expr Semi? TEndsequence (Colon sequence_identifier)?
    ;

sequence_port_list
    : sequence_port_item (Comma sequence_port_item)*
    ;

sequence_port_item
    : attribute_instance* (TLocal sequence_lvar_port_direction?)? sequence_formal_type
      formal_port_identifier variable_dimension* (OpAssign sequence_actual_arg)?
    ;

sequence_lvar_port_direction
    : TInput
    | TInout
    | TOutput
    ;

sequence_formal_type
    : data_type_or_implicit
    | TSequence
    | TUntyped
    ;

sequence_expr
    : cycle_delay_range sequence_expr cycle_delay_range sequence_expr*
    | sequence_expr cycle_delay_range sequence_expr cycle_delay_range sequence_expr*
    | expression_or_dist boolean_abbrev?
    | sequence_instance sequence_abbrev?
    | LParen sequence_expr (Comma sequence_match_item)* RParen sequence_abbrev?
    | sequence_expr TAnd       sequence_expr
    | sequence_expr TIntersect sequence_expr
    | sequence_expr TOr        sequence_expr
    | TFirstMatch LParen sequence_expr (Comma sequence_match_item)* RParen
    | expression_or_dist TThroughout sequence_expr
    | sequence_expr TWithin sequence_expr
    | clocking_event sequence_expr
    ;

cycle_delay_range
    : SeqDelay constant_primary
    | SeqDelay LBracket cycle_delay_const_range_expression RBracket
    | SeqDelayAny
    | SeqDelayPlus
    ;

sequence_method_call
    : sequence_instance DotOp method_identifier
    ;

sequence_match_item
    : operator_assignment
    | inc_or_dec_expression
    | subroutine_call
    ;

sequence_instance
    : ps_or_hierarchical_sequence_identifier (LParen sequence_list_of_arguments RParen)?
    ;

sequence_list_of_arguments
    : sequence_actual_arg? (Comma sequence_actual_arg?)*
      (Comma DotOp identifier LParen sequence_actual_arg? RParen)*
    | DotOp identifier LParen sequence_actual_arg? RParen
      (Comma DotOp identifier LParen sequence_actual_arg? RParen)*
    ;

sequence_actual_arg
    : event_expression
    | sequence_expr
    ;

boolean_abbrev
    : consecutive_repetition
    | non_consecutive_repetition
    | goto_repetition
    ;

sequence_abbrev
    : consecutive_repetition
    ;

consecutive_repetition
    : RepConsecOpen const_or_range_expression RBracket
    | RepeatStar
    | RepeatPlus
    ;

non_consecutive_repetition
    : RepNonConsecOpen const_or_range_expression RBracket
    ;

goto_repetition
    : RepGotoOpen const_or_range_expression RBracket
    ;

const_or_range_expression
    : constant_expression
    | cycle_delay_const_range_expression
    ;

cycle_delay_const_range_expression
    : constant_expression Colon constant_expression
    | constant_expression Colon Dollar
    ;

expression_or_dist
    : expression (TDist dist_list*)?
    ;

assertion_variable_declaration
    : var_data_type list_of_variable_decl_assignments Semi
    ;

let_declaration
    : TLet let_identifier (LParen let_port_list? RParen)? OpAssign expression Semi
    ;

let_identifier : identifier;

let_port_list
    : let_port_item (Comma let_port_item)*
    ;

let_port_item
    : attribute_instance* let_formal_type formal_port_identifier variable_dimension*
      (OpAssign expression)?
    ;

let_formal_type
    : data_type_or_implicit
    | TUntyped
    ;

let_expression
    : package_scope? let_identifier (LParen let_list_of_arguments RParen)?
    ;

let_list_of_arguments
    : let_actual_arg? (Comma let_actual_arg?)*
      (Comma DotOp identifier LParen let_actual_arg? RParen)*
    | DotOp identifier LParen let_actual_arg? RParen
      (Comma DotOp identifier LParen let_actual_arg? RParen)*
    ;

let_actual_arg : expression;


// ════════════════════════════════════════════════════════════
// A.2.11  COVERGROUP DECLARATIONS
// ════════════════════════════════════════════════════════════

covergroup_declaration
    : TCovergroup covergroup_identifier (LParen tf_port_list RParen)? coverage_event? Semi
      coverage_spec_or_option* TEndgroup (Colon covergroup_identifier)?
    ;

coverage_spec_or_option
    : attribute_instance* coverage_spec
    | attribute_instance* coverage_option Semi
    ;

coverage_option
    : TOption     DotOp member_identifier OpAssign expression
    | TTypeOption DotOp member_identifier OpAssign constant_expression
    ;

coverage_spec
    : cover_point
    | cover_cross
    ;

coverage_event
    : clocking_event
    | TWith TFunction TSample LParen tf_port_list RParen
    | At At LParen block_event_expression RParen
    ;

block_event_expression
    : block_event_expression TOr block_event_expression
    | TBegin hierarchical_btf_identifier
    | TEnd   hierarchical_btf_identifier
    ;

hierarchical_btf_identifier
    : hierarchical_tf_identifier
    | hierarchical_block_identifier
    | (hierarchical_identifier DotOp | class_scope)? method_identifier
    ;

cover_point
    : (data_type_or_implicit cover_point_identifier Colon)?
      TCoverpoint expression (TIff LParen expression RParen)? bins_or_empty
    ;

bins_or_empty
    : LBrace attribute_instance* (bins_or_options Semi)* RBrace
    | Semi
    ;

bins_or_options
    : coverage_option
    | TWildcard? bins_keyword bin_identifier (LBracket covergroup_expression? RBracket)?
      OpAssign LBrace covergroup_range_list RBrace
      (TWith LParen with_covergroup_expression RParen)? (TIff LParen expression RParen)?
    | TWildcard? bins_keyword bin_identifier (LBracket covergroup_expression? RBracket)?
      OpAssign cover_point_identifier
      (TWith LParen with_covergroup_expression RParen)? (TIff LParen expression RParen)?
    | TWildcard? bins_keyword bin_identifier (LBracket covergroup_expression? RBracket)?
      OpAssign set_covergroup_expression (TIff LParen expression RParen)?
    | TWildcard? bins_keyword bin_identifier LBracket RBracket
      OpAssign trans_list (TIff LParen expression RParen)?
    | bins_keyword bin_identifier (LBracket covergroup_expression? RBracket)?
      OpAssign TDefault (TIff LParen expression RParen)?
    | bins_keyword bin_identifier OpAssign TDefault TSequence (TIff LParen expression RParen)?
    ;

bins_keyword
    : TBins
    | TIllegalBins
    | TIgnoreBins
    ;

trans_list : LParen trans_set RParen (Comma LParen trans_set RParen)*;
trans_set  : trans_range_list (OpNonOverlapImpl trans_range_list)*;

trans_range_list
    : trans_item
    | trans_item RepConsecOpen    repeat_range RBracket
    | trans_item RepGotoOpen      repeat_range RBracket
    | trans_item RepNonConsecOpen repeat_range RBracket
    ;

trans_item : covergroup_range_list;

repeat_range
    : covergroup_expression
    | covergroup_expression Colon covergroup_expression
    ;

cover_cross
    : (cross_identifier Colon)?
      TCross list_of_cross_items (TIff LParen expression RParen)? cross_body
    ;

list_of_cross_items
    : cross_item Comma cross_item (Comma cross_item)*
    ;

cross_item
    : cover_point_identifier
    | variable_identifier
    ;

cross_body
    : LBrace (cross_body_item Semi)* RBrace
    | Semi
    ;

cross_body_item
    : function_declaration
    | bins_selection_or_option Semi
    ;

bins_selection_or_option
    : attribute_instance* coverage_option
    | attribute_instance* bins_selection
    ;

bins_selection
    : bins_keyword bin_identifier OpAssign select_expression (TIff LParen expression RParen)?
    ;

select_expression
    : select_condition
    | OpLogNot select_condition
    | select_expression OpLogAnd select_expression
    | select_expression OpLogOr  select_expression
    | LParen select_expression RParen
    | select_expression TWith LParen with_covergroup_expression RParen
      (TMatches integer_covergroup_expression)?
    | cross_identifier
    | cross_set_expression (TMatches integer_covergroup_expression)?
    ;

select_condition
    : TBinsOf LParen bins_expression RParen
      (TIntersect LBrace covergroup_range_list RBrace)?
    ;

bins_expression
    : variable_identifier
    | cover_point_identifier (DotOp bin_identifier)?
    ;

covergroup_range_list
    : covergroup_value_range (Comma covergroup_value_range)*
    ;

covergroup_value_range
    : covergroup_expression
    | LBracket covergroup_expression Colon covergroup_expression RBracket
    ;

with_covergroup_expression    : covergroup_expression;
set_covergroup_expression     : covergroup_expression;
integer_covergroup_expression : covergroup_expression;
cross_set_expression          : covergroup_expression;
covergroup_expression         : expression;


// ════════════════════════════════════════════════════════════
// A.4  INSTANTIATIONS
// ════════════════════════════════════════════════════════════

// ── A.4.1.1  Module instantiation ────────────────────────────

module_instantiation
    : module_identifier parameter_value_assignment?
      hierarchical_instance (Comma hierarchical_instance)* Semi
    ;

parameter_value_assignment
    : Hash LParen list_of_parameter_assignments? RParen
    ;

list_of_parameter_assignments
    : ordered_parameter_assignment (Comma ordered_parameter_assignment)*
    | named_parameter_assignment   (Comma named_parameter_assignment)*
    ;

ordered_parameter_assignment : param_expression;

named_parameter_assignment
    : DotOp parameter_identifier LParen param_expression? RParen
    ;

hierarchical_instance
    : name_of_instance LParen list_of_port_connections RParen
    ;

name_of_instance
    : instance_identifier unpacked_dimension*
    ;

list_of_port_connections
    : ordered_port_connection (Comma ordered_port_connection)*
    | named_port_connection   (Comma named_port_connection)*
    ;

ordered_port_connection
    : attribute_instance* expression?
    ;

named_port_connection
    : attribute_instance* DotOp port_identifier (LParen expression? RParen)?
    | attribute_instance* DotStar
    ;

// ── A.4.1.2  Interface instantiation ─────────────────────────

interface_instantiation
    : interface_identifier parameter_value_assignment?
      hierarchical_instance (Comma hierarchical_instance)* Semi
    ;

// ── A.4.1.3  Program instantiation ───────────────────────────

program_instantiation
    : program_identifier parameter_value_assignment?
      hierarchical_instance (Comma hierarchical_instance)* Semi
    ;

// ── A.4.1.4  Checker instantiation ───────────────────────────

checker_instantiation
    : ps_checker_identifier name_of_instance LParen list_of_checker_port_connections RParen Semi
    ;

list_of_checker_port_connections
    : ordered_checker_port_connection (Comma ordered_checker_port_connection)*
    | named_checker_port_connection   (Comma named_checker_port_connection)*
    ;

ordered_checker_port_connection
    : attribute_instance* property_actual_arg?
    ;

named_checker_port_connection
    : attribute_instance* DotOp formal_port_identifier (LParen property_actual_arg? RParen)?
    | attribute_instance* DotStar
    ;

// ── A.4.2  Generated instantiation ───────────────────────────

generate_region
    : TGenerate generate_item* TEndgenerate
    ;

loop_generate_construct
    : TFor LParen genvar_initialization Semi genvar_expression Semi genvar_iteration RParen
      generate_block
    ;

genvar_initialization
    : TGenvar? genvar_identifier OpAssign constant_expression
    ;

genvar_iteration
    : genvar_identifier assignment_operator genvar_expression
    | inc_or_dec_operator genvar_identifier
    | genvar_identifier inc_or_dec_operator
    ;

conditional_generate_construct
    : if_generate_construct
    | case_generate_construct
    ;

if_generate_construct
    : TIf LParen constant_expression RParen generate_block (TElse generate_block)?
    ;

case_generate_construct
    : TCase LParen constant_expression RParen case_generate_item case_generate_item* TEndcase
    ;

case_generate_item
    : constant_expression (Comma constant_expression)* Colon generate_block
    | TDefault Colon? generate_block
    ;

generate_block
    : generate_item
    | (generate_block_identifier Colon)?
      TBegin (Colon generate_block_identifier)?
      generate_item*
      TEnd (Colon generate_block_identifier)?
    ;

generate_item
    : module_or_generate_item
    | interface_or_generate_item
    | checker_or_generate_item
    ;


// ════════════════════════════════════════════════════════════
// A.6  BEHAVIORAL STATEMENTS
// ════════════════════════════════════════════════════════════

// ── A.6.1  Continuous assignment and net alias ────────────────

continuous_assign
    : TAssign drive_strength? delay3?  list_of_net_assignments Semi
    | TAssign delay_control?           list_of_variable_assignments Semi
    ;

list_of_net_assignments
    : net_assignment (Comma net_assignment)*
    ;

list_of_variable_assignments
    : variable_assignment (Comma variable_assignment)*
    ;

net_alias
    : TAlias net_lvalue OpAssign net_lvalue (OpAssign net_lvalue)* Semi
    ;

net_assignment
    : net_lvalue OpAssign expression
    ;

// ── A.6.2  Procedural blocks and assignments ──────────────────

initial_construct : TInitial statement_or_null;
always_construct  : always_keyword statement;

always_keyword
    : TAlways
    | TAlwaysComb
    | TAlwaysLatch
    | TAlwaysFF
    ;

final_construct : TFinal function_statement;

blocking_assignment
    : variable_lvalue OpAssign delay_or_event_control expression
    | nonrange_variable_lvalue OpAssign dynamic_array_new
    | (implicit_class_handle DotOp | class_scope | package_scope)
      hierarchical_variable_identifier select OpNe class_new
    | operator_assignment
    ;

operator_assignment
    : variable_lvalue assignment_operator expression
    ;

assignment_operator
    : OpAssign
    | OpAddAssign | OpSubAssign | OpMulAssign | OpDivAssign | OpModAssign
    | OpAndAssign | OpOrAssign  | OpXorAssign
    | OpShlAssign | OpShrAssign | OpArithShlAssign | OpArithShrAssign
    ;

nonblocking_assignment
    : variable_lvalue OpNBA delay_or_event_control? expression
    ;

procedural_continuous_assignment
    : TAssign   variable_assignment
    | TDeassign variable_lvalue
    | TForce    variable_assignment
    | TForce    net_assignment
    | TRelease  variable_lvalue
    | TRelease  net_lvalue
    ;

variable_assignment
    : variable_lvalue OpAssign expression
    ;

// ── A.6.3  Parallel and sequential blocks ────────────────────

action_block
    : statement_or_null
    | statement? TElse statement_or_null
    ;

seq_block
    : TBegin (Colon block_identifier)?
      block_item_declaration* statement_or_null*
      TEnd (Colon block_identifier)?
    ;

par_block
    : TFork (Colon block_identifier)?
      block_item_declaration* statement_or_null*
      join_keyword (Colon block_identifier)?
    ;

join_keyword
    : TJoin
    | TJoinAny
    | TJoinNone
    ;

// ── A.6.4  Statements ─────────────────────────────────────────

statement_or_null
    : statement
    | attribute_instance* Semi
    ;

statement
    : (block_identifier Colon)? attribute_instance* statement_item
    ;

statement_item
    : blocking_assignment Semi
    | nonblocking_assignment Semi
    | procedural_continuous_assignment Semi
    | case_statement
    | conditional_statement
    | inc_or_dec_expression Semi
    | subroutine_call_statement
    | disable_statement
    | event_trigger
    | loop_statement
    | jump_statement
    | par_block
    | procedural_timing_control_statement
    | seq_block
    | wait_statement
    | procedural_assertion_statement
    | clocking_drive Semi
    | randsequence_statement
    | randcase_statement
    | expect_property_statement
    ;

function_statement         : statement;
function_statement_or_null : function_statement | attribute_instance* Semi;
variable_identifier_list   : variable_identifier (Comma variable_identifier)*;

// ── A.6.5  Timing control statements ─────────────────────────

procedural_timing_control_statement
    : procedural_timing_control statement_or_null
    ;

delay_or_event_control
    : delay_control
    | event_control
    | TRepeat LParen expression RParen event_control
    ;

delay_control
    : Hash delay_value
    | Hash LParen mintypmax_expression RParen
    ;

event_control
    : At hierarchical_event_identifier
    | At LParen event_expression RParen
    | At OpMul
    | At LParen OpMul RParen
    | At ps_or_hierarchical_sequence_identifier
    ;

event_expression
    : edge_identifier? expression (TIff expression)?
    | sequence_instance (TIff expression)?
    | event_expression TOr event_expression
    | event_expression Comma event_expression
    | LParen event_expression RParen
    ;

procedural_timing_control
    : delay_control
    | event_control
    | cycle_delay
    ;

jump_statement
    : TReturn expression? Semi
    | TBreak Semi
    | TContinue Semi
    ;

wait_statement
    : TWait LParen expression RParen statement_or_null
    | TWait TFork Semi
    | TWaitOrder LParen hierarchical_identifier (Comma hierarchical_identifier)* RParen action_block
    ;

event_trigger
    : OpImplication hierarchical_event_identifier Semi
    | OpNonOverlapSeq delay_or_event_control? hierarchical_event_identifier Semi
    ;

disable_statement
    : TDisable hierarchical_task_identifier Semi
    | TDisable hierarchical_block_identifier Semi
    | TDisable TFork Semi
    ;

// ── A.6.6  Conditional statements ────────────────────────────

conditional_statement
    : unique_priority? TIf LParen cond_predicate RParen statement_or_null
      (TElse TIf LParen cond_predicate RParen statement_or_null)*
      (TElse statement_or_null)?
    ;

unique_priority
    : TUnique
    | TUnique0
    | TPriority
    ;

cond_predicate
    : expression_or_cond_pattern (OpArithShlAssign expression_or_cond_pattern)*
    ;

expression_or_cond_pattern
    : expression (TMatches pattern)?
    ;

// ── A.6.7  Case statements ────────────────────────────────────

case_statement
    : unique_priority? case_keyword LParen case_expression RParen case_item case_item* TEndcase
    | unique_priority? case_keyword LParen case_expression RParen TMatches
      case_pattern_item case_pattern_item* TEndcase
    | unique_priority? TCase LParen case_expression RParen TInside
      case_inside_item case_inside_item* TEndcase
    ;

case_keyword
    : TCase
    | TCasez
    | TCasex
    ;

case_expression : expression;

case_item
    : case_item_expression (Comma case_item_expression)* Colon statement_or_null
    | TDefault Colon? statement_or_null
    ;

case_pattern_item
    : pattern (OpArithShlAssign expression)? Colon statement_or_null
    | TDefault Colon? statement_or_null
    ;

case_inside_item
    : open_range_list Colon statement_or_null
    | TDefault Colon? statement_or_null
    ;

case_item_expression : expression;

randcase_statement
    : TRandcase randcase_item randcase_item* TEndcase
    ;

randcase_item
    : expression Colon statement_or_null
    ;

open_range_list  : open_value_range (Comma open_value_range)*;
open_value_range : value_range;

// ── A.6.7.1  Patterns ─────────────────────────────────────────

pattern
    : DotOp variable_identifier
    | DotStar
    | constant_expression
    | TTagged member_identifier pattern?
    | Tick LBrace pattern (Comma pattern)* RBrace
    | Tick LBrace member_identifier Colon pattern
              (Comma member_identifier Colon pattern)* RBrace
    ;

assignment_pattern
    : Tick LBrace expression (Comma expression)* RBrace
    | Tick LBrace structure_pattern_key Colon expression
               (Comma structure_pattern_key Colon expression)* RBrace
    | Tick LBrace array_pattern_key Colon expression
               (Comma array_pattern_key Colon expression)* RBrace
    | Tick LBrace constant_expression LBrace expression (Comma expression)* RBrace RBrace
    ;

structure_pattern_key
    : member_identifier
    | assignment_pattern_key
    ;

array_pattern_key
    : constant_expression
    | assignment_pattern_key
    ;

assignment_pattern_key
    : simple_type
    | TDefault
    ;

assignment_pattern_expression
    : assignment_pattern_expression_type? assignment_pattern
    ;

assignment_pattern_expression_type
    : ps_type_identifier
    | ps_parameter_identifier
    | integer_atom_type
    | type_reference
    ;

constant_assignment_pattern_expression : assignment_pattern_expression;
assignment_pattern_net_lvalue          : Tick LBrace net_lvalue      (Comma net_lvalue)*      RBrace;
assignment_pattern_variable_lvalue     : Tick LBrace variable_lvalue (Comma variable_lvalue)* RBrace;

// ── A.6.8  Looping statements ─────────────────────────────────

loop_statement
    : TForever statement_or_null
    | TRepeat LParen expression RParen statement_or_null
    | TWhile  LParen expression RParen statement_or_null
    | TFor LParen for_initialization? Semi expression? Semi for_step? RParen statement_or_null
    | TDo statement_or_null TWhile LParen expression RParen Semi
    | TForeach LParen ps_or_hierarchical_array_identifier
               LBracket loop_variables RBracket RParen statement
    ;

for_initialization
    : list_of_variable_assignments
    | for_variable_declaration (Comma for_variable_declaration)*
    ;

for_variable_declaration
    : TVar? data_type variable_identifier OpAssign expression
      (Comma variable_identifier OpAssign expression)*
    ;

for_step
    : for_step_assignment (Comma for_step_assignment)*
    ;

for_step_assignment
    : operator_assignment
    | inc_or_dec_expression
    | function_subroutine_call
    ;

loop_variables
    : index_variable_identifier? (Comma index_variable_identifier?)*
    ;

// ── A.6.9  Subroutine call statements ────────────────────────

subroutine_call_statement
    : subroutine_call Semi
    | TVoid Tick LParen function_subroutine_call RParen Semi
    ;

// ── A.6.10  Assertion statements ─────────────────────────────

assertion_item
    : concurrent_assertion_item
    | deferred_immediate_assertion_item
    ;

deferred_immediate_assertion_item
    : (block_identifier Colon)? deferred_immediate_assertion_statement
    ;

procedural_assertion_statement
    : concurrent_assertion_statement
    | immediate_assertion_statement
    | checker_instantiation
    ;

immediate_assertion_statement
    : simple_immediate_assertion_statement
    | deferred_immediate_assertion_statement
    ;

simple_immediate_assertion_statement
    : simple_immediate_assert_statement
    | simple_immediate_assume_statement
    | simple_immediate_cover_statement
    ;

simple_immediate_assert_statement : TAssert LParen expression RParen action_block;
simple_immediate_assume_statement : TAssume LParen expression RParen action_block;
simple_immediate_cover_statement  : TCover  LParen expression RParen statement_or_null;

deferred_immediate_assertion_statement
    : deferred_immediate_assert_statement
    | deferred_immediate_assume_statement
    | deferred_immediate_cover_statement
    ;

deferred_immediate_assert_statement
    : TAssert Hash Digit0 LParen expression RParen action_block
    | TAssert TFinal      LParen expression RParen action_block
    ;

deferred_immediate_assume_statement
    : TAssume Hash Digit0 LParen expression RParen action_block
    | TAssume TFinal      LParen expression RParen action_block
    ;

deferred_immediate_cover_statement
    : TCover Hash Digit0 LParen expression RParen statement_or_null
    | TCover TFinal      LParen expression RParen statement_or_null
    ;

// ── A.6.11  Clocking block ────────────────────────────────────

clocking_declaration
    : TDefault? TClocking clocking_identifier? clocking_event Semi clocking_item*
      TEndclocking (Colon clocking_identifier)?
    | TGlobal TClocking clocking_identifier? clocking_event Semi
      TEndclocking (Colon clocking_identifier)?
    ;

clocking_event
    : At identifier
    | At LParen event_expression RParen
    ;

clocking_item
    : TDefault default_skew Semi
    | clocking_direction list_of_clocking_decl_assign Semi
    | attribute_instance* assertion_item_declaration
    ;

default_skew
    : TInput clocking_skew
    | TOutput clocking_skew
    | TInput clocking_skew TOutput clocking_skew
    ;

clocking_direction
    : TInput  clocking_skew?
    | TOutput clocking_skew?
    | TInput  clocking_skew? TOutput clocking_skew?
    | TInout
    ;

list_of_clocking_decl_assign
    : clocking_decl_assign (Comma clocking_decl_assign)*
    ;

clocking_decl_assign
    : signal_identifier (OpAssign expression)?
    ;

clocking_skew
    : edge_identifier delay_control?
    | delay_control
    ;

clocking_drive
    : clockvar_expression OpNBA cycle_delay? expression
    ;

cycle_delay
    : SeqDelay integral_number
    | SeqDelay identifier
    | SeqDelay LParen expression RParen
    ;

clockvar            : hierarchical_identifier;
clockvar_expression : clockvar select;

// ── A.6.12  Rand sequence ─────────────────────────────────────

randsequence_statement
    : TRandsequence LParen production_identifier? RParen production+ TEndsequence
    ;

production
    : data_type_or_void? production_identifier (LParen tf_port_list RParen)?
      Colon rs_rule (OpBitOr rs_rule)* Semi
    ;

rs_rule
    : rs_production_list (Colon OpAssign weight_specification rs_code_block?)?
    ;

rs_production_list
    : rs_prod rs_prod*
    | TRand TJoin (LParen expression RParen)?
      production_item production_item production_item*
    ;

weight_specification
    : integral_number
    | ps_identifier LParen expression RParen
    ;

rs_code_block
    : LBrace data_declaration* statement_or_null* RBrace
    ;

rs_prod
    : production_item
    | rs_code_block
    | rs_if_else
    | rs_repeat
    | rs_case
    ;

production_item
    : production_identifier (LParen list_of_arguments RParen)?
    ;

rs_if_else : TIf LParen expression RParen production_item (TElse production_item)?;
rs_repeat  : TRepeat LParen expression RParen production_item;
rs_case    : TCase LParen case_expression RParen rs_case_item rs_case_item* TEndcase;

rs_case_item
    : case_item_expression (Comma case_item_expression)* Colon production_item Semi
    | TDefault Colon? production_item Semi
    ;


// ════════════════════════════════════════════════════════════
// A.7  SPECIFY (partial)
// ════════════════════════════════════════════════════════════

z_or_x
    : XDigitLower | XDigitUpper | ZDigitLower | ZDigitUpper
    ;

edge_identifier
    : TPosedge
    | TNegedge
    | TEdge
    ;


// ════════════════════════════════════════════════════════════
// A.8  EXPRESSIONS
// ════════════════════════════════════════════════════════════

// ── A.8.1  Concatenations ─────────────────────────────────────

concatenation
    : LBrace expression (Comma expression)* RBrace
    ;

constant_concatenation
    : LBrace constant_expression (Comma constant_expression)* RBrace
    ;

constant_multiple_concatenation
    : LBrace constant_expression constant_concatenation RBrace
    ;

module_path_concatenation
    : LBrace module_path_expression (Comma module_path_expression)* RBrace
    ;

module_path_multiple_concatenation
    : LBrace constant_expression module_path_concatenation RBrace
    ;

multiple_concatenation
    : LBrace expression concatenation RBrace
    ;

streaming_concatenation
    : LBrace stream_operator slice_size? stream_concatenation RBrace
    ;

stream_operator
    : OpShr
    | OpShl
    ;

slice_size
    : simple_type
    | constant_expression
    ;

stream_concatenation
    : LBrace stream_expression (Comma stream_expression)* RBrace
    ;

stream_expression
    : expression (TWith LBracket array_range_expression RBracket)?
    ;

array_range_expression
    : expression
    | expression Colon        expression
    | expression OpAddAssign  expression   // '+:'
    | expression OpSubAssign  expression   // '-:'
    ;

empty_queue : LBrace RBrace;

// ── A.8.2  Subroutine calls ───────────────────────────────────

constant_function_call : function_subroutine_call;

tf_call
    : ps_or_hierarchical_tf_identifier attribute_instance* (LParen list_of_arguments RParen)?
    ;

system_tf_call
    : SystemTFIdentifier (LParen list_of_arguments RParen)?
    | SystemTFIdentifier LParen data_type (Comma expression)? RParen
    ;

subroutine_call
    : tf_call
    | system_tf_call
    | method_call
    | SimpleIdentifier ScopeOp SimpleIdentifier randomize_call   // 'std::randomize'
    ;

function_subroutine_call : subroutine_call;

list_of_arguments
    : expression? (Comma expression?)*
      (Comma DotOp identifier LParen expression? RParen)*
    | DotOp identifier LParen expression? RParen
      (Comma DotOp identifier LParen expression? RParen)*
    ;

method_call
    : method_call_root DotOp method_call_body
    ;

method_call_body
    : method_identifier attribute_instance* (LParen list_of_arguments RParen)?
    | built_in_method_call
    ;

built_in_method_call
    : array_manipulation_call
    | randomize_call
    ;

array_manipulation_call
    : array_method_name attribute_instance* (LParen list_of_arguments RParen)?
      (TWith LParen expression RParen)?
    ;

randomize_call
    : TRandomize attribute_instance*
      (LParen (variable_identifier_list | TNull)? RParen)?
      (TWith (LParen identifier_list? RParen)? constraint_block)?
    ;

method_call_root
    : primary
    | implicit_class_handle
    ;

array_method_name
    : method_identifier
    | TUnique
    | TAnd
    | TOr
    | TXor
    ;

// ── A.8.3  Expressions ────────────────────────────────────────

inc_or_dec_expression
    : inc_or_dec_operator attribute_instance* variable_lvalue
    | variable_lvalue attribute_instance* inc_or_dec_operator
    ;

inc_or_dec_operator
    : OpInc
    | OpDec
    ;

conditional_expression
    : cond_predicate QuestionMark attribute_instance* expression Colon expression
    ;

constant_expression
    : constant_primary
    | unary_operator attribute_instance* constant_primary
    | constant_expression binary_operator attribute_instance* constant_expression
    | constant_expression QuestionMark attribute_instance*
      constant_expression Colon constant_expression
    ;

constant_mintypmax_expression
    : constant_expression
    | constant_expression Colon constant_expression Colon constant_expression
    ;

constant_param_expression
    : constant_mintypmax_expression
    | data_type
    | Dollar
    ;

param_expression
    : mintypmax_expression
    | data_type
    | Dollar
    ;

constant_range_expression
    : constant_expression
    | constant_part_select_range
    ;

constant_part_select_range
    : constant_range
    | constant_indexed_range
    ;

constant_range
    : constant_expression Colon constant_expression
    ;

constant_indexed_range
    : constant_expression OpAddAssign constant_expression   // '+:'
    | constant_expression OpSubAssign constant_expression   // '-:'
    ;

expression
    : ( primary
      | unary_operator attribute_instance* primary
      | inc_or_dec_expression
      | LParen operator_assignment RParen
      | tagged_union_expression
      )
      ( binary_operator attribute_instance* expression
      | conditional_expression
      | inside_expression
      )*
    ;

tagged_union_expression
    : TTagged member_identifier expression?
    ;

inside_expression
    : expression TInside LBrace open_range_list RBrace
    ;

value_range
    : expression
    | LBracket expression Colon expression RBracket
    ;

mintypmax_expression
    : expression
    | expression Colon expression Colon expression
    ;

module_path_expression
    : ( module_path_primary
      | unary_module_path_operator attribute_instance* module_path_primary
      )
      ( binary_module_path_operator attribute_instance* module_path_expression
      | QuestionMark attribute_instance* module_path_expression Colon module_path_expression
      )*
    ;

module_path_mintypmax_expression
    : module_path_expression
    | module_path_expression Colon module_path_expression Colon module_path_expression
    ;

part_select_range
    : constant_range
    | indexed_range
    ;

indexed_range
    : expression OpAddAssign constant_expression   // '+:'
    | expression OpSubAssign constant_expression   // '-:'
    ;

genvar_expression : constant_expression;

// ── A.8.4  Primaries ──────────────────────────────────────────

constant_primary
    : ( primary_literal
      | ps_parameter_identifier constant_select
      | specparam_identifier (LBracket constant_range_expression RBracket)?
      | genvar_identifier
      | formal_port_identifier constant_select
      | (package_scope | class_scope)? enum_identifier
      | constant_concatenation (LBracket constant_range_expression RBracket)?
      | constant_multiple_concatenation (LBracket constant_range_expression RBracket)?
      | constant_function_call
      | constant_let_expression
      | LParen constant_mintypmax_expression RParen
      | constant_assignment_pattern_expression
      | type_reference
      ) constant_cast*
    ;

module_path_primary
    : number
    | identifier
    | module_path_concatenation
    | module_path_multiple_concatenation
    | function_subroutine_call
    | LParen module_path_mintypmax_expression RParen
    ;

primary
    : ( primary_literal
      | (class_qualifier | package_scope) hierarchical_identifier select
      | empty_queue
      | concatenation          (LBracket range_expression RBracket)?
      | multiple_concatenation (LBracket range_expression RBracket)?
      | let_expression
      | LParen mintypmax_expression RParen
      | assignment_pattern_expression
      | streaming_concatenation
      | sequence_method_call
      | TThis
      | Dollar
      | TNull
      )
      (function_subroutine_call | cast)*
    ;

class_qualifier
    : (SimpleIdentifier ScopeOp)?   // 'local::'
      (implicit_class_handle DotOp | class_scope)?
    ;

range_expression
    : expression
    | part_select_range
    ;

primary_literal
    : number
    | time_literal
    | unbased_unsized_literal
    | StringLiteral
    ;

time_literal
    : unsigned_number time_unit
    | fixed_point_number time_unit
    ;

time_unit
    : SimpleIdentifier     // s ms us ns ps fs – matched as identifier, validated in visitor
    ;

implicit_class_handle
    : TThis
    | TSuper
    | TThis DotOp TSuper
    ;

bit_select
    : (LBracket expression RBracket)*
    ;

select
    : ((DotOp member_identifier bit_select)? DotOp member_identifier)?
      bit_select (LBracket part_select_range RBracket)?
    ;

nonrange_select
    : ((DotOp member_identifier bit_select)* DotOp member_identifier)? bit_select
    ;

constant_bit_select
    : (LBracket constant_expression RBracket)*
    ;

constant_select
    : ((DotOp member_identifier constant_bit_select)* DotOp member_identifier)?
      constant_bit_select (LBracket constant_part_select_range RBracket)?
    ;

constant_cast
    : casting_type Tick LParen constant_expression RParen
    ;

constant_let_expression : let_expression;

cast
    : casting_type Tick LParen expression RParen
    ;

// ── A.8.5  Expression left-side values ───────────────────────

net_lvalue
    : ps_or_hierarchical_net_identifier constant_select
    | LBrace net_lvalue (Comma net_lvalue)* RBrace
    | assignment_pattern_expression_type? assignment_pattern_net_lvalue
    ;

variable_lvalue
    : (implicit_class_handle DotOp | package_scope)? hierarchical_variable_identifier select
    | LBrace variable_lvalue (Comma variable_lvalue)* RBrace
    | assignment_pattern_expression_type? assignment_pattern_variable_lvalue
    | streaming_concatenation
    ;

nonrange_variable_lvalue
    : (implicit_class_handle DotOp | package_scope)?
      hierarchical_variable_identifier nonrange_select
    ;

// ── A.8.6  Operators ──────────────────────────────────────────

unary_operator
    : OpAdd | OpSub | OpLogNot | OpBitNot
    | OpBitAnd | OpNand | OpBitOr | OpNor
    | OpBitXor | OpXnor | OpXnorAlt
    ;

binary_operator
    : OpAdd | OpSub | OpMul | OpDiv | OpMod
    | OpEq  | OpNe  | OpCaseEq | OpCaseNe | OpWildEq | OpWildNe
    | OpLogAnd | OpLogOr | OpPow
    | OpLt  | OpLe  | OpGt  | OpGe
    | OpBitAnd | OpBitOr | OpBitXor | OpXnor | OpXnorAlt
    | OpShr | OpShl | OpArithShr | OpArithShl
    | OpImplication | OpEquiv
    ;

unary_module_path_operator
    : OpLogNot | OpBitNot
    | OpBitAnd | OpNand | OpBitOr | OpNor
    | OpBitXor | OpXnor | OpXnorAlt
    ;

binary_module_path_operator
    : OpEq | OpNe | OpLogAnd | OpLogOr
    | OpBitAnd | OpBitOr | OpBitXor | OpXnor | OpXnorAlt
    ;

// ── A.8.7  Numbers ────────────────────────────────────────────

number
    : integral_number
    | real_number
    ;

integral_number
    : decimal_number
    | octal_number
    | binary_number
    | hex_number
    ;

decimal_number
    : unsigned_number
    | size? DecBase unsigned_number
    | size? DecBase x_digit Underscore*
    | size? DecBase z_digit Underscore*
    ;

binary_number : size? BinBase binary_value;
octal_number  : size? OctBase octal_value;
hex_number    : size? HexBase hex_value;

sign : OpAdd | OpSub;
size : non_zero_unsigned_number;

non_zero_unsigned_number
    : non_zero_decimal_digit (Underscore | decimal_digit)*
    ;

real_number
    : fixed_point_number
    | unsigned_number (DotOp unsigned_number)? exp sign? unsigned_number
    ;

fixed_point_number : unsigned_number DotOp unsigned_number;
exp                : ExpLower | ExpUpper;
unsigned_number    : decimal_digit (Underscore | decimal_digit)*;
binary_value       : binary_digit  (Underscore | binary_digit)*;
octal_value        : octal_digit   (Underscore | octal_digit)*;
hex_value          : hex_digit     (Underscore | hex_digit)*;

non_zero_decimal_digit
    : Digit1 | Digit2 | Digit3 | Digit4 | Digit5
    | Digit6 | Digit7 | Digit8 | Digit9
    ;

decimal_digit
    : Digit0 | Digit1 | Digit2 | Digit3 | Digit4
    | Digit5 | Digit6 | Digit7 | Digit8 | Digit9
    ;

binary_digit : x_digit | z_digit | Digit0 | Digit1;

octal_digit
    : x_digit | z_digit
    | Digit0 | Digit1 | Digit2 | Digit3
    | Digit4 | Digit5 | Digit6 | Digit7
    ;

hex_digit
    : x_digit | z_digit
    | Digit0 | Digit1 | Digit2 | Digit3 | Digit4
    | Digit5 | Digit6 | Digit7 | Digit8 | Digit9
    | HexDigitLower | HexDigitUpper
    ;

x_digit : XDigitLower | XDigitUpper;
z_digit : ZDigitLower | ZDigitUpper | QuestionMark;

unbased_unsized_literal
    : UnbasedZero
    | UnbasedOne
    | Tick z_or_x
    ;


// ════════════════════════════════════════════════════════════
// A.9  GENERAL
// ════════════════════════════════════════════════════════════

// ── A.9.1  Attributes ─────────────────────────────────────────

attribute_instance
    : AttrStart attr_spec (Comma attr_spec)* AttrEnd
    ;

attr_spec
    : attr_name (OpAssign constant_expression)?
    ;

attr_name : identifier;


// ════════════════════════════════════════════════════════════
// A.9.3  IDENTIFIERS
// (simple aliases kept so the grammar reads like the LRM)
// ════════════════════════════════════════════════════════════

// ── Simple → identifier aliases (sorted) ─────────────────────
array_identifier                   : identifier;
bin_identifier                     : identifier;
block_identifier                   : identifier;
cell_identifier                    : identifier;
checker_identifier                 : identifier;
class_identifier                   : identifier;
clocking_identifier                : identifier;
config_identifier                  : identifier;
const_identifier                   : identifier;
constraint_identifier              : identifier;
cover_point_identifier             : identifier;
covergroup_identifier              : identifier;
cross_identifier                   : identifier;
enum_identifier                    : identifier;
formal_identifier                  : identifier;
formal_port_identifier             : identifier;
function_identifier                : identifier;
generate_block_identifier          : identifier;
genvar_identifier                  : identifier;
index_variable_identifier          : identifier;
inout_port_identifier              : identifier;
input_port_identifier              : identifier;
instance_identifier                : identifier;
interface_identifier               : identifier;
interface_instance_identifier      : identifier;
library_identifier                 : identifier;
member_identifier                  : identifier;
method_identifier                  : identifier;
modport_identifier                 : identifier;
module_identifier                  : identifier;
net_identifier                     : identifier;
net_type_identifier                : identifier;
output_port_identifier             : identifier;
package_identifier                 : identifier;
parameter_identifier               : identifier;
port_identifier                    : identifier;
production_identifier              : identifier;
program_identifier                 : identifier;
property_identifier                : identifier;
sequence_identifier                : identifier;
signal_identifier                  : identifier;
specparam_identifier               : identifier;
task_identifier                    : identifier;
terminal_identifier                : identifier;
tf_identifier                      : identifier;
topmodule_identifier               : identifier;
type_identifier                    : identifier;
udp_identifier                     : identifier;
variable_identifier                : identifier;

// ── variable_identifier aliases (sorted) ─────────────────────
class_variable_identifier          : variable_identifier;
covergroup_variable_identifier     : variable_identifier;
dynamic_array_variable_identifier  : variable_identifier;

// ── hierarchical_identifier aliases (sorted) ─────────────────
hierarchical_array_identifier      : hierarchical_identifier;
hierarchical_block_identifier      : hierarchical_identifier;
hierarchical_event_identifier      : hierarchical_identifier;
hierarchical_net_identifier        : hierarchical_identifier;
hierarchical_parameter_identifier  : hierarchical_identifier;
hierarchical_property_identifier   : hierarchical_identifier;
hierarchical_sequence_identifier   : hierarchical_identifier;
hierarchical_task_identifier       : hierarchical_identifier;
hierarchical_tf_identifier         : hierarchical_identifier;
hierarchical_variable_identifier   : hierarchical_identifier;

// ── Base identifier rules ─────────────────────────────────────

hierarchical_identifier
    : (Dollar SimpleIdentifier DotOp)?   // $root.
      (identifier constant_bit_select DotOp)* identifier
    ;

identifier : SimpleIdentifier;

// ── Package-scoped identifiers (sorted) ──────────────────────

package_scope
    : package_identifier ScopeOp
    | Dollar SimpleIdentifier ScopeOp     // $unit::
    ;

ps_checker_identifier   : package_scope? checker_identifier;
ps_class_identifier     : package_scope? class_identifier;
ps_covergroup_identifier: package_scope? covergroup_identifier;
ps_identifier           : package_scope? identifier;

ps_or_hierarchical_array_identifier
    : implicit_class_handle DotOp hierarchical_array_identifier
    | class_scope   hierarchical_array_identifier
    | package_scope hierarchical_array_identifier
    | hierarchical_array_identifier
    ;

ps_or_hierarchical_net_identifier
    : package_scope? net_identifier
    | hierarchical_net_identifier
    ;

ps_or_hierarchical_property_identifier
    : package_scope? property_identifier
    | hierarchical_property_identifier
    ;

ps_or_hierarchical_sequence_identifier
    : package_scope? sequence_identifier
    | hierarchical_sequence_identifier
    ;

ps_or_hierarchical_tf_identifier
    : package_scope? tf_identifier
    | hierarchical_tf_identifier
    ;

ps_parameter_identifier
    : package_scope  parameter_identifier
    | class_scope    parameter_identifier
    | parameter_identifier
    | (generate_block_identifier (LBracket constant_expression RBracket)? DotOp)*
      parameter_identifier
    ;

ps_type_identifier
    : SimpleIdentifier ScopeOp type_identifier   // local::
    | package_scope    type_identifier
    | type_identifier
    ;
