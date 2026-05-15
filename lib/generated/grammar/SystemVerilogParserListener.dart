// Generated from grammar/SystemVerilogParser.g4 by ANTLR 4.13.2
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'SystemVerilogParser.dart';

/// This abstract class defines a complete listener for a parse tree produced by
/// [SystemVerilogParser].
abstract class SystemVerilogParserListener extends ParseTreeListener {
  /// Enter a parse tree produced by [SystemVerilogParser.source_text].
  /// [ctx] the parse tree
  void enterSource_text(Source_textContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.source_text].
  /// [ctx] the parse tree
  void exitSource_text(Source_textContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.timeunits_declaration].
  /// [ctx] the parse tree
  void enterTimeunits_declaration(Timeunits_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.timeunits_declaration].
  /// [ctx] the parse tree
  void exitTimeunits_declaration(Timeunits_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.time_literal].
  /// [ctx] the parse tree
  void enterTime_literal(Time_literalContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.time_literal].
  /// [ctx] the parse tree
  void exitTime_literal(Time_literalContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.attribute].
  /// [ctx] the parse tree
  void enterAttribute(AttributeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.attribute].
  /// [ctx] the parse tree
  void exitAttribute(AttributeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.description].
  /// [ctx] the parse tree
  void enterDescription(DescriptionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.description].
  /// [ctx] the parse tree
  void exitDescription(DescriptionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_declaration].
  /// [ctx] the parse tree
  void enterModule_declaration(Module_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_declaration].
  /// [ctx] the parse tree
  void exitModule_declaration(Module_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_identifier].
  /// [ctx] the parse tree
  void enterModule_identifier(Module_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_identifier].
  /// [ctx] the parse tree
  void exitModule_identifier(Module_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_parameter_port_list].
  /// [ctx] the parse tree
  void enterModule_parameter_port_list(Module_parameter_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_parameter_port_list].
  /// [ctx] the parse tree
  void exitModule_parameter_port_list(Module_parameter_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_port_list].
  /// [ctx] the parse tree
  void enterModule_port_list(Module_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_port_list].
  /// [ctx] the parse tree
  void exitModule_port_list(Module_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_port_declaration].
  /// [ctx] the parse tree
  void enterParameter_port_declaration(Parameter_port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_port_declaration].
  /// [ctx] the parse tree
  void exitParameter_port_declaration(Parameter_port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port].
  /// [ctx] the parse tree
  void enterPort(PortContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port].
  /// [ctx] the parse tree
  void exitPort(PortContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_item].
  /// [ctx] the parse tree
  void enterModule_item(Module_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_item].
  /// [ctx] the parse tree
  void exitModule_item(Module_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_common_item].
  /// [ctx] the parse tree
  void enterModule_common_item(Module_common_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_common_item].
  /// [ctx] the parse tree
  void exitModule_common_item(Module_common_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_declaration].
  /// [ctx] the parse tree
  void enterPort_declaration(Port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_declaration].
  /// [ctx] the parse tree
  void exitPort_declaration(Port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_declaration].
  /// [ctx] the parse tree
  void enterParameter_declaration(Parameter_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_declaration].
  /// [ctx] the parse tree
  void exitParameter_declaration(Parameter_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.local_parameter_declaration].
  /// [ctx] the parse tree
  void enterLocal_parameter_declaration(Local_parameter_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.local_parameter_declaration].
  /// [ctx] the parse tree
  void exitLocal_parameter_declaration(Local_parameter_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_param_assignments].
  /// [ctx] the parse tree
  void enterList_of_param_assignments(List_of_param_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_param_assignments].
  /// [ctx] the parse tree
  void exitList_of_param_assignments(List_of_param_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.param_assignment].
  /// [ctx] the parse tree
  void enterParam_assignment(Param_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.param_assignment].
  /// [ctx] the parse tree
  void exitParam_assignment(Param_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_declaration].
  /// [ctx] the parse tree
  void enterData_declaration(Data_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_declaration].
  /// [ctx] the parse tree
  void exitData_declaration(Data_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.const_declaration].
  /// [ctx] the parse tree
  void enterConst_declaration(Const_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.const_declaration].
  /// [ctx] the parse tree
  void exitConst_declaration(Const_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.var_declaration].
  /// [ctx] the parse tree
  void enterVar_declaration(Var_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.var_declaration].
  /// [ctx] the parse tree
  void exitVar_declaration(Var_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_definitions].
  /// [ctx] the parse tree
  void enterList_of_definitions(List_of_definitionsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_definitions].
  /// [ctx] the parse tree
  void exitList_of_definitions(List_of_definitionsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_variables].
  /// [ctx] the parse tree
  void enterList_of_variables(List_of_variablesContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_variables].
  /// [ctx] the parse tree
  void exitList_of_variables(List_of_variablesContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_decl_assignment].
  /// [ctx] the parse tree
  void enterVariable_decl_assignment(Variable_decl_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_decl_assignment].
  /// [ctx] the parse tree
  void exitVariable_decl_assignment(Variable_decl_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.def_struct_or_union_or_enum].
  /// [ctx] the parse tree
  void enterDef_struct_or_union_or_enum(Def_struct_or_union_or_enumContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.def_struct_or_union_or_enum].
  /// [ctx] the parse tree
  void exitDef_struct_or_union_or_enum(Def_struct_or_union_or_enumContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_pattern_or_implicit].
  /// [ctx] the parse tree
  void enterData_pattern_or_implicit(Data_pattern_or_implicitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_pattern_or_implicit].
  /// [ctx] the parse tree
  void exitData_pattern_or_implicit(Data_pattern_or_implicitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_declaration].
  /// [ctx] the parse tree
  void enterNet_declaration(Net_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_declaration].
  /// [ctx] the parse tree
  void exitNet_declaration(Net_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.wire_declaration].
  /// [ctx] the parse tree
  void enterWire_declaration(Wire_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.wire_declaration].
  /// [ctx] the parse tree
  void exitWire_declaration(Wire_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tri_declaration].
  /// [ctx] the parse tree
  void enterTri_declaration(Tri_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tri_declaration].
  /// [ctx] the parse tree
  void exitTri_declaration(Tri_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_net_decl_assignments].
  /// [ctx] the parse tree
  void enterList_of_net_decl_assignments(List_of_net_decl_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_net_decl_assignments].
  /// [ctx] the parse tree
  void exitList_of_net_decl_assignments(List_of_net_decl_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_decl_assignment].
  /// [ctx] the parse tree
  void enterNet_decl_assignment(Net_decl_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_decl_assignment].
  /// [ctx] the parse tree
  void exitNet_decl_assignment(Net_decl_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.supply0_declaration].
  /// [ctx] the parse tree
  void enterSupply0_declaration(Supply0_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.supply0_declaration].
  /// [ctx] the parse tree
  void exitSupply0_declaration(Supply0_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.supply1_declaration].
  /// [ctx] the parse tree
  void enterSupply1_declaration(Supply1_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.supply1_declaration].
  /// [ctx] the parse tree
  void exitSupply1_declaration(Supply1_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.input_declaration].
  /// [ctx] the parse tree
  void enterInput_declaration(Input_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.input_declaration].
  /// [ctx] the parse tree
  void exitInput_declaration(Input_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.output_declaration].
  /// [ctx] the parse tree
  void enterOutput_declaration(Output_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.output_declaration].
  /// [ctx] the parse tree
  void exitOutput_declaration(Output_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inout_declaration].
  /// [ctx] the parse tree
  void enterInout_declaration(Inout_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inout_declaration].
  /// [ctx] the parse tree
  void exitInout_declaration(Inout_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_port_identifiers].
  /// [ctx] the parse tree
  void enterList_of_port_identifiers(List_of_port_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_port_identifiers].
  /// [ctx] the parse tree
  void exitList_of_port_identifiers(List_of_port_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_identifier].
  /// [ctx] the parse tree
  void enterPort_identifier(Port_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_identifier].
  /// [ctx] the parse tree
  void exitPort_identifier(Port_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_type_or_implicit].
  /// [ctx] the parse tree
  void enterData_type_or_implicit(Data_type_or_implicitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_type_or_implicit].
  /// [ctx] the parse tree
  void exitData_type_or_implicit(Data_type_or_implicitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.implicitly_declared_data_type].
  /// [ctx] the parse tree
  void enterImplicitly_declared_data_type(Implicitly_declared_data_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.implicitly_declared_data_type].
  /// [ctx] the parse tree
  void exitImplicitly_declared_data_type(Implicitly_declared_data_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_type].
  /// [ctx] the parse tree
  void enterData_type(Data_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_type].
  /// [ctx] the parse tree
  void exitData_type(Data_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.struct_union].
  /// [ctx] the parse tree
  void enterStruct_union(Struct_unionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.struct_union].
  /// [ctx] the parse tree
  void exitStruct_union(Struct_unionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.enum_identifier].
  /// [ctx] the parse tree
  void enterEnum_identifier(Enum_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.enum_identifier].
  /// [ctx] the parse tree
  void exitEnum_identifier(Enum_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.integer_atom_type].
  /// [ctx] the parse tree
  void enterInteger_atom_type(Integer_atom_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.integer_atom_type].
  /// [ctx] the parse tree
  void exitInteger_atom_type(Integer_atom_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.integer_vector_type].
  /// [ctx] the parse tree
  void enterInteger_vector_type(Integer_vector_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.integer_vector_type].
  /// [ctx] the parse tree
  void exitInteger_vector_type(Integer_vector_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.signing].
  /// [ctx] the parse tree
  void enterSigning(SigningContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.signing].
  /// [ctx] the parse tree
  void exitSigning(SigningContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.signedness].
  /// [ctx] the parse tree
  void enterSignedness(SignednessContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.signedness].
  /// [ctx] the parse tree
  void exitSignedness(SignednessContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_type].
  /// [ctx] the parse tree
  void enterNet_type(Net_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_type].
  /// [ctx] the parse tree
  void exitNet_type(Net_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.drive_strength].
  /// [ctx] the parse tree
  void enterDrive_strength(Drive_strengthContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.drive_strength].
  /// [ctx] the parse tree
  void exitDrive_strength(Drive_strengthContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.charge_strength].
  /// [ctx] the parse tree
  void enterCharge_strength(Charge_strengthContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.charge_strength].
  /// [ctx] the parse tree
  void exitCharge_strength(Charge_strengthContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.strength0].
  /// [ctx] the parse tree
  void enterStrength0(Strength0Context ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.strength0].
  /// [ctx] the parse tree
  void exitStrength0(Strength0Context ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.strength1].
  /// [ctx] the parse tree
  void enterStrength1(Strength1Context ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.strength1].
  /// [ctx] the parse tree
  void exitStrength1(Strength1Context ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.vectored_or_scalared].
  /// [ctx] the parse tree
  void enterVectored_or_scalared(Vectored_or_scalaredContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.vectored_or_scalared].
  /// [ctx] the parse tree
  void exitVectored_or_scalared(Vectored_or_scalaredContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dimension].
  /// [ctx] the parse tree
  void enterDimension(DimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dimension].
  /// [ctx] the parse tree
  void exitDimension(DimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unpacked_dimension].
  /// [ctx] the parse tree
  void enterUnpacked_dimension(Unpacked_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unpacked_dimension].
  /// [ctx] the parse tree
  void exitUnpacked_dimension(Unpacked_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.always_construct].
  /// [ctx] the parse tree
  void enterAlways_construct(Always_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.always_construct].
  /// [ctx] the parse tree
  void exitAlways_construct(Always_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.always_statement].
  /// [ctx] the parse tree
  void enterAlways_statement(Always_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.always_statement].
  /// [ctx] the parse tree
  void exitAlways_statement(Always_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.continuous_assign].
  /// [ctx] the parse tree
  void enterContinuous_assign(Continuous_assignContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.continuous_assign].
  /// [ctx] the parse tree
  void exitContinuous_assign(Continuous_assignContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_assignments].
  /// [ctx] the parse tree
  void enterList_of_assignments(List_of_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_assignments].
  /// [ctx] the parse tree
  void exitList_of_assignments(List_of_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment].
  /// [ctx] the parse tree
  void enterAssignment(AssignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment].
  /// [ctx] the parse tree
  void exitAssignment(AssignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.initial_construct].
  /// [ctx] the parse tree
  void enterInitial_construct(Initial_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.initial_construct].
  /// [ctx] the parse tree
  void exitInitial_construct(Initial_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.statement].
  /// [ctx] the parse tree
  void enterStatement(StatementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.statement].
  /// [ctx] the parse tree
  void exitStatement(StatementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.statement_or_null].
  /// [ctx] the parse tree
  void enterStatement_or_null(Statement_or_nullContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.statement_or_null].
  /// [ctx] the parse tree
  void exitStatement_or_null(Statement_or_nullContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.statement_item].
  /// [ctx] the parse tree
  void enterStatement_item(Statement_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.statement_item].
  /// [ctx] the parse tree
  void exitStatement_item(Statement_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_statement].
  /// [ctx] the parse tree
  void enterProcedural_statement(Procedural_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_statement].
  /// [ctx] the parse tree
  void exitProcedural_statement(Procedural_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assertion_statement].
  /// [ctx] the parse tree
  void enterAssertion_statement(Assertion_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assertion_statement].
  /// [ctx] the parse tree
  void exitAssertion_statement(Assertion_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.blocking_assignment].
  /// [ctx] the parse tree
  void enterBlocking_assignment(Blocking_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.blocking_assignment].
  /// [ctx] the parse tree
  void exitBlocking_assignment(Blocking_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_blocking_assignment].
  /// [ctx] the parse tree
  void enterNon_blocking_assignment(Non_blocking_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_blocking_assignment].
  /// [ctx] the parse tree
  void exitNon_blocking_assignment(Non_blocking_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_continuous_assignment].
  /// [ctx] the parse tree
  void enterProcedural_continuous_assignment(Procedural_continuous_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_continuous_assignment].
  /// [ctx] the parse tree
  void exitProcedural_continuous_assignment(Procedural_continuous_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inc_dec_statement].
  /// [ctx] the parse tree
  void enterInc_dec_statement(Inc_dec_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inc_dec_statement].
  /// [ctx] the parse tree
  void exitInc_dec_statement(Inc_dec_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.conditional_statement].
  /// [ctx] the parse tree
  void enterConditional_statement(Conditional_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.conditional_statement].
  /// [ctx] the parse tree
  void exitConditional_statement(Conditional_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.condition].
  /// [ctx] the parse tree
  void enterCondition(ConditionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.condition].
  /// [ctx] the parse tree
  void exitCondition(ConditionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_statement].
  /// [ctx] the parse tree
  void enterCase_statement(Case_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_statement].
  /// [ctx] the parse tree
  void exitCase_statement(Case_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_item].
  /// [ctx] the parse tree
  void enterCase_item(Case_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_item].
  /// [ctx] the parse tree
  void exitCase_item(Case_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.loop_statement].
  /// [ctx] the parse tree
  void enterLoop_statement(Loop_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.loop_statement].
  /// [ctx] the parse tree
  void exitLoop_statement(Loop_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.for_initialization].
  /// [ctx] the parse tree
  void enterFor_initialization(For_initializationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.for_initialization].
  /// [ctx] the parse tree
  void exitFor_initialization(For_initializationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.for_declaration].
  /// [ctx] the parse tree
  void enterFor_declaration(For_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.for_declaration].
  /// [ctx] the parse tree
  void exitFor_declaration(For_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.for_variable_declaration].
  /// [ctx] the parse tree
  void enterFor_variable_declaration(For_variable_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.for_variable_declaration].
  /// [ctx] the parse tree
  void exitFor_variable_declaration(For_variable_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.for_step].
  /// [ctx] the parse tree
  void enterFor_step(For_stepContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.for_step].
  /// [ctx] the parse tree
  void exitFor_step(For_stepContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.for_step_assignment].
  /// [ctx] the parse tree
  void enterFor_step_assignment(For_step_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.for_step_assignment].
  /// [ctx] the parse tree
  void exitFor_step_assignment(For_step_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.loop_variables].
  /// [ctx] the parse tree
  void enterLoop_variables(Loop_variablesContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.loop_variables].
  /// [ctx] the parse tree
  void exitLoop_variables(Loop_variablesContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.jump_statement].
  /// [ctx] the parse tree
  void enterJump_statement(Jump_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.jump_statement].
  /// [ctx] the parse tree
  void exitJump_statement(Jump_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.disable_statement].
  /// [ctx] the parse tree
  void enterDisable_statement(Disable_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.disable_statement].
  /// [ctx] the parse tree
  void exitDisable_statement(Disable_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_timing_control_statement].
  /// [ctx] the parse tree
  void enterProcedural_timing_control_statement(Procedural_timing_control_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_timing_control_statement].
  /// [ctx] the parse tree
  void exitProcedural_timing_control_statement(Procedural_timing_control_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_timing_control].
  /// [ctx] the parse tree
  void enterProcedural_timing_control(Procedural_timing_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_timing_control].
  /// [ctx] the parse tree
  void exitProcedural_timing_control(Procedural_timing_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay_control].
  /// [ctx] the parse tree
  void enterDelay_control(Delay_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay_control].
  /// [ctx] the parse tree
  void exitDelay_control(Delay_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay3].
  /// [ctx] the parse tree
  void enterDelay3(Delay3Context ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay3].
  /// [ctx] the parse tree
  void exitDelay3(Delay3Context ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay_value].
  /// [ctx] the parse tree
  void enterDelay_value(Delay_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay_value].
  /// [ctx] the parse tree
  void exitDelay_value(Delay_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.event_control].
  /// [ctx] the parse tree
  void enterEvent_control(Event_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.event_control].
  /// [ctx] the parse tree
  void exitEvent_control(Event_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sensitivity_list].
  /// [ctx] the parse tree
  void enterSensitivity_list(Sensitivity_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sensitivity_list].
  /// [ctx] the parse tree
  void exitSensitivity_list(Sensitivity_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.event_expression].
  /// [ctx] the parse tree
  void enterEvent_expression(Event_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.event_expression].
  /// [ctx] the parse tree
  void exitEvent_expression(Event_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.seq_block].
  /// [ctx] the parse tree
  void enterSeq_block(Seq_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.seq_block].
  /// [ctx] the parse tree
  void exitSeq_block(Seq_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.block_item_declaration].
  /// [ctx] the parse tree
  void enterBlock_item_declaration(Block_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.block_item_declaration].
  /// [ctx] the parse tree
  void exitBlock_item_declaration(Block_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.block_data_declaration].
  /// [ctx] the parse tree
  void enterBlock_data_declaration(Block_data_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.block_data_declaration].
  /// [ctx] the parse tree
  void exitBlock_data_declaration(Block_data_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_instantiation].
  /// [ctx] the parse tree
  void enterModule_instantiation(Module_instantiationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_instantiation].
  /// [ctx] the parse tree
  void exitModule_instantiation(Module_instantiationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_value_assignment].
  /// [ctx] the parse tree
  void enterParameter_value_assignment(Parameter_value_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_value_assignment].
  /// [ctx] the parse tree
  void exitParameter_value_assignment(Parameter_value_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ordered_parameter_assignment].
  /// [ctx] the parse tree
  void enterOrdered_parameter_assignment(Ordered_parameter_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ordered_parameter_assignment].
  /// [ctx] the parse tree
  void exitOrdered_parameter_assignment(Ordered_parameter_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_instance].
  /// [ctx] the parse tree
  void enterModule_instance(Module_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_instance].
  /// [ctx] the parse tree
  void exitModule_instance(Module_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.named_port_connection].
  /// [ctx] the parse tree
  void enterNamed_port_connection(Named_port_connectionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.named_port_connection].
  /// [ctx] the parse tree
  void exitNamed_port_connection(Named_port_connectionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_generate_region].
  /// [ctx] the parse tree
  void enterModule_generate_region(Module_generate_regionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_generate_region].
  /// [ctx] the parse tree
  void exitModule_generate_region(Module_generate_regionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_generate_item].
  /// [ctx] the parse tree
  void enterModule_generate_item(Module_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_generate_item].
  /// [ctx] the parse tree
  void exitModule_generate_item(Module_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.genvar_declaration].
  /// [ctx] the parse tree
  void enterGenvar_declaration(Genvar_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.genvar_declaration].
  /// [ctx] the parse tree
  void exitGenvar_declaration(Genvar_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.loop_generate_construct].
  /// [ctx] the parse tree
  void enterLoop_generate_construct(Loop_generate_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.loop_generate_construct].
  /// [ctx] the parse tree
  void exitLoop_generate_construct(Loop_generate_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.conditional_generate_construct].
  /// [ctx] the parse tree
  void enterConditional_generate_construct(Conditional_generate_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.conditional_generate_construct].
  /// [ctx] the parse tree
  void exitConditional_generate_construct(Conditional_generate_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.if_generate_construct].
  /// [ctx] the parse tree
  void enterIf_generate_construct(If_generate_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.if_generate_construct].
  /// [ctx] the parse tree
  void exitIf_generate_construct(If_generate_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_generate_construct].
  /// [ctx] the parse tree
  void enterCase_generate_construct(Case_generate_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_generate_construct].
  /// [ctx] the parse tree
  void exitCase_generate_construct(Case_generate_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_generate_item].
  /// [ctx] the parse tree
  void enterCase_generate_item(Case_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_generate_item].
  /// [ctx] the parse tree
  void exitCase_generate_item(Case_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.generate_block].
  /// [ctx] the parse tree
  void enterGenerate_block(Generate_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.generate_block].
  /// [ctx] the parse tree
  void exitGenerate_block(Generate_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_declaration].
  /// [ctx] the parse tree
  void enterInterface_declaration(Interface_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_declaration].
  /// [ctx] the parse tree
  void exitInterface_declaration(Interface_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_port_list].
  /// [ctx] the parse tree
  void enterInterface_port_list(Interface_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_port_list].
  /// [ctx] the parse tree
  void exitInterface_port_list(Interface_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_port].
  /// [ctx] the parse tree
  void enterInterface_port(Interface_portContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_port].
  /// [ctx] the parse tree
  void exitInterface_port(Interface_portContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_item].
  /// [ctx] the parse tree
  void enterInterface_item(Interface_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_item].
  /// [ctx] the parse tree
  void exitInterface_item(Interface_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_common_item].
  /// [ctx] the parse tree
  void enterInterface_common_item(Interface_common_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_common_item].
  /// [ctx] the parse tree
  void exitInterface_common_item(Interface_common_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_declaration].
  /// [ctx] the parse tree
  void enterModport_declaration(Modport_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_declaration].
  /// [ctx] the parse tree
  void exitModport_declaration(Modport_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_item].
  /// [ctx] the parse tree
  void enterModport_item(Modport_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_item].
  /// [ctx] the parse tree
  void exitModport_item(Modport_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_declaration].
  /// [ctx] the parse tree
  void enterPackage_declaration(Package_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_declaration].
  /// [ctx] the parse tree
  void exitPackage_declaration(Package_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_item].
  /// [ctx] the parse tree
  void enterPackage_item(Package_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_item].
  /// [ctx] the parse tree
  void exitPackage_item(Package_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_common_item].
  /// [ctx] the parse tree
  void enterPackage_common_item(Package_common_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_common_item].
  /// [ctx] the parse tree
  void exitPackage_common_item(Package_common_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_declaration].
  /// [ctx] the parse tree
  void enterProgram_declaration(Program_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_declaration].
  /// [ctx] the parse tree
  void exitProgram_declaration(Program_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_port_list].
  /// [ctx] the parse tree
  void enterProgram_port_list(Program_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_port_list].
  /// [ctx] the parse tree
  void exitProgram_port_list(Program_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_port].
  /// [ctx] the parse tree
  void enterProgram_port(Program_portContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_port].
  /// [ctx] the parse tree
  void exitProgram_port(Program_portContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_variable_direction].
  /// [ctx] the parse tree
  void enterProgram_variable_direction(Program_variable_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_variable_direction].
  /// [ctx] the parse tree
  void exitProgram_variable_direction(Program_variable_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_item].
  /// [ctx] the parse tree
  void enterProgram_item(Program_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_item].
  /// [ctx] the parse tree
  void exitProgram_item(Program_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_common_item].
  /// [ctx] the parse tree
  void enterProgram_common_item(Program_common_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_common_item].
  /// [ctx] the parse tree
  void exitProgram_common_item(Program_common_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_declaration].
  /// [ctx] the parse tree
  void enterFunction_declaration(Function_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_declaration].
  /// [ctx] the parse tree
  void exitFunction_declaration(Function_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_data_type_or_implicit].
  /// [ctx] the parse tree
  void enterFunction_data_type_or_implicit(Function_data_type_or_implicitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_data_type_or_implicit].
  /// [ctx] the parse tree
  void exitFunction_data_type_or_implicit(Function_data_type_or_implicitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_port_list].
  /// [ctx] the parse tree
  void enterFunction_port_list(Function_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_port_list].
  /// [ctx] the parse tree
  void exitFunction_port_list(Function_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_port_item].
  /// [ctx] the parse tree
  void enterFunction_port_item(Function_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_port_item].
  /// [ctx] the parse tree
  void exitFunction_port_item(Function_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_port_direction].
  /// [ctx] the parse tree
  void enterFunction_port_direction(Function_port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_port_direction].
  /// [ctx] the parse tree
  void exitFunction_port_direction(Function_port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_item_declaration].
  /// [ctx] the parse tree
  void enterFunction_item_declaration(Function_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_item_declaration].
  /// [ctx] the parse tree
  void exitFunction_item_declaration(Function_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_statement].
  /// [ctx] the parse tree
  void enterFunction_statement(Function_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_statement].
  /// [ctx] the parse tree
  void exitFunction_statement(Function_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_declaration].
  /// [ctx] the parse tree
  void enterTask_declaration(Task_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_declaration].
  /// [ctx] the parse tree
  void exitTask_declaration(Task_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_port_list].
  /// [ctx] the parse tree
  void enterTask_port_list(Task_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_port_list].
  /// [ctx] the parse tree
  void exitTask_port_list(Task_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_port_item].
  /// [ctx] the parse tree
  void enterTask_port_item(Task_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_port_item].
  /// [ctx] the parse tree
  void exitTask_port_item(Task_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_port_direction].
  /// [ctx] the parse tree
  void enterTask_port_direction(Task_port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_port_direction].
  /// [ctx] the parse tree
  void exitTask_port_direction(Task_port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_item_declaration].
  /// [ctx] the parse tree
  void enterTask_item_declaration(Task_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_item_declaration].
  /// [ctx] the parse tree
  void exitTask_item_declaration(Task_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.lifetime].
  /// [ctx] the parse tree
  void enterLifetime(LifetimeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.lifetime].
  /// [ctx] the parse tree
  void exitLifetime(LifetimeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.expression].
  /// [ctx] the parse tree
  void enterExpression(ExpressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.expression].
  /// [ctx] the parse tree
  void exitExpression(ExpressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.primary].
  /// [ctx] the parse tree
  void enterPrimary(PrimaryContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.primary].
  /// [ctx] the parse tree
  void exitPrimary(PrimaryContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.literal].
  /// [ctx] the parse tree
  void enterLiteral(LiteralContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.literal].
  /// [ctx] the parse tree
  void exitLiteral(LiteralContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_identifier].
  /// [ctx] the parse tree
  void enterVariable_identifier(Variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_identifier].
  /// [ctx] the parse tree
  void exitVariable_identifier(Variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_lvalue].
  /// [ctx] the parse tree
  void enterVariable_lvalue(Variable_lvalueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_lvalue].
  /// [ctx] the parse tree
  void exitVariable_lvalue(Variable_lvalueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchy_identifier].
  /// [ctx] the parse tree
  void enterHierarchy_identifier(Hierarchy_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchy_identifier].
  /// [ctx] the parse tree
  void exitHierarchy_identifier(Hierarchy_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_path].
  /// [ctx] the parse tree
  void enterModule_path(Module_pathContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_path].
  /// [ctx] the parse tree
  void exitModule_path(Module_pathContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.concatenation].
  /// [ctx] the parse tree
  void enterConcatenation(ConcatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.concatenation].
  /// [ctx] the parse tree
  void exitConcatenation(ConcatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_subroutine_call].
  /// [ctx] the parse tree
  void enterFunction_subroutine_call(Function_subroutine_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_subroutine_call].
  /// [ctx] the parse tree
  void exitFunction_subroutine_call(Function_subroutine_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedure_call].
  /// [ctx] the parse tree
  void enterProcedure_call(Procedure_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedure_call].
  /// [ctx] the parse tree
  void exitProcedure_call(Procedure_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unary_operator].
  /// [ctx] the parse tree
  void enterUnary_operator(Unary_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unary_operator].
  /// [ctx] the parse tree
  void exitUnary_operator(Unary_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.comment].
  /// [ctx] the parse tree
  void enterComment(CommentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.comment].
  /// [ctx] the parse tree
  void exitComment(CommentContext ctx);
}