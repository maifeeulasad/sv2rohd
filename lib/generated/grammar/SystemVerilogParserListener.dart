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

  /// Enter a parse tree produced by [SystemVerilogParser.description].
  /// [ctx] the parse tree
  void enterDescription(DescriptionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.description].
  /// [ctx] the parse tree
  void exitDescription(DescriptionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_nonansi_header].
  /// [ctx] the parse tree
  void enterModule_nonansi_header(Module_nonansi_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_nonansi_header].
  /// [ctx] the parse tree
  void exitModule_nonansi_header(Module_nonansi_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_ansi_header].
  /// [ctx] the parse tree
  void enterModule_ansi_header(Module_ansi_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_ansi_header].
  /// [ctx] the parse tree
  void exitModule_ansi_header(Module_ansi_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_declaration].
  /// [ctx] the parse tree
  void enterModule_declaration(Module_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_declaration].
  /// [ctx] the parse tree
  void exitModule_declaration(Module_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_keyword].
  /// [ctx] the parse tree
  void enterModule_keyword(Module_keywordContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_keyword].
  /// [ctx] the parse tree
  void exitModule_keyword(Module_keywordContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_declaration].
  /// [ctx] the parse tree
  void enterInterface_declaration(Interface_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_declaration].
  /// [ctx] the parse tree
  void exitInterface_declaration(Interface_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_nonansi_header].
  /// [ctx] the parse tree
  void enterInterface_nonansi_header(Interface_nonansi_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_nonansi_header].
  /// [ctx] the parse tree
  void exitInterface_nonansi_header(Interface_nonansi_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_ansi_header].
  /// [ctx] the parse tree
  void enterInterface_ansi_header(Interface_ansi_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_ansi_header].
  /// [ctx] the parse tree
  void exitInterface_ansi_header(Interface_ansi_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_declaration].
  /// [ctx] the parse tree
  void enterProgram_declaration(Program_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_declaration].
  /// [ctx] the parse tree
  void exitProgram_declaration(Program_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_nonansi_header].
  /// [ctx] the parse tree
  void enterProgram_nonansi_header(Program_nonansi_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_nonansi_header].
  /// [ctx] the parse tree
  void exitProgram_nonansi_header(Program_nonansi_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_ansi_header].
  /// [ctx] the parse tree
  void enterProgram_ansi_header(Program_ansi_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_ansi_header].
  /// [ctx] the parse tree
  void exitProgram_ansi_header(Program_ansi_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_declaration].
  /// [ctx] the parse tree
  void enterChecker_declaration(Checker_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_declaration].
  /// [ctx] the parse tree
  void exitChecker_declaration(Checker_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_declaration].
  /// [ctx] the parse tree
  void enterClass_declaration(Class_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_declaration].
  /// [ctx] the parse tree
  void exitClass_declaration(Class_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_class_type].
  /// [ctx] the parse tree
  void enterInterface_class_type(Interface_class_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_class_type].
  /// [ctx] the parse tree
  void exitInterface_class_type(Interface_class_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_class_declaration].
  /// [ctx] the parse tree
  void enterInterface_class_declaration(Interface_class_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_class_declaration].
  /// [ctx] the parse tree
  void exitInterface_class_declaration(Interface_class_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_class_item].
  /// [ctx] the parse tree
  void enterInterface_class_item(Interface_class_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_class_item].
  /// [ctx] the parse tree
  void exitInterface_class_item(Interface_class_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_class_method].
  /// [ctx] the parse tree
  void enterInterface_class_method(Interface_class_methodContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_class_method].
  /// [ctx] the parse tree
  void exitInterface_class_method(Interface_class_methodContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_declaration].
  /// [ctx] the parse tree
  void enterPackage_declaration(Package_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_declaration].
  /// [ctx] the parse tree
  void exitPackage_declaration(Package_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.timeunits_declaration].
  /// [ctx] the parse tree
  void enterTimeunits_declaration(Timeunits_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.timeunits_declaration].
  /// [ctx] the parse tree
  void exitTimeunits_declaration(Timeunits_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_port_list].
  /// [ctx] the parse tree
  void enterParameter_port_list(Parameter_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_port_list].
  /// [ctx] the parse tree
  void exitParameter_port_list(Parameter_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_port_declaration].
  /// [ctx] the parse tree
  void enterParameter_port_declaration(Parameter_port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_port_declaration].
  /// [ctx] the parse tree
  void exitParameter_port_declaration(Parameter_port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_ports].
  /// [ctx] the parse tree
  void enterList_of_ports(List_of_portsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_ports].
  /// [ctx] the parse tree
  void exitList_of_ports(List_of_portsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_port_declarations].
  /// [ctx] the parse tree
  void enterList_of_port_declarations(List_of_port_declarationsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_port_declarations].
  /// [ctx] the parse tree
  void exitList_of_port_declarations(List_of_port_declarationsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_declaration].
  /// [ctx] the parse tree
  void enterPort_declaration(Port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_declaration].
  /// [ctx] the parse tree
  void exitPort_declaration(Port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port].
  /// [ctx] the parse tree
  void enterPort(PortContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port].
  /// [ctx] the parse tree
  void exitPort(PortContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_expression].
  /// [ctx] the parse tree
  void enterPort_expression(Port_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_expression].
  /// [ctx] the parse tree
  void exitPort_expression(Port_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_reference].
  /// [ctx] the parse tree
  void enterPort_reference(Port_referenceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_reference].
  /// [ctx] the parse tree
  void exitPort_reference(Port_referenceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_direction].
  /// [ctx] the parse tree
  void enterPort_direction(Port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_direction].
  /// [ctx] the parse tree
  void exitPort_direction(Port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_port_header].
  /// [ctx] the parse tree
  void enterNet_port_header(Net_port_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_port_header].
  /// [ctx] the parse tree
  void exitNet_port_header(Net_port_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_port_header].
  /// [ctx] the parse tree
  void enterVariable_port_header(Variable_port_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_port_header].
  /// [ctx] the parse tree
  void exitVariable_port_header(Variable_port_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_port_header].
  /// [ctx] the parse tree
  void enterInterface_port_header(Interface_port_headerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_port_header].
  /// [ctx] the parse tree
  void exitInterface_port_header(Interface_port_headerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ansi_port_declaration].
  /// [ctx] the parse tree
  void enterAnsi_port_declaration(Ansi_port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ansi_port_declaration].
  /// [ctx] the parse tree
  void exitAnsi_port_declaration(Ansi_port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.elaboration_system_task].
  /// [ctx] the parse tree
  void enterElaboration_system_task(Elaboration_system_taskContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.elaboration_system_task].
  /// [ctx] the parse tree
  void exitElaboration_system_task(Elaboration_system_taskContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.finish_number].
  /// [ctx] the parse tree
  void enterFinish_number(Finish_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.finish_number].
  /// [ctx] the parse tree
  void exitFinish_number(Finish_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_common_item].
  /// [ctx] the parse tree
  void enterModule_common_item(Module_common_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_common_item].
  /// [ctx] the parse tree
  void exitModule_common_item(Module_common_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_item].
  /// [ctx] the parse tree
  void enterModule_item(Module_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_item].
  /// [ctx] the parse tree
  void exitModule_item(Module_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_or_generate_item].
  /// [ctx] the parse tree
  void enterModule_or_generate_item(Module_or_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_or_generate_item].
  /// [ctx] the parse tree
  void exitModule_or_generate_item(Module_or_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_or_generate_item_declaration].
  /// [ctx] the parse tree
  void enterModule_or_generate_item_declaration(Module_or_generate_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_or_generate_item_declaration].
  /// [ctx] the parse tree
  void exitModule_or_generate_item_declaration(Module_or_generate_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_port_module_item].
  /// [ctx] the parse tree
  void enterNon_port_module_item(Non_port_module_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_port_module_item].
  /// [ctx] the parse tree
  void exitNon_port_module_item(Non_port_module_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_override].
  /// [ctx] the parse tree
  void enterParameter_override(Parameter_overrideContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_override].
  /// [ctx] the parse tree
  void exitParameter_override(Parameter_overrideContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bind_directive].
  /// [ctx] the parse tree
  void enterBind_directive(Bind_directiveContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bind_directive].
  /// [ctx] the parse tree
  void exitBind_directive(Bind_directiveContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bind_target_scope].
  /// [ctx] the parse tree
  void enterBind_target_scope(Bind_target_scopeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bind_target_scope].
  /// [ctx] the parse tree
  void exitBind_target_scope(Bind_target_scopeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bind_target_instance].
  /// [ctx] the parse tree
  void enterBind_target_instance(Bind_target_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bind_target_instance].
  /// [ctx] the parse tree
  void exitBind_target_instance(Bind_target_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bind_target_instance_list].
  /// [ctx] the parse tree
  void enterBind_target_instance_list(Bind_target_instance_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bind_target_instance_list].
  /// [ctx] the parse tree
  void exitBind_target_instance_list(Bind_target_instance_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bind_instantiation].
  /// [ctx] the parse tree
  void enterBind_instantiation(Bind_instantiationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bind_instantiation].
  /// [ctx] the parse tree
  void exitBind_instantiation(Bind_instantiationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.config_declaration].
  /// [ctx] the parse tree
  void enterConfig_declaration(Config_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.config_declaration].
  /// [ctx] the parse tree
  void exitConfig_declaration(Config_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.design_statement].
  /// [ctx] the parse tree
  void enterDesign_statement(Design_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.design_statement].
  /// [ctx] the parse tree
  void exitDesign_statement(Design_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.config_rule_statement].
  /// [ctx] the parse tree
  void enterConfig_rule_statement(Config_rule_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.config_rule_statement].
  /// [ctx] the parse tree
  void exitConfig_rule_statement(Config_rule_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.default_clause].
  /// [ctx] the parse tree
  void enterDefault_clause(Default_clauseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.default_clause].
  /// [ctx] the parse tree
  void exitDefault_clause(Default_clauseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inst_clause].
  /// [ctx] the parse tree
  void enterInst_clause(Inst_clauseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inst_clause].
  /// [ctx] the parse tree
  void exitInst_clause(Inst_clauseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inst_name].
  /// [ctx] the parse tree
  void enterInst_name(Inst_nameContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inst_name].
  /// [ctx] the parse tree
  void exitInst_name(Inst_nameContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cell_clause].
  /// [ctx] the parse tree
  void enterCell_clause(Cell_clauseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cell_clause].
  /// [ctx] the parse tree
  void exitCell_clause(Cell_clauseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.liblist_clause].
  /// [ctx] the parse tree
  void enterLiblist_clause(Liblist_clauseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.liblist_clause].
  /// [ctx] the parse tree
  void exitLiblist_clause(Liblist_clauseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.use_clause].
  /// [ctx] the parse tree
  void enterUse_clause(Use_clauseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.use_clause].
  /// [ctx] the parse tree
  void exitUse_clause(Use_clauseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_or_generate_item].
  /// [ctx] the parse tree
  void enterInterface_or_generate_item(Interface_or_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_or_generate_item].
  /// [ctx] the parse tree
  void exitInterface_or_generate_item(Interface_or_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.extern_tf_declaration].
  /// [ctx] the parse tree
  void enterExtern_tf_declaration(Extern_tf_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.extern_tf_declaration].
  /// [ctx] the parse tree
  void exitExtern_tf_declaration(Extern_tf_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_item].
  /// [ctx] the parse tree
  void enterInterface_item(Interface_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_item].
  /// [ctx] the parse tree
  void exitInterface_item(Interface_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_port_interface_item].
  /// [ctx] the parse tree
  void enterNon_port_interface_item(Non_port_interface_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_port_interface_item].
  /// [ctx] the parse tree
  void exitNon_port_interface_item(Non_port_interface_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_item].
  /// [ctx] the parse tree
  void enterProgram_item(Program_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_item].
  /// [ctx] the parse tree
  void exitProgram_item(Program_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_port_program_item].
  /// [ctx] the parse tree
  void enterNon_port_program_item(Non_port_program_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_port_program_item].
  /// [ctx] the parse tree
  void exitNon_port_program_item(Non_port_program_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_generate_item].
  /// [ctx] the parse tree
  void enterProgram_generate_item(Program_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_generate_item].
  /// [ctx] the parse tree
  void exitProgram_generate_item(Program_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_port_list].
  /// [ctx] the parse tree
  void enterChecker_port_list(Checker_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_port_list].
  /// [ctx] the parse tree
  void exitChecker_port_list(Checker_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_port_item].
  /// [ctx] the parse tree
  void enterChecker_port_item(Checker_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_port_item].
  /// [ctx] the parse tree
  void exitChecker_port_item(Checker_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_port_direction].
  /// [ctx] the parse tree
  void enterChecker_port_direction(Checker_port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_port_direction].
  /// [ctx] the parse tree
  void exitChecker_port_direction(Checker_port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_or_generate_item].
  /// [ctx] the parse tree
  void enterChecker_or_generate_item(Checker_or_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_or_generate_item].
  /// [ctx] the parse tree
  void exitChecker_or_generate_item(Checker_or_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_or_generate_item_declaration].
  /// [ctx] the parse tree
  void enterChecker_or_generate_item_declaration(Checker_or_generate_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_or_generate_item_declaration].
  /// [ctx] the parse tree
  void exitChecker_or_generate_item_declaration(Checker_or_generate_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_generate_item].
  /// [ctx] the parse tree
  void enterChecker_generate_item(Checker_generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_generate_item].
  /// [ctx] the parse tree
  void exitChecker_generate_item(Checker_generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_item].
  /// [ctx] the parse tree
  void enterClass_item(Class_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_item].
  /// [ctx] the parse tree
  void exitClass_item(Class_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_property].
  /// [ctx] the parse tree
  void enterClass_property(Class_propertyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_property].
  /// [ctx] the parse tree
  void exitClass_property(Class_propertyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_method].
  /// [ctx] the parse tree
  void enterClass_method(Class_methodContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_method].
  /// [ctx] the parse tree
  void exitClass_method(Class_methodContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_constructor_prototype].
  /// [ctx] the parse tree
  void enterClass_constructor_prototype(Class_constructor_prototypeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_constructor_prototype].
  /// [ctx] the parse tree
  void exitClass_constructor_prototype(Class_constructor_prototypeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_constraint].
  /// [ctx] the parse tree
  void enterClass_constraint(Class_constraintContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_constraint].
  /// [ctx] the parse tree
  void exitClass_constraint(Class_constraintContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_item_qualifier].
  /// [ctx] the parse tree
  void enterClass_item_qualifier(Class_item_qualifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_item_qualifier].
  /// [ctx] the parse tree
  void exitClass_item_qualifier(Class_item_qualifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_qualifier].
  /// [ctx] the parse tree
  void enterProperty_qualifier(Property_qualifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_qualifier].
  /// [ctx] the parse tree
  void exitProperty_qualifier(Property_qualifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.random_qualifier].
  /// [ctx] the parse tree
  void enterRandom_qualifier(Random_qualifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.random_qualifier].
  /// [ctx] the parse tree
  void exitRandom_qualifier(Random_qualifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.method_qualifier].
  /// [ctx] the parse tree
  void enterMethod_qualifier(Method_qualifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.method_qualifier].
  /// [ctx] the parse tree
  void exitMethod_qualifier(Method_qualifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.method_prototype].
  /// [ctx] the parse tree
  void enterMethod_prototype(Method_prototypeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.method_prototype].
  /// [ctx] the parse tree
  void exitMethod_prototype(Method_prototypeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_constructor_declaration].
  /// [ctx] the parse tree
  void enterClass_constructor_declaration(Class_constructor_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_constructor_declaration].
  /// [ctx] the parse tree
  void exitClass_constructor_declaration(Class_constructor_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_declaration].
  /// [ctx] the parse tree
  void enterConstraint_declaration(Constraint_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_declaration].
  /// [ctx] the parse tree
  void exitConstraint_declaration(Constraint_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_block].
  /// [ctx] the parse tree
  void enterConstraint_block(Constraint_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_block].
  /// [ctx] the parse tree
  void exitConstraint_block(Constraint_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_block_item].
  /// [ctx] the parse tree
  void enterConstraint_block_item(Constraint_block_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_block_item].
  /// [ctx] the parse tree
  void exitConstraint_block_item(Constraint_block_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.solve_before_list].
  /// [ctx] the parse tree
  void enterSolve_before_list(Solve_before_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.solve_before_list].
  /// [ctx] the parse tree
  void exitSolve_before_list(Solve_before_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_primary].
  /// [ctx] the parse tree
  void enterConstraint_primary(Constraint_primaryContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_primary].
  /// [ctx] the parse tree
  void exitConstraint_primary(Constraint_primaryContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_expression].
  /// [ctx] the parse tree
  void enterConstraint_expression(Constraint_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_expression].
  /// [ctx] the parse tree
  void exitConstraint_expression(Constraint_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.uniqueness_constraint].
  /// [ctx] the parse tree
  void enterUniqueness_constraint(Uniqueness_constraintContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.uniqueness_constraint].
  /// [ctx] the parse tree
  void exitUniqueness_constraint(Uniqueness_constraintContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_set].
  /// [ctx] the parse tree
  void enterConstraint_set(Constraint_setContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_set].
  /// [ctx] the parse tree
  void exitConstraint_set(Constraint_setContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dist_list].
  /// [ctx] the parse tree
  void enterDist_list(Dist_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dist_list].
  /// [ctx] the parse tree
  void exitDist_list(Dist_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dist_item].
  /// [ctx] the parse tree
  void enterDist_item(Dist_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dist_item].
  /// [ctx] the parse tree
  void exitDist_item(Dist_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dist_weight].
  /// [ctx] the parse tree
  void enterDist_weight(Dist_weightContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dist_weight].
  /// [ctx] the parse tree
  void exitDist_weight(Dist_weightContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_prototype].
  /// [ctx] the parse tree
  void enterConstraint_prototype(Constraint_prototypeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_prototype].
  /// [ctx] the parse tree
  void exitConstraint_prototype(Constraint_prototypeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_prototype_qualifier].
  /// [ctx] the parse tree
  void enterConstraint_prototype_qualifier(Constraint_prototype_qualifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_prototype_qualifier].
  /// [ctx] the parse tree
  void exitConstraint_prototype_qualifier(Constraint_prototype_qualifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.extern_constraint_declaration].
  /// [ctx] the parse tree
  void enterExtern_constraint_declaration(Extern_constraint_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.extern_constraint_declaration].
  /// [ctx] the parse tree
  void exitExtern_constraint_declaration(Extern_constraint_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.identifier_list].
  /// [ctx] the parse tree
  void enterIdentifier_list(Identifier_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.identifier_list].
  /// [ctx] the parse tree
  void exitIdentifier_list(Identifier_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_item].
  /// [ctx] the parse tree
  void enterPackage_item(Package_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_item].
  /// [ctx] the parse tree
  void exitPackage_item(Package_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_or_generate_item_declaration].
  /// [ctx] the parse tree
  void enterPackage_or_generate_item_declaration(Package_or_generate_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_or_generate_item_declaration].
  /// [ctx] the parse tree
  void exitPackage_or_generate_item_declaration(Package_or_generate_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.anonymous_program].
  /// [ctx] the parse tree
  void enterAnonymous_program(Anonymous_programContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.anonymous_program].
  /// [ctx] the parse tree
  void exitAnonymous_program(Anonymous_programContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.anonymous_program_item].
  /// [ctx] the parse tree
  void enterAnonymous_program_item(Anonymous_program_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.anonymous_program_item].
  /// [ctx] the parse tree
  void exitAnonymous_program_item(Anonymous_program_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.local_parameter_declaration].
  /// [ctx] the parse tree
  void enterLocal_parameter_declaration(Local_parameter_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.local_parameter_declaration].
  /// [ctx] the parse tree
  void exitLocal_parameter_declaration(Local_parameter_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_declaration].
  /// [ctx] the parse tree
  void enterParameter_declaration(Parameter_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_declaration].
  /// [ctx] the parse tree
  void exitParameter_declaration(Parameter_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.specparam_declaration].
  /// [ctx] the parse tree
  void enterSpecparam_declaration(Specparam_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.specparam_declaration].
  /// [ctx] the parse tree
  void exitSpecparam_declaration(Specparam_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inout_declaration].
  /// [ctx] the parse tree
  void enterInout_declaration(Inout_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inout_declaration].
  /// [ctx] the parse tree
  void exitInout_declaration(Inout_declarationContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.interface_port_declaration].
  /// [ctx] the parse tree
  void enterInterface_port_declaration(Interface_port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_port_declaration].
  /// [ctx] the parse tree
  void exitInterface_port_declaration(Interface_port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ref_declaration].
  /// [ctx] the parse tree
  void enterRef_declaration(Ref_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ref_declaration].
  /// [ctx] the parse tree
  void exitRef_declaration(Ref_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_declaration].
  /// [ctx] the parse tree
  void enterData_declaration(Data_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_declaration].
  /// [ctx] the parse tree
  void exitData_declaration(Data_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_import_declaration].
  /// [ctx] the parse tree
  void enterPackage_import_declaration(Package_import_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_import_declaration].
  /// [ctx] the parse tree
  void exitPackage_import_declaration(Package_import_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_import_item].
  /// [ctx] the parse tree
  void enterPackage_import_item(Package_import_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_import_item].
  /// [ctx] the parse tree
  void exitPackage_import_item(Package_import_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_export_declaration].
  /// [ctx] the parse tree
  void enterPackage_export_declaration(Package_export_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_export_declaration].
  /// [ctx] the parse tree
  void exitPackage_export_declaration(Package_export_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.genvar_declaration].
  /// [ctx] the parse tree
  void enterGenvar_declaration(Genvar_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.genvar_declaration].
  /// [ctx] the parse tree
  void exitGenvar_declaration(Genvar_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_declaration].
  /// [ctx] the parse tree
  void enterNet_declaration(Net_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_declaration].
  /// [ctx] the parse tree
  void exitNet_declaration(Net_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.type_declaration].
  /// [ctx] the parse tree
  void enterType_declaration(Type_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.type_declaration].
  /// [ctx] the parse tree
  void exitType_declaration(Type_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_type_declaration].
  /// [ctx] the parse tree
  void enterNet_type_declaration(Net_type_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_type_declaration].
  /// [ctx] the parse tree
  void exitNet_type_declaration(Net_type_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.lifetime].
  /// [ctx] the parse tree
  void enterLifetime(LifetimeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.lifetime].
  /// [ctx] the parse tree
  void exitLifetime(LifetimeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.casting_type].
  /// [ctx] the parse tree
  void enterCasting_type(Casting_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.casting_type].
  /// [ctx] the parse tree
  void exitCasting_type(Casting_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_type].
  /// [ctx] the parse tree
  void enterData_type(Data_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_type].
  /// [ctx] the parse tree
  void exitData_type(Data_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_type_or_implicit].
  /// [ctx] the parse tree
  void enterData_type_or_implicit(Data_type_or_implicitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_type_or_implicit].
  /// [ctx] the parse tree
  void exitData_type_or_implicit(Data_type_or_implicitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.implicit_data_type].
  /// [ctx] the parse tree
  void enterImplicit_data_type(Implicit_data_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.implicit_data_type].
  /// [ctx] the parse tree
  void exitImplicit_data_type(Implicit_data_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.enum_base_type].
  /// [ctx] the parse tree
  void enterEnum_base_type(Enum_base_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.enum_base_type].
  /// [ctx] the parse tree
  void exitEnum_base_type(Enum_base_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.enum_name_declaration].
  /// [ctx] the parse tree
  void enterEnum_name_declaration(Enum_name_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.enum_name_declaration].
  /// [ctx] the parse tree
  void exitEnum_name_declaration(Enum_name_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_scope].
  /// [ctx] the parse tree
  void enterClass_scope(Class_scopeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_scope].
  /// [ctx] the parse tree
  void exitClass_scope(Class_scopeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_type].
  /// [ctx] the parse tree
  void enterClass_type(Class_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_type].
  /// [ctx] the parse tree
  void exitClass_type(Class_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.integer_type].
  /// [ctx] the parse tree
  void enterInteger_type(Integer_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.integer_type].
  /// [ctx] the parse tree
  void exitInteger_type(Integer_typeContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.non_integer_type].
  /// [ctx] the parse tree
  void enterNon_integer_type(Non_integer_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_integer_type].
  /// [ctx] the parse tree
  void exitNon_integer_type(Non_integer_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_type].
  /// [ctx] the parse tree
  void enterNet_type(Net_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_type].
  /// [ctx] the parse tree
  void exitNet_type(Net_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_port_type].
  /// [ctx] the parse tree
  void enterNet_port_type(Net_port_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_port_type].
  /// [ctx] the parse tree
  void exitNet_port_type(Net_port_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_port_type].
  /// [ctx] the parse tree
  void enterVariable_port_type(Variable_port_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_port_type].
  /// [ctx] the parse tree
  void exitVariable_port_type(Variable_port_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.var_data_type].
  /// [ctx] the parse tree
  void enterVar_data_type(Var_data_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.var_data_type].
  /// [ctx] the parse tree
  void exitVar_data_type(Var_data_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.signing].
  /// [ctx] the parse tree
  void enterSigning(SigningContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.signing].
  /// [ctx] the parse tree
  void exitSigning(SigningContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.simple_type].
  /// [ctx] the parse tree
  void enterSimple_type(Simple_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.simple_type].
  /// [ctx] the parse tree
  void exitSimple_type(Simple_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.struct_union_member].
  /// [ctx] the parse tree
  void enterStruct_union_member(Struct_union_memberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.struct_union_member].
  /// [ctx] the parse tree
  void exitStruct_union_member(Struct_union_memberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.data_type_or_void].
  /// [ctx] the parse tree
  void enterData_type_or_void(Data_type_or_voidContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.data_type_or_void].
  /// [ctx] the parse tree
  void exitData_type_or_void(Data_type_or_voidContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.struct_union].
  /// [ctx] the parse tree
  void enterStruct_union(Struct_unionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.struct_union].
  /// [ctx] the parse tree
  void exitStruct_union(Struct_unionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.type_reference].
  /// [ctx] the parse tree
  void enterType_reference(Type_referenceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.type_reference].
  /// [ctx] the parse tree
  void exitType_reference(Type_referenceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.drive_strength].
  /// [ctx] the parse tree
  void enterDrive_strength(Drive_strengthContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.drive_strength].
  /// [ctx] the parse tree
  void exitDrive_strength(Drive_strengthContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.charge_strength].
  /// [ctx] the parse tree
  void enterCharge_strength(Charge_strengthContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.charge_strength].
  /// [ctx] the parse tree
  void exitCharge_strength(Charge_strengthContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay3].
  /// [ctx] the parse tree
  void enterDelay3(Delay3Context ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay3].
  /// [ctx] the parse tree
  void exitDelay3(Delay3Context ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay2].
  /// [ctx] the parse tree
  void enterDelay2(Delay2Context ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay2].
  /// [ctx] the parse tree
  void exitDelay2(Delay2Context ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay_value].
  /// [ctx] the parse tree
  void enterDelay_value(Delay_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay_value].
  /// [ctx] the parse tree
  void exitDelay_value(Delay_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_defparam_assignments].
  /// [ctx] the parse tree
  void enterList_of_defparam_assignments(List_of_defparam_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_defparam_assignments].
  /// [ctx] the parse tree
  void exitList_of_defparam_assignments(List_of_defparam_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_genvar_identifiers].
  /// [ctx] the parse tree
  void enterList_of_genvar_identifiers(List_of_genvar_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_genvar_identifiers].
  /// [ctx] the parse tree
  void exitList_of_genvar_identifiers(List_of_genvar_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_interface_identifiers].
  /// [ctx] the parse tree
  void enterList_of_interface_identifiers(List_of_interface_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_interface_identifiers].
  /// [ctx] the parse tree
  void exitList_of_interface_identifiers(List_of_interface_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_net_decl_assignments].
  /// [ctx] the parse tree
  void enterList_of_net_decl_assignments(List_of_net_decl_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_net_decl_assignments].
  /// [ctx] the parse tree
  void exitList_of_net_decl_assignments(List_of_net_decl_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_param_assignments].
  /// [ctx] the parse tree
  void enterList_of_param_assignments(List_of_param_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_param_assignments].
  /// [ctx] the parse tree
  void exitList_of_param_assignments(List_of_param_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_port_identifiers].
  /// [ctx] the parse tree
  void enterList_of_port_identifiers(List_of_port_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_port_identifiers].
  /// [ctx] the parse tree
  void exitList_of_port_identifiers(List_of_port_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_specparam_assignments].
  /// [ctx] the parse tree
  void enterList_of_specparam_assignments(List_of_specparam_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_specparam_assignments].
  /// [ctx] the parse tree
  void exitList_of_specparam_assignments(List_of_specparam_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_tf_variable_identifiers].
  /// [ctx] the parse tree
  void enterList_of_tf_variable_identifiers(List_of_tf_variable_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_tf_variable_identifiers].
  /// [ctx] the parse tree
  void exitList_of_tf_variable_identifiers(List_of_tf_variable_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_type_assignments].
  /// [ctx] the parse tree
  void enterList_of_type_assignments(List_of_type_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_type_assignments].
  /// [ctx] the parse tree
  void exitList_of_type_assignments(List_of_type_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_udp_port_identifiers].
  /// [ctx] the parse tree
  void enterList_of_udp_port_identifiers(List_of_udp_port_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_udp_port_identifiers].
  /// [ctx] the parse tree
  void exitList_of_udp_port_identifiers(List_of_udp_port_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_variable_decl_assignments].
  /// [ctx] the parse tree
  void enterList_of_variable_decl_assignments(List_of_variable_decl_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_variable_decl_assignments].
  /// [ctx] the parse tree
  void exitList_of_variable_decl_assignments(List_of_variable_decl_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_variable_identifiers].
  /// [ctx] the parse tree
  void enterList_of_variable_identifiers(List_of_variable_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_variable_identifiers].
  /// [ctx] the parse tree
  void exitList_of_variable_identifiers(List_of_variable_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_variable_port_identifiers].
  /// [ctx] the parse tree
  void enterList_of_variable_port_identifiers(List_of_variable_port_identifiersContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_variable_port_identifiers].
  /// [ctx] the parse tree
  void exitList_of_variable_port_identifiers(List_of_variable_port_identifiersContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.defparam_assignment].
  /// [ctx] the parse tree
  void enterDefparam_assignment(Defparam_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.defparam_assignment].
  /// [ctx] the parse tree
  void exitDefparam_assignment(Defparam_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_decl_assignment].
  /// [ctx] the parse tree
  void enterNet_decl_assignment(Net_decl_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_decl_assignment].
  /// [ctx] the parse tree
  void exitNet_decl_assignment(Net_decl_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.param_assignment].
  /// [ctx] the parse tree
  void enterParam_assignment(Param_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.param_assignment].
  /// [ctx] the parse tree
  void exitParam_assignment(Param_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.specparam_assignment].
  /// [ctx] the parse tree
  void enterSpecparam_assignment(Specparam_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.specparam_assignment].
  /// [ctx] the parse tree
  void exitSpecparam_assignment(Specparam_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.type_assignment].
  /// [ctx] the parse tree
  void enterType_assignment(Type_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.type_assignment].
  /// [ctx] the parse tree
  void exitType_assignment(Type_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.pulse_control_specparam].
  /// [ctx] the parse tree
  void enterPulse_control_specparam(Pulse_control_specparamContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.pulse_control_specparam].
  /// [ctx] the parse tree
  void exitPulse_control_specparam(Pulse_control_specparamContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.error_limit_value].
  /// [ctx] the parse tree
  void enterError_limit_value(Error_limit_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.error_limit_value].
  /// [ctx] the parse tree
  void exitError_limit_value(Error_limit_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.reject_limit_value].
  /// [ctx] the parse tree
  void enterReject_limit_value(Reject_limit_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.reject_limit_value].
  /// [ctx] the parse tree
  void exitReject_limit_value(Reject_limit_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.limit_value].
  /// [ctx] the parse tree
  void enterLimit_value(Limit_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.limit_value].
  /// [ctx] the parse tree
  void exitLimit_value(Limit_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_decl_assignment].
  /// [ctx] the parse tree
  void enterVariable_decl_assignment(Variable_decl_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_decl_assignment].
  /// [ctx] the parse tree
  void exitVariable_decl_assignment(Variable_decl_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_new].
  /// [ctx] the parse tree
  void enterClass_new(Class_newContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_new].
  /// [ctx] the parse tree
  void exitClass_new(Class_newContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dynamic_array_new].
  /// [ctx] the parse tree
  void enterDynamic_array_new(Dynamic_array_newContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dynamic_array_new].
  /// [ctx] the parse tree
  void exitDynamic_array_new(Dynamic_array_newContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unpacked_dimension].
  /// [ctx] the parse tree
  void enterUnpacked_dimension(Unpacked_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unpacked_dimension].
  /// [ctx] the parse tree
  void exitUnpacked_dimension(Unpacked_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.packed_dimension].
  /// [ctx] the parse tree
  void enterPacked_dimension(Packed_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.packed_dimension].
  /// [ctx] the parse tree
  void exitPacked_dimension(Packed_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.associative_dimension].
  /// [ctx] the parse tree
  void enterAssociative_dimension(Associative_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.associative_dimension].
  /// [ctx] the parse tree
  void exitAssociative_dimension(Associative_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_dimension].
  /// [ctx] the parse tree
  void enterVariable_dimension(Variable_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_dimension].
  /// [ctx] the parse tree
  void exitVariable_dimension(Variable_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.queue_dimension].
  /// [ctx] the parse tree
  void enterQueue_dimension(Queue_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.queue_dimension].
  /// [ctx] the parse tree
  void exitQueue_dimension(Queue_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unsized_dimension].
  /// [ctx] the parse tree
  void enterUnsized_dimension(Unsized_dimensionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unsized_dimension].
  /// [ctx] the parse tree
  void exitUnsized_dimension(Unsized_dimensionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_data_type_or_implicit].
  /// [ctx] the parse tree
  void enterFunction_data_type_or_implicit(Function_data_type_or_implicitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_data_type_or_implicit].
  /// [ctx] the parse tree
  void exitFunction_data_type_or_implicit(Function_data_type_or_implicitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_declaration].
  /// [ctx] the parse tree
  void enterFunction_declaration(Function_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_declaration].
  /// [ctx] the parse tree
  void exitFunction_declaration(Function_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_body_declaration].
  /// [ctx] the parse tree
  void enterFunction_body_declaration(Function_body_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_body_declaration].
  /// [ctx] the parse tree
  void exitFunction_body_declaration(Function_body_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_prototype].
  /// [ctx] the parse tree
  void enterFunction_prototype(Function_prototypeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_prototype].
  /// [ctx] the parse tree
  void exitFunction_prototype(Function_prototypeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dpi_import_export].
  /// [ctx] the parse tree
  void enterDpi_import_export(Dpi_import_exportContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dpi_import_export].
  /// [ctx] the parse tree
  void exitDpi_import_export(Dpi_import_exportContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dpi_spec_string].
  /// [ctx] the parse tree
  void enterDpi_spec_string(Dpi_spec_stringContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dpi_spec_string].
  /// [ctx] the parse tree
  void exitDpi_spec_string(Dpi_spec_stringContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dpi_function_import_property].
  /// [ctx] the parse tree
  void enterDpi_function_import_property(Dpi_function_import_propertyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dpi_function_import_property].
  /// [ctx] the parse tree
  void exitDpi_function_import_property(Dpi_function_import_propertyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dpi_task_import_property].
  /// [ctx] the parse tree
  void enterDpi_task_import_property(Dpi_task_import_propertyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dpi_task_import_property].
  /// [ctx] the parse tree
  void exitDpi_task_import_property(Dpi_task_import_propertyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dpi_function_proto].
  /// [ctx] the parse tree
  void enterDpi_function_proto(Dpi_function_protoContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dpi_function_proto].
  /// [ctx] the parse tree
  void exitDpi_function_proto(Dpi_function_protoContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dpi_task_proto].
  /// [ctx] the parse tree
  void enterDpi_task_proto(Dpi_task_protoContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dpi_task_proto].
  /// [ctx] the parse tree
  void exitDpi_task_proto(Dpi_task_protoContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_declaration].
  /// [ctx] the parse tree
  void enterTask_declaration(Task_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_declaration].
  /// [ctx] the parse tree
  void exitTask_declaration(Task_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_body_declaration].
  /// [ctx] the parse tree
  void enterTask_body_declaration(Task_body_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_body_declaration].
  /// [ctx] the parse tree
  void exitTask_body_declaration(Task_body_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_item_declaration].
  /// [ctx] the parse tree
  void enterTf_item_declaration(Tf_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_item_declaration].
  /// [ctx] the parse tree
  void exitTf_item_declaration(Tf_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_port_list].
  /// [ctx] the parse tree
  void enterTf_port_list(Tf_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_port_list].
  /// [ctx] the parse tree
  void exitTf_port_list(Tf_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_port_item].
  /// [ctx] the parse tree
  void enterTf_port_item(Tf_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_port_item].
  /// [ctx] the parse tree
  void exitTf_port_item(Tf_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_port_direction].
  /// [ctx] the parse tree
  void enterTf_port_direction(Tf_port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_port_direction].
  /// [ctx] the parse tree
  void exitTf_port_direction(Tf_port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_port_declaration].
  /// [ctx] the parse tree
  void enterTf_port_declaration(Tf_port_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_port_declaration].
  /// [ctx] the parse tree
  void exitTf_port_declaration(Tf_port_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_prototype].
  /// [ctx] the parse tree
  void enterTask_prototype(Task_prototypeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_prototype].
  /// [ctx] the parse tree
  void exitTask_prototype(Task_prototypeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.block_item_declaration].
  /// [ctx] the parse tree
  void enterBlock_item_declaration(Block_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.block_item_declaration].
  /// [ctx] the parse tree
  void exitBlock_item_declaration(Block_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.overload_declaration].
  /// [ctx] the parse tree
  void enterOverload_declaration(Overload_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.overload_declaration].
  /// [ctx] the parse tree
  void exitOverload_declaration(Overload_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.overload_operator].
  /// [ctx] the parse tree
  void enterOverload_operator(Overload_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.overload_operator].
  /// [ctx] the parse tree
  void exitOverload_operator(Overload_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.overload_proto_formals].
  /// [ctx] the parse tree
  void enterOverload_proto_formals(Overload_proto_formalsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.overload_proto_formals].
  /// [ctx] the parse tree
  void exitOverload_proto_formals(Overload_proto_formalsContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.modport_ports_declaration].
  /// [ctx] the parse tree
  void enterModport_ports_declaration(Modport_ports_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_ports_declaration].
  /// [ctx] the parse tree
  void exitModport_ports_declaration(Modport_ports_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_clocking_declaration].
  /// [ctx] the parse tree
  void enterModport_clocking_declaration(Modport_clocking_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_clocking_declaration].
  /// [ctx] the parse tree
  void exitModport_clocking_declaration(Modport_clocking_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_simple_ports_declaration].
  /// [ctx] the parse tree
  void enterModport_simple_ports_declaration(Modport_simple_ports_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_simple_ports_declaration].
  /// [ctx] the parse tree
  void exitModport_simple_ports_declaration(Modport_simple_ports_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_simple_port].
  /// [ctx] the parse tree
  void enterModport_simple_port(Modport_simple_portContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_simple_port].
  /// [ctx] the parse tree
  void exitModport_simple_port(Modport_simple_portContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_tf_ports_declaration].
  /// [ctx] the parse tree
  void enterModport_tf_ports_declaration(Modport_tf_ports_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_tf_ports_declaration].
  /// [ctx] the parse tree
  void exitModport_tf_ports_declaration(Modport_tf_ports_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_tf_port].
  /// [ctx] the parse tree
  void enterModport_tf_port(Modport_tf_portContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_tf_port].
  /// [ctx] the parse tree
  void exitModport_tf_port(Modport_tf_portContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.import_export].
  /// [ctx] the parse tree
  void enterImport_export(Import_exportContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.import_export].
  /// [ctx] the parse tree
  void exitImport_export(Import_exportContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.concurrent_assertion_item].
  /// [ctx] the parse tree
  void enterConcurrent_assertion_item(Concurrent_assertion_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.concurrent_assertion_item].
  /// [ctx] the parse tree
  void exitConcurrent_assertion_item(Concurrent_assertion_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.concurrent_assertion_statement].
  /// [ctx] the parse tree
  void enterConcurrent_assertion_statement(Concurrent_assertion_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.concurrent_assertion_statement].
  /// [ctx] the parse tree
  void exitConcurrent_assertion_statement(Concurrent_assertion_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assert_property_statement].
  /// [ctx] the parse tree
  void enterAssert_property_statement(Assert_property_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assert_property_statement].
  /// [ctx] the parse tree
  void exitAssert_property_statement(Assert_property_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assume_property_statement].
  /// [ctx] the parse tree
  void enterAssume_property_statement(Assume_property_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assume_property_statement].
  /// [ctx] the parse tree
  void exitAssume_property_statement(Assume_property_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cover_property_statement].
  /// [ctx] the parse tree
  void enterCover_property_statement(Cover_property_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cover_property_statement].
  /// [ctx] the parse tree
  void exitCover_property_statement(Cover_property_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.expect_property_statement].
  /// [ctx] the parse tree
  void enterExpect_property_statement(Expect_property_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.expect_property_statement].
  /// [ctx] the parse tree
  void exitExpect_property_statement(Expect_property_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cover_sequence_statement].
  /// [ctx] the parse tree
  void enterCover_sequence_statement(Cover_sequence_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cover_sequence_statement].
  /// [ctx] the parse tree
  void exitCover_sequence_statement(Cover_sequence_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.restrict_property_statement].
  /// [ctx] the parse tree
  void enterRestrict_property_statement(Restrict_property_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.restrict_property_statement].
  /// [ctx] the parse tree
  void exitRestrict_property_statement(Restrict_property_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_instance].
  /// [ctx] the parse tree
  void enterProperty_instance(Property_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_instance].
  /// [ctx] the parse tree
  void exitProperty_instance(Property_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_list_of_arguments].
  /// [ctx] the parse tree
  void enterProperty_list_of_arguments(Property_list_of_argumentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_list_of_arguments].
  /// [ctx] the parse tree
  void exitProperty_list_of_arguments(Property_list_of_argumentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_actual_arg].
  /// [ctx] the parse tree
  void enterProperty_actual_arg(Property_actual_argContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_actual_arg].
  /// [ctx] the parse tree
  void exitProperty_actual_arg(Property_actual_argContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assertion_item_declaration].
  /// [ctx] the parse tree
  void enterAssertion_item_declaration(Assertion_item_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assertion_item_declaration].
  /// [ctx] the parse tree
  void exitAssertion_item_declaration(Assertion_item_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_declaration].
  /// [ctx] the parse tree
  void enterProperty_declaration(Property_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_declaration].
  /// [ctx] the parse tree
  void exitProperty_declaration(Property_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_port_list].
  /// [ctx] the parse tree
  void enterProperty_port_list(Property_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_port_list].
  /// [ctx] the parse tree
  void exitProperty_port_list(Property_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_port_item].
  /// [ctx] the parse tree
  void enterProperty_port_item(Property_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_port_item].
  /// [ctx] the parse tree
  void exitProperty_port_item(Property_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_lvar_port_direction].
  /// [ctx] the parse tree
  void enterProperty_lvar_port_direction(Property_lvar_port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_lvar_port_direction].
  /// [ctx] the parse tree
  void exitProperty_lvar_port_direction(Property_lvar_port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_formal_type].
  /// [ctx] the parse tree
  void enterProperty_formal_type(Property_formal_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_formal_type].
  /// [ctx] the parse tree
  void exitProperty_formal_type(Property_formal_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_spec].
  /// [ctx] the parse tree
  void enterProperty_spec(Property_specContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_spec].
  /// [ctx] the parse tree
  void exitProperty_spec(Property_specContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_expr].
  /// [ctx] the parse tree
  void enterProperty_expr(Property_exprContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_expr].
  /// [ctx] the parse tree
  void exitProperty_expr(Property_exprContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_case_item].
  /// [ctx] the parse tree
  void enterProperty_case_item(Property_case_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_case_item].
  /// [ctx] the parse tree
  void exitProperty_case_item(Property_case_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_declaration].
  /// [ctx] the parse tree
  void enterSequence_declaration(Sequence_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_declaration].
  /// [ctx] the parse tree
  void exitSequence_declaration(Sequence_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_port_list].
  /// [ctx] the parse tree
  void enterSequence_port_list(Sequence_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_port_list].
  /// [ctx] the parse tree
  void exitSequence_port_list(Sequence_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_port_item].
  /// [ctx] the parse tree
  void enterSequence_port_item(Sequence_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_port_item].
  /// [ctx] the parse tree
  void exitSequence_port_item(Sequence_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_lvar_port_direction].
  /// [ctx] the parse tree
  void enterSequence_lvar_port_direction(Sequence_lvar_port_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_lvar_port_direction].
  /// [ctx] the parse tree
  void exitSequence_lvar_port_direction(Sequence_lvar_port_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_formal_type].
  /// [ctx] the parse tree
  void enterSequence_formal_type(Sequence_formal_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_formal_type].
  /// [ctx] the parse tree
  void exitSequence_formal_type(Sequence_formal_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_expr].
  /// [ctx] the parse tree
  void enterSequence_expr(Sequence_exprContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_expr].
  /// [ctx] the parse tree
  void exitSequence_expr(Sequence_exprContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cycle_delay_range].
  /// [ctx] the parse tree
  void enterCycle_delay_range(Cycle_delay_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cycle_delay_range].
  /// [ctx] the parse tree
  void exitCycle_delay_range(Cycle_delay_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_method_call].
  /// [ctx] the parse tree
  void enterSequence_method_call(Sequence_method_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_method_call].
  /// [ctx] the parse tree
  void exitSequence_method_call(Sequence_method_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_match_item].
  /// [ctx] the parse tree
  void enterSequence_match_item(Sequence_match_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_match_item].
  /// [ctx] the parse tree
  void exitSequence_match_item(Sequence_match_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_instance].
  /// [ctx] the parse tree
  void enterSequence_instance(Sequence_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_instance].
  /// [ctx] the parse tree
  void exitSequence_instance(Sequence_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_list_of_arguments].
  /// [ctx] the parse tree
  void enterSequence_list_of_arguments(Sequence_list_of_argumentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_list_of_arguments].
  /// [ctx] the parse tree
  void exitSequence_list_of_arguments(Sequence_list_of_argumentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_actual_arg].
  /// [ctx] the parse tree
  void enterSequence_actual_arg(Sequence_actual_argContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_actual_arg].
  /// [ctx] the parse tree
  void exitSequence_actual_arg(Sequence_actual_argContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.boolean_abbrev].
  /// [ctx] the parse tree
  void enterBoolean_abbrev(Boolean_abbrevContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.boolean_abbrev].
  /// [ctx] the parse tree
  void exitBoolean_abbrev(Boolean_abbrevContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_abbrev].
  /// [ctx] the parse tree
  void enterSequence_abbrev(Sequence_abbrevContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_abbrev].
  /// [ctx] the parse tree
  void exitSequence_abbrev(Sequence_abbrevContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.consecutive_repetition].
  /// [ctx] the parse tree
  void enterConsecutive_repetition(Consecutive_repetitionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.consecutive_repetition].
  /// [ctx] the parse tree
  void exitConsecutive_repetition(Consecutive_repetitionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_consecutive_repetition].
  /// [ctx] the parse tree
  void enterNon_consecutive_repetition(Non_consecutive_repetitionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_consecutive_repetition].
  /// [ctx] the parse tree
  void exitNon_consecutive_repetition(Non_consecutive_repetitionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.goto_repetition].
  /// [ctx] the parse tree
  void enterGoto_repetition(Goto_repetitionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.goto_repetition].
  /// [ctx] the parse tree
  void exitGoto_repetition(Goto_repetitionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.const_or_range_expression].
  /// [ctx] the parse tree
  void enterConst_or_range_expression(Const_or_range_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.const_or_range_expression].
  /// [ctx] the parse tree
  void exitConst_or_range_expression(Const_or_range_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cycle_delay_const_range_expression].
  /// [ctx] the parse tree
  void enterCycle_delay_const_range_expression(Cycle_delay_const_range_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cycle_delay_const_range_expression].
  /// [ctx] the parse tree
  void exitCycle_delay_const_range_expression(Cycle_delay_const_range_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.expression_or_dist].
  /// [ctx] the parse tree
  void enterExpression_or_dist(Expression_or_distContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.expression_or_dist].
  /// [ctx] the parse tree
  void exitExpression_or_dist(Expression_or_distContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assertion_variable_declaration].
  /// [ctx] the parse tree
  void enterAssertion_variable_declaration(Assertion_variable_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assertion_variable_declaration].
  /// [ctx] the parse tree
  void exitAssertion_variable_declaration(Assertion_variable_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_declaration].
  /// [ctx] the parse tree
  void enterLet_declaration(Let_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_declaration].
  /// [ctx] the parse tree
  void exitLet_declaration(Let_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_identifier].
  /// [ctx] the parse tree
  void enterLet_identifier(Let_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_identifier].
  /// [ctx] the parse tree
  void exitLet_identifier(Let_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_port_list].
  /// [ctx] the parse tree
  void enterLet_port_list(Let_port_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_port_list].
  /// [ctx] the parse tree
  void exitLet_port_list(Let_port_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_port_item].
  /// [ctx] the parse tree
  void enterLet_port_item(Let_port_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_port_item].
  /// [ctx] the parse tree
  void exitLet_port_item(Let_port_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_formal_type].
  /// [ctx] the parse tree
  void enterLet_formal_type(Let_formal_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_formal_type].
  /// [ctx] the parse tree
  void exitLet_formal_type(Let_formal_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_expression].
  /// [ctx] the parse tree
  void enterLet_expression(Let_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_expression].
  /// [ctx] the parse tree
  void exitLet_expression(Let_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_list_of_arguments].
  /// [ctx] the parse tree
  void enterLet_list_of_arguments(Let_list_of_argumentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_list_of_arguments].
  /// [ctx] the parse tree
  void exitLet_list_of_arguments(Let_list_of_argumentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.let_actual_arg].
  /// [ctx] the parse tree
  void enterLet_actual_arg(Let_actual_argContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.let_actual_arg].
  /// [ctx] the parse tree
  void exitLet_actual_arg(Let_actual_argContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.covergroup_declaration].
  /// [ctx] the parse tree
  void enterCovergroup_declaration(Covergroup_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.covergroup_declaration].
  /// [ctx] the parse tree
  void exitCovergroup_declaration(Covergroup_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.coverage_spec_or_option].
  /// [ctx] the parse tree
  void enterCoverage_spec_or_option(Coverage_spec_or_optionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.coverage_spec_or_option].
  /// [ctx] the parse tree
  void exitCoverage_spec_or_option(Coverage_spec_or_optionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.coverage_option].
  /// [ctx] the parse tree
  void enterCoverage_option(Coverage_optionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.coverage_option].
  /// [ctx] the parse tree
  void exitCoverage_option(Coverage_optionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.coverage_spec].
  /// [ctx] the parse tree
  void enterCoverage_spec(Coverage_specContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.coverage_spec].
  /// [ctx] the parse tree
  void exitCoverage_spec(Coverage_specContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.coverage_event].
  /// [ctx] the parse tree
  void enterCoverage_event(Coverage_eventContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.coverage_event].
  /// [ctx] the parse tree
  void exitCoverage_event(Coverage_eventContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.block_event_expression].
  /// [ctx] the parse tree
  void enterBlock_event_expression(Block_event_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.block_event_expression].
  /// [ctx] the parse tree
  void exitBlock_event_expression(Block_event_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_btf_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_btf_identifier(Hierarchical_btf_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_btf_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_btf_identifier(Hierarchical_btf_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cover_point].
  /// [ctx] the parse tree
  void enterCover_point(Cover_pointContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cover_point].
  /// [ctx] the parse tree
  void exitCover_point(Cover_pointContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bins_or_empty].
  /// [ctx] the parse tree
  void enterBins_or_empty(Bins_or_emptyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bins_or_empty].
  /// [ctx] the parse tree
  void exitBins_or_empty(Bins_or_emptyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bins_or_options].
  /// [ctx] the parse tree
  void enterBins_or_options(Bins_or_optionsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bins_or_options].
  /// [ctx] the parse tree
  void exitBins_or_options(Bins_or_optionsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bins_keyword].
  /// [ctx] the parse tree
  void enterBins_keyword(Bins_keywordContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bins_keyword].
  /// [ctx] the parse tree
  void exitBins_keyword(Bins_keywordContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.trans_list].
  /// [ctx] the parse tree
  void enterTrans_list(Trans_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.trans_list].
  /// [ctx] the parse tree
  void exitTrans_list(Trans_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.trans_set].
  /// [ctx] the parse tree
  void enterTrans_set(Trans_setContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.trans_set].
  /// [ctx] the parse tree
  void exitTrans_set(Trans_setContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.trans_range_list].
  /// [ctx] the parse tree
  void enterTrans_range_list(Trans_range_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.trans_range_list].
  /// [ctx] the parse tree
  void exitTrans_range_list(Trans_range_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.trans_item].
  /// [ctx] the parse tree
  void enterTrans_item(Trans_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.trans_item].
  /// [ctx] the parse tree
  void exitTrans_item(Trans_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.repeat_range].
  /// [ctx] the parse tree
  void enterRepeat_range(Repeat_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.repeat_range].
  /// [ctx] the parse tree
  void exitRepeat_range(Repeat_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cover_cross].
  /// [ctx] the parse tree
  void enterCover_cross(Cover_crossContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cover_cross].
  /// [ctx] the parse tree
  void exitCover_cross(Cover_crossContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_cross_items].
  /// [ctx] the parse tree
  void enterList_of_cross_items(List_of_cross_itemsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_cross_items].
  /// [ctx] the parse tree
  void exitList_of_cross_items(List_of_cross_itemsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cross_item].
  /// [ctx] the parse tree
  void enterCross_item(Cross_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cross_item].
  /// [ctx] the parse tree
  void exitCross_item(Cross_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cross_body].
  /// [ctx] the parse tree
  void enterCross_body(Cross_bodyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cross_body].
  /// [ctx] the parse tree
  void exitCross_body(Cross_bodyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cross_body_item].
  /// [ctx] the parse tree
  void enterCross_body_item(Cross_body_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cross_body_item].
  /// [ctx] the parse tree
  void exitCross_body_item(Cross_body_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bins_selection_or_option].
  /// [ctx] the parse tree
  void enterBins_selection_or_option(Bins_selection_or_optionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bins_selection_or_option].
  /// [ctx] the parse tree
  void exitBins_selection_or_option(Bins_selection_or_optionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bins_selection].
  /// [ctx] the parse tree
  void enterBins_selection(Bins_selectionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bins_selection].
  /// [ctx] the parse tree
  void exitBins_selection(Bins_selectionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.select_expression].
  /// [ctx] the parse tree
  void enterSelect_expression(Select_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.select_expression].
  /// [ctx] the parse tree
  void exitSelect_expression(Select_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.select_condition].
  /// [ctx] the parse tree
  void enterSelect_condition(Select_conditionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.select_condition].
  /// [ctx] the parse tree
  void exitSelect_condition(Select_conditionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bins_expression].
  /// [ctx] the parse tree
  void enterBins_expression(Bins_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bins_expression].
  /// [ctx] the parse tree
  void exitBins_expression(Bins_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.covergroup_range_list].
  /// [ctx] the parse tree
  void enterCovergroup_range_list(Covergroup_range_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.covergroup_range_list].
  /// [ctx] the parse tree
  void exitCovergroup_range_list(Covergroup_range_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.covergroup_value_range].
  /// [ctx] the parse tree
  void enterCovergroup_value_range(Covergroup_value_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.covergroup_value_range].
  /// [ctx] the parse tree
  void exitCovergroup_value_range(Covergroup_value_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.with_covergroup_expression].
  /// [ctx] the parse tree
  void enterWith_covergroup_expression(With_covergroup_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.with_covergroup_expression].
  /// [ctx] the parse tree
  void exitWith_covergroup_expression(With_covergroup_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.set_covergroup_expression].
  /// [ctx] the parse tree
  void enterSet_covergroup_expression(Set_covergroup_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.set_covergroup_expression].
  /// [ctx] the parse tree
  void exitSet_covergroup_expression(Set_covergroup_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.integer_covergroup_expression].
  /// [ctx] the parse tree
  void enterInteger_covergroup_expression(Integer_covergroup_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.integer_covergroup_expression].
  /// [ctx] the parse tree
  void exitInteger_covergroup_expression(Integer_covergroup_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cross_set_expression].
  /// [ctx] the parse tree
  void enterCross_set_expression(Cross_set_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cross_set_expression].
  /// [ctx] the parse tree
  void exitCross_set_expression(Cross_set_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.covergroup_expression].
  /// [ctx] the parse tree
  void enterCovergroup_expression(Covergroup_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.covergroup_expression].
  /// [ctx] the parse tree
  void exitCovergroup_expression(Covergroup_expressionContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_parameter_assignments].
  /// [ctx] the parse tree
  void enterList_of_parameter_assignments(List_of_parameter_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_parameter_assignments].
  /// [ctx] the parse tree
  void exitList_of_parameter_assignments(List_of_parameter_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ordered_parameter_assignment].
  /// [ctx] the parse tree
  void enterOrdered_parameter_assignment(Ordered_parameter_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ordered_parameter_assignment].
  /// [ctx] the parse tree
  void exitOrdered_parameter_assignment(Ordered_parameter_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.named_parameter_assignment].
  /// [ctx] the parse tree
  void enterNamed_parameter_assignment(Named_parameter_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.named_parameter_assignment].
  /// [ctx] the parse tree
  void exitNamed_parameter_assignment(Named_parameter_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_instance].
  /// [ctx] the parse tree
  void enterHierarchical_instance(Hierarchical_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_instance].
  /// [ctx] the parse tree
  void exitHierarchical_instance(Hierarchical_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.name_of_instance].
  /// [ctx] the parse tree
  void enterName_of_instance(Name_of_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.name_of_instance].
  /// [ctx] the parse tree
  void exitName_of_instance(Name_of_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_port_connections].
  /// [ctx] the parse tree
  void enterList_of_port_connections(List_of_port_connectionsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_port_connections].
  /// [ctx] the parse tree
  void exitList_of_port_connections(List_of_port_connectionsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ordered_port_connection].
  /// [ctx] the parse tree
  void enterOrdered_port_connection(Ordered_port_connectionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ordered_port_connection].
  /// [ctx] the parse tree
  void exitOrdered_port_connection(Ordered_port_connectionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.named_port_connection].
  /// [ctx] the parse tree
  void enterNamed_port_connection(Named_port_connectionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.named_port_connection].
  /// [ctx] the parse tree
  void exitNamed_port_connection(Named_port_connectionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_instantiation].
  /// [ctx] the parse tree
  void enterInterface_instantiation(Interface_instantiationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_instantiation].
  /// [ctx] the parse tree
  void exitInterface_instantiation(Interface_instantiationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_instantiation].
  /// [ctx] the parse tree
  void enterProgram_instantiation(Program_instantiationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_instantiation].
  /// [ctx] the parse tree
  void exitProgram_instantiation(Program_instantiationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_instantiation].
  /// [ctx] the parse tree
  void enterChecker_instantiation(Checker_instantiationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_instantiation].
  /// [ctx] the parse tree
  void exitChecker_instantiation(Checker_instantiationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_checker_port_connections].
  /// [ctx] the parse tree
  void enterList_of_checker_port_connections(List_of_checker_port_connectionsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_checker_port_connections].
  /// [ctx] the parse tree
  void exitList_of_checker_port_connections(List_of_checker_port_connectionsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ordered_checker_port_connection].
  /// [ctx] the parse tree
  void enterOrdered_checker_port_connection(Ordered_checker_port_connectionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ordered_checker_port_connection].
  /// [ctx] the parse tree
  void exitOrdered_checker_port_connection(Ordered_checker_port_connectionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.named_checker_port_connection].
  /// [ctx] the parse tree
  void enterNamed_checker_port_connection(Named_checker_port_connectionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.named_checker_port_connection].
  /// [ctx] the parse tree
  void exitNamed_checker_port_connection(Named_checker_port_connectionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.generate_region].
  /// [ctx] the parse tree
  void enterGenerate_region(Generate_regionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.generate_region].
  /// [ctx] the parse tree
  void exitGenerate_region(Generate_regionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.loop_generate_construct].
  /// [ctx] the parse tree
  void enterLoop_generate_construct(Loop_generate_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.loop_generate_construct].
  /// [ctx] the parse tree
  void exitLoop_generate_construct(Loop_generate_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.genvar_initialization].
  /// [ctx] the parse tree
  void enterGenvar_initialization(Genvar_initializationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.genvar_initialization].
  /// [ctx] the parse tree
  void exitGenvar_initialization(Genvar_initializationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.genvar_iteration].
  /// [ctx] the parse tree
  void enterGenvar_iteration(Genvar_iterationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.genvar_iteration].
  /// [ctx] the parse tree
  void exitGenvar_iteration(Genvar_iterationContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.generate_item].
  /// [ctx] the parse tree
  void enterGenerate_item(Generate_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.generate_item].
  /// [ctx] the parse tree
  void exitGenerate_item(Generate_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.continuous_assign].
  /// [ctx] the parse tree
  void enterContinuous_assign(Continuous_assignContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.continuous_assign].
  /// [ctx] the parse tree
  void exitContinuous_assign(Continuous_assignContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_net_assignments].
  /// [ctx] the parse tree
  void enterList_of_net_assignments(List_of_net_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_net_assignments].
  /// [ctx] the parse tree
  void exitList_of_net_assignments(List_of_net_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_variable_assignments].
  /// [ctx] the parse tree
  void enterList_of_variable_assignments(List_of_variable_assignmentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_variable_assignments].
  /// [ctx] the parse tree
  void exitList_of_variable_assignments(List_of_variable_assignmentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_alias].
  /// [ctx] the parse tree
  void enterNet_alias(Net_aliasContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_alias].
  /// [ctx] the parse tree
  void exitNet_alias(Net_aliasContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_assignment].
  /// [ctx] the parse tree
  void enterNet_assignment(Net_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_assignment].
  /// [ctx] the parse tree
  void exitNet_assignment(Net_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.initial_construct].
  /// [ctx] the parse tree
  void enterInitial_construct(Initial_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.initial_construct].
  /// [ctx] the parse tree
  void exitInitial_construct(Initial_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.always_construct].
  /// [ctx] the parse tree
  void enterAlways_construct(Always_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.always_construct].
  /// [ctx] the parse tree
  void exitAlways_construct(Always_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.always_keyword].
  /// [ctx] the parse tree
  void enterAlways_keyword(Always_keywordContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.always_keyword].
  /// [ctx] the parse tree
  void exitAlways_keyword(Always_keywordContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.final_construct].
  /// [ctx] the parse tree
  void enterFinal_construct(Final_constructContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.final_construct].
  /// [ctx] the parse tree
  void exitFinal_construct(Final_constructContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.blocking_assignment].
  /// [ctx] the parse tree
  void enterBlocking_assignment(Blocking_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.blocking_assignment].
  /// [ctx] the parse tree
  void exitBlocking_assignment(Blocking_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.operator_assignment].
  /// [ctx] the parse tree
  void enterOperator_assignment(Operator_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.operator_assignment].
  /// [ctx] the parse tree
  void exitOperator_assignment(Operator_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_operator].
  /// [ctx] the parse tree
  void enterAssignment_operator(Assignment_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_operator].
  /// [ctx] the parse tree
  void exitAssignment_operator(Assignment_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.nonblocking_assignment].
  /// [ctx] the parse tree
  void enterNonblocking_assignment(Nonblocking_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.nonblocking_assignment].
  /// [ctx] the parse tree
  void exitNonblocking_assignment(Nonblocking_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_continuous_assignment].
  /// [ctx] the parse tree
  void enterProcedural_continuous_assignment(Procedural_continuous_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_continuous_assignment].
  /// [ctx] the parse tree
  void exitProcedural_continuous_assignment(Procedural_continuous_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_assignment].
  /// [ctx] the parse tree
  void enterVariable_assignment(Variable_assignmentContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_assignment].
  /// [ctx] the parse tree
  void exitVariable_assignment(Variable_assignmentContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.action_block].
  /// [ctx] the parse tree
  void enterAction_block(Action_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.action_block].
  /// [ctx] the parse tree
  void exitAction_block(Action_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.seq_block].
  /// [ctx] the parse tree
  void enterSeq_block(Seq_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.seq_block].
  /// [ctx] the parse tree
  void exitSeq_block(Seq_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.par_block].
  /// [ctx] the parse tree
  void enterPar_block(Par_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.par_block].
  /// [ctx] the parse tree
  void exitPar_block(Par_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.join_keyword].
  /// [ctx] the parse tree
  void enterJoin_keyword(Join_keywordContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.join_keyword].
  /// [ctx] the parse tree
  void exitJoin_keyword(Join_keywordContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.statement_or_null].
  /// [ctx] the parse tree
  void enterStatement_or_null(Statement_or_nullContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.statement_or_null].
  /// [ctx] the parse tree
  void exitStatement_or_null(Statement_or_nullContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.statement].
  /// [ctx] the parse tree
  void enterStatement(StatementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.statement].
  /// [ctx] the parse tree
  void exitStatement(StatementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.statement_item].
  /// [ctx] the parse tree
  void enterStatement_item(Statement_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.statement_item].
  /// [ctx] the parse tree
  void exitStatement_item(Statement_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_statement].
  /// [ctx] the parse tree
  void enterFunction_statement(Function_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_statement].
  /// [ctx] the parse tree
  void exitFunction_statement(Function_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_statement_or_null].
  /// [ctx] the parse tree
  void enterFunction_statement_or_null(Function_statement_or_nullContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_statement_or_null].
  /// [ctx] the parse tree
  void exitFunction_statement_or_null(Function_statement_or_nullContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_identifier_list].
  /// [ctx] the parse tree
  void enterVariable_identifier_list(Variable_identifier_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_identifier_list].
  /// [ctx] the parse tree
  void exitVariable_identifier_list(Variable_identifier_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_timing_control_statement].
  /// [ctx] the parse tree
  void enterProcedural_timing_control_statement(Procedural_timing_control_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_timing_control_statement].
  /// [ctx] the parse tree
  void exitProcedural_timing_control_statement(Procedural_timing_control_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay_or_event_control].
  /// [ctx] the parse tree
  void enterDelay_or_event_control(Delay_or_event_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay_or_event_control].
  /// [ctx] the parse tree
  void exitDelay_or_event_control(Delay_or_event_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.delay_control].
  /// [ctx] the parse tree
  void enterDelay_control(Delay_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.delay_control].
  /// [ctx] the parse tree
  void exitDelay_control(Delay_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.event_control].
  /// [ctx] the parse tree
  void enterEvent_control(Event_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.event_control].
  /// [ctx] the parse tree
  void exitEvent_control(Event_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.event_expression].
  /// [ctx] the parse tree
  void enterEvent_expression(Event_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.event_expression].
  /// [ctx] the parse tree
  void exitEvent_expression(Event_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_timing_control].
  /// [ctx] the parse tree
  void enterProcedural_timing_control(Procedural_timing_controlContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_timing_control].
  /// [ctx] the parse tree
  void exitProcedural_timing_control(Procedural_timing_controlContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.jump_statement].
  /// [ctx] the parse tree
  void enterJump_statement(Jump_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.jump_statement].
  /// [ctx] the parse tree
  void exitJump_statement(Jump_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.wait_statement].
  /// [ctx] the parse tree
  void enterWait_statement(Wait_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.wait_statement].
  /// [ctx] the parse tree
  void exitWait_statement(Wait_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.event_trigger].
  /// [ctx] the parse tree
  void enterEvent_trigger(Event_triggerContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.event_trigger].
  /// [ctx] the parse tree
  void exitEvent_trigger(Event_triggerContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.disable_statement].
  /// [ctx] the parse tree
  void enterDisable_statement(Disable_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.disable_statement].
  /// [ctx] the parse tree
  void exitDisable_statement(Disable_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.conditional_statement].
  /// [ctx] the parse tree
  void enterConditional_statement(Conditional_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.conditional_statement].
  /// [ctx] the parse tree
  void exitConditional_statement(Conditional_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unique_priority].
  /// [ctx] the parse tree
  void enterUnique_priority(Unique_priorityContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unique_priority].
  /// [ctx] the parse tree
  void exitUnique_priority(Unique_priorityContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cond_predicate].
  /// [ctx] the parse tree
  void enterCond_predicate(Cond_predicateContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cond_predicate].
  /// [ctx] the parse tree
  void exitCond_predicate(Cond_predicateContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.expression_or_cond_pattern].
  /// [ctx] the parse tree
  void enterExpression_or_cond_pattern(Expression_or_cond_patternContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.expression_or_cond_pattern].
  /// [ctx] the parse tree
  void exitExpression_or_cond_pattern(Expression_or_cond_patternContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_statement].
  /// [ctx] the parse tree
  void enterCase_statement(Case_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_statement].
  /// [ctx] the parse tree
  void exitCase_statement(Case_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_keyword].
  /// [ctx] the parse tree
  void enterCase_keyword(Case_keywordContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_keyword].
  /// [ctx] the parse tree
  void exitCase_keyword(Case_keywordContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_expression].
  /// [ctx] the parse tree
  void enterCase_expression(Case_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_expression].
  /// [ctx] the parse tree
  void exitCase_expression(Case_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_item].
  /// [ctx] the parse tree
  void enterCase_item(Case_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_item].
  /// [ctx] the parse tree
  void exitCase_item(Case_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_pattern_item].
  /// [ctx] the parse tree
  void enterCase_pattern_item(Case_pattern_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_pattern_item].
  /// [ctx] the parse tree
  void exitCase_pattern_item(Case_pattern_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_inside_item].
  /// [ctx] the parse tree
  void enterCase_inside_item(Case_inside_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_inside_item].
  /// [ctx] the parse tree
  void exitCase_inside_item(Case_inside_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.case_item_expression].
  /// [ctx] the parse tree
  void enterCase_item_expression(Case_item_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.case_item_expression].
  /// [ctx] the parse tree
  void exitCase_item_expression(Case_item_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.randcase_statement].
  /// [ctx] the parse tree
  void enterRandcase_statement(Randcase_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.randcase_statement].
  /// [ctx] the parse tree
  void exitRandcase_statement(Randcase_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.randcase_item].
  /// [ctx] the parse tree
  void enterRandcase_item(Randcase_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.randcase_item].
  /// [ctx] the parse tree
  void exitRandcase_item(Randcase_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.open_range_list].
  /// [ctx] the parse tree
  void enterOpen_range_list(Open_range_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.open_range_list].
  /// [ctx] the parse tree
  void exitOpen_range_list(Open_range_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.open_value_range].
  /// [ctx] the parse tree
  void enterOpen_value_range(Open_value_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.open_value_range].
  /// [ctx] the parse tree
  void exitOpen_value_range(Open_value_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.pattern].
  /// [ctx] the parse tree
  void enterPattern(PatternContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.pattern].
  /// [ctx] the parse tree
  void exitPattern(PatternContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_pattern].
  /// [ctx] the parse tree
  void enterAssignment_pattern(Assignment_patternContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_pattern].
  /// [ctx] the parse tree
  void exitAssignment_pattern(Assignment_patternContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.structure_pattern_key].
  /// [ctx] the parse tree
  void enterStructure_pattern_key(Structure_pattern_keyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.structure_pattern_key].
  /// [ctx] the parse tree
  void exitStructure_pattern_key(Structure_pattern_keyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.array_pattern_key].
  /// [ctx] the parse tree
  void enterArray_pattern_key(Array_pattern_keyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.array_pattern_key].
  /// [ctx] the parse tree
  void exitArray_pattern_key(Array_pattern_keyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_pattern_key].
  /// [ctx] the parse tree
  void enterAssignment_pattern_key(Assignment_pattern_keyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_pattern_key].
  /// [ctx] the parse tree
  void exitAssignment_pattern_key(Assignment_pattern_keyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_pattern_expression].
  /// [ctx] the parse tree
  void enterAssignment_pattern_expression(Assignment_pattern_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_pattern_expression].
  /// [ctx] the parse tree
  void exitAssignment_pattern_expression(Assignment_pattern_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_pattern_expression_type].
  /// [ctx] the parse tree
  void enterAssignment_pattern_expression_type(Assignment_pattern_expression_typeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_pattern_expression_type].
  /// [ctx] the parse tree
  void exitAssignment_pattern_expression_type(Assignment_pattern_expression_typeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_assignment_pattern_expression].
  /// [ctx] the parse tree
  void enterConstant_assignment_pattern_expression(Constant_assignment_pattern_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_assignment_pattern_expression].
  /// [ctx] the parse tree
  void exitConstant_assignment_pattern_expression(Constant_assignment_pattern_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_pattern_net_lvalue].
  /// [ctx] the parse tree
  void enterAssignment_pattern_net_lvalue(Assignment_pattern_net_lvalueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_pattern_net_lvalue].
  /// [ctx] the parse tree
  void exitAssignment_pattern_net_lvalue(Assignment_pattern_net_lvalueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assignment_pattern_variable_lvalue].
  /// [ctx] the parse tree
  void enterAssignment_pattern_variable_lvalue(Assignment_pattern_variable_lvalueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assignment_pattern_variable_lvalue].
  /// [ctx] the parse tree
  void exitAssignment_pattern_variable_lvalue(Assignment_pattern_variable_lvalueContext ctx);

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

  /// Enter a parse tree produced by [SystemVerilogParser.subroutine_call_statement].
  /// [ctx] the parse tree
  void enterSubroutine_call_statement(Subroutine_call_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.subroutine_call_statement].
  /// [ctx] the parse tree
  void exitSubroutine_call_statement(Subroutine_call_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.assertion_item].
  /// [ctx] the parse tree
  void enterAssertion_item(Assertion_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.assertion_item].
  /// [ctx] the parse tree
  void exitAssertion_item(Assertion_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.deferred_immediate_assertion_item].
  /// [ctx] the parse tree
  void enterDeferred_immediate_assertion_item(Deferred_immediate_assertion_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.deferred_immediate_assertion_item].
  /// [ctx] the parse tree
  void exitDeferred_immediate_assertion_item(Deferred_immediate_assertion_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.procedural_assertion_statement].
  /// [ctx] the parse tree
  void enterProcedural_assertion_statement(Procedural_assertion_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.procedural_assertion_statement].
  /// [ctx] the parse tree
  void exitProcedural_assertion_statement(Procedural_assertion_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.immediate_assertion_statement].
  /// [ctx] the parse tree
  void enterImmediate_assertion_statement(Immediate_assertion_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.immediate_assertion_statement].
  /// [ctx] the parse tree
  void exitImmediate_assertion_statement(Immediate_assertion_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.simple_immediate_assertion_statement].
  /// [ctx] the parse tree
  void enterSimple_immediate_assertion_statement(Simple_immediate_assertion_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.simple_immediate_assertion_statement].
  /// [ctx] the parse tree
  void exitSimple_immediate_assertion_statement(Simple_immediate_assertion_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.simple_immediate_assert_statement].
  /// [ctx] the parse tree
  void enterSimple_immediate_assert_statement(Simple_immediate_assert_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.simple_immediate_assert_statement].
  /// [ctx] the parse tree
  void exitSimple_immediate_assert_statement(Simple_immediate_assert_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.simple_immediate_assume_statement].
  /// [ctx] the parse tree
  void enterSimple_immediate_assume_statement(Simple_immediate_assume_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.simple_immediate_assume_statement].
  /// [ctx] the parse tree
  void exitSimple_immediate_assume_statement(Simple_immediate_assume_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.simple_immediate_cover_statement].
  /// [ctx] the parse tree
  void enterSimple_immediate_cover_statement(Simple_immediate_cover_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.simple_immediate_cover_statement].
  /// [ctx] the parse tree
  void exitSimple_immediate_cover_statement(Simple_immediate_cover_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.deferred_immediate_assertion_statement].
  /// [ctx] the parse tree
  void enterDeferred_immediate_assertion_statement(Deferred_immediate_assertion_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.deferred_immediate_assertion_statement].
  /// [ctx] the parse tree
  void exitDeferred_immediate_assertion_statement(Deferred_immediate_assertion_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.deferred_immediate_assert_statement].
  /// [ctx] the parse tree
  void enterDeferred_immediate_assert_statement(Deferred_immediate_assert_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.deferred_immediate_assert_statement].
  /// [ctx] the parse tree
  void exitDeferred_immediate_assert_statement(Deferred_immediate_assert_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.deferred_immediate_assume_statement].
  /// [ctx] the parse tree
  void enterDeferred_immediate_assume_statement(Deferred_immediate_assume_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.deferred_immediate_assume_statement].
  /// [ctx] the parse tree
  void exitDeferred_immediate_assume_statement(Deferred_immediate_assume_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.deferred_immediate_cover_statement].
  /// [ctx] the parse tree
  void enterDeferred_immediate_cover_statement(Deferred_immediate_cover_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.deferred_immediate_cover_statement].
  /// [ctx] the parse tree
  void exitDeferred_immediate_cover_statement(Deferred_immediate_cover_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_declaration].
  /// [ctx] the parse tree
  void enterClocking_declaration(Clocking_declarationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_declaration].
  /// [ctx] the parse tree
  void exitClocking_declaration(Clocking_declarationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_event].
  /// [ctx] the parse tree
  void enterClocking_event(Clocking_eventContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_event].
  /// [ctx] the parse tree
  void exitClocking_event(Clocking_eventContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_item].
  /// [ctx] the parse tree
  void enterClocking_item(Clocking_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_item].
  /// [ctx] the parse tree
  void exitClocking_item(Clocking_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.default_skew].
  /// [ctx] the parse tree
  void enterDefault_skew(Default_skewContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.default_skew].
  /// [ctx] the parse tree
  void exitDefault_skew(Default_skewContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_direction].
  /// [ctx] the parse tree
  void enterClocking_direction(Clocking_directionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_direction].
  /// [ctx] the parse tree
  void exitClocking_direction(Clocking_directionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_clocking_decl_assign].
  /// [ctx] the parse tree
  void enterList_of_clocking_decl_assign(List_of_clocking_decl_assignContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_clocking_decl_assign].
  /// [ctx] the parse tree
  void exitList_of_clocking_decl_assign(List_of_clocking_decl_assignContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_decl_assign].
  /// [ctx] the parse tree
  void enterClocking_decl_assign(Clocking_decl_assignContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_decl_assign].
  /// [ctx] the parse tree
  void exitClocking_decl_assign(Clocking_decl_assignContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_skew].
  /// [ctx] the parse tree
  void enterClocking_skew(Clocking_skewContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_skew].
  /// [ctx] the parse tree
  void exitClocking_skew(Clocking_skewContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_drive].
  /// [ctx] the parse tree
  void enterClocking_drive(Clocking_driveContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_drive].
  /// [ctx] the parse tree
  void exitClocking_drive(Clocking_driveContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cycle_delay].
  /// [ctx] the parse tree
  void enterCycle_delay(Cycle_delayContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cycle_delay].
  /// [ctx] the parse tree
  void exitCycle_delay(Cycle_delayContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clockvar].
  /// [ctx] the parse tree
  void enterClockvar(ClockvarContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clockvar].
  /// [ctx] the parse tree
  void exitClockvar(ClockvarContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clockvar_expression].
  /// [ctx] the parse tree
  void enterClockvar_expression(Clockvar_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clockvar_expression].
  /// [ctx] the parse tree
  void exitClockvar_expression(Clockvar_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.randsequence_statement].
  /// [ctx] the parse tree
  void enterRandsequence_statement(Randsequence_statementContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.randsequence_statement].
  /// [ctx] the parse tree
  void exitRandsequence_statement(Randsequence_statementContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.production].
  /// [ctx] the parse tree
  void enterProduction(ProductionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.production].
  /// [ctx] the parse tree
  void exitProduction(ProductionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_rule].
  /// [ctx] the parse tree
  void enterRs_rule(Rs_ruleContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_rule].
  /// [ctx] the parse tree
  void exitRs_rule(Rs_ruleContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_production_list].
  /// [ctx] the parse tree
  void enterRs_production_list(Rs_production_listContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_production_list].
  /// [ctx] the parse tree
  void exitRs_production_list(Rs_production_listContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.weight_specification].
  /// [ctx] the parse tree
  void enterWeight_specification(Weight_specificationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.weight_specification].
  /// [ctx] the parse tree
  void exitWeight_specification(Weight_specificationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_code_block].
  /// [ctx] the parse tree
  void enterRs_code_block(Rs_code_blockContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_code_block].
  /// [ctx] the parse tree
  void exitRs_code_block(Rs_code_blockContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_prod].
  /// [ctx] the parse tree
  void enterRs_prod(Rs_prodContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_prod].
  /// [ctx] the parse tree
  void exitRs_prod(Rs_prodContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.production_item].
  /// [ctx] the parse tree
  void enterProduction_item(Production_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.production_item].
  /// [ctx] the parse tree
  void exitProduction_item(Production_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_if_else].
  /// [ctx] the parse tree
  void enterRs_if_else(Rs_if_elseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_if_else].
  /// [ctx] the parse tree
  void exitRs_if_else(Rs_if_elseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_repeat].
  /// [ctx] the parse tree
  void enterRs_repeat(Rs_repeatContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_repeat].
  /// [ctx] the parse tree
  void exitRs_repeat(Rs_repeatContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_case].
  /// [ctx] the parse tree
  void enterRs_case(Rs_caseContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_case].
  /// [ctx] the parse tree
  void exitRs_case(Rs_caseContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.rs_case_item].
  /// [ctx] the parse tree
  void enterRs_case_item(Rs_case_itemContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.rs_case_item].
  /// [ctx] the parse tree
  void exitRs_case_item(Rs_case_itemContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.z_or_x].
  /// [ctx] the parse tree
  void enterZ_or_x(Z_or_xContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.z_or_x].
  /// [ctx] the parse tree
  void exitZ_or_x(Z_or_xContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.edge_identifier].
  /// [ctx] the parse tree
  void enterEdge_identifier(Edge_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.edge_identifier].
  /// [ctx] the parse tree
  void exitEdge_identifier(Edge_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.concatenation].
  /// [ctx] the parse tree
  void enterConcatenation(ConcatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.concatenation].
  /// [ctx] the parse tree
  void exitConcatenation(ConcatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_concatenation].
  /// [ctx] the parse tree
  void enterConstant_concatenation(Constant_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_concatenation].
  /// [ctx] the parse tree
  void exitConstant_concatenation(Constant_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_multiple_concatenation].
  /// [ctx] the parse tree
  void enterConstant_multiple_concatenation(Constant_multiple_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_multiple_concatenation].
  /// [ctx] the parse tree
  void exitConstant_multiple_concatenation(Constant_multiple_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_path_concatenation].
  /// [ctx] the parse tree
  void enterModule_path_concatenation(Module_path_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_path_concatenation].
  /// [ctx] the parse tree
  void exitModule_path_concatenation(Module_path_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_path_multiple_concatenation].
  /// [ctx] the parse tree
  void enterModule_path_multiple_concatenation(Module_path_multiple_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_path_multiple_concatenation].
  /// [ctx] the parse tree
  void exitModule_path_multiple_concatenation(Module_path_multiple_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.multiple_concatenation].
  /// [ctx] the parse tree
  void enterMultiple_concatenation(Multiple_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.multiple_concatenation].
  /// [ctx] the parse tree
  void exitMultiple_concatenation(Multiple_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.streaming_concatenation].
  /// [ctx] the parse tree
  void enterStreaming_concatenation(Streaming_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.streaming_concatenation].
  /// [ctx] the parse tree
  void exitStreaming_concatenation(Streaming_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.stream_operator].
  /// [ctx] the parse tree
  void enterStream_operator(Stream_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.stream_operator].
  /// [ctx] the parse tree
  void exitStream_operator(Stream_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.slice_size].
  /// [ctx] the parse tree
  void enterSlice_size(Slice_sizeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.slice_size].
  /// [ctx] the parse tree
  void exitSlice_size(Slice_sizeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.stream_concatenation].
  /// [ctx] the parse tree
  void enterStream_concatenation(Stream_concatenationContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.stream_concatenation].
  /// [ctx] the parse tree
  void exitStream_concatenation(Stream_concatenationContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.stream_expression].
  /// [ctx] the parse tree
  void enterStream_expression(Stream_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.stream_expression].
  /// [ctx] the parse tree
  void exitStream_expression(Stream_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.array_range_expression].
  /// [ctx] the parse tree
  void enterArray_range_expression(Array_range_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.array_range_expression].
  /// [ctx] the parse tree
  void exitArray_range_expression(Array_range_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.empty_queue].
  /// [ctx] the parse tree
  void enterEmpty_queue(Empty_queueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.empty_queue].
  /// [ctx] the parse tree
  void exitEmpty_queue(Empty_queueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_function_call].
  /// [ctx] the parse tree
  void enterConstant_function_call(Constant_function_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_function_call].
  /// [ctx] the parse tree
  void exitConstant_function_call(Constant_function_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_call].
  /// [ctx] the parse tree
  void enterTf_call(Tf_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_call].
  /// [ctx] the parse tree
  void exitTf_call(Tf_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.system_tf_call].
  /// [ctx] the parse tree
  void enterSystem_tf_call(System_tf_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.system_tf_call].
  /// [ctx] the parse tree
  void exitSystem_tf_call(System_tf_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.subroutine_call].
  /// [ctx] the parse tree
  void enterSubroutine_call(Subroutine_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.subroutine_call].
  /// [ctx] the parse tree
  void exitSubroutine_call(Subroutine_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_subroutine_call].
  /// [ctx] the parse tree
  void enterFunction_subroutine_call(Function_subroutine_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_subroutine_call].
  /// [ctx] the parse tree
  void exitFunction_subroutine_call(Function_subroutine_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.list_of_arguments].
  /// [ctx] the parse tree
  void enterList_of_arguments(List_of_argumentsContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.list_of_arguments].
  /// [ctx] the parse tree
  void exitList_of_arguments(List_of_argumentsContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.method_call].
  /// [ctx] the parse tree
  void enterMethod_call(Method_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.method_call].
  /// [ctx] the parse tree
  void exitMethod_call(Method_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.method_call_body].
  /// [ctx] the parse tree
  void enterMethod_call_body(Method_call_bodyContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.method_call_body].
  /// [ctx] the parse tree
  void exitMethod_call_body(Method_call_bodyContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.built_in_method_call].
  /// [ctx] the parse tree
  void enterBuilt_in_method_call(Built_in_method_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.built_in_method_call].
  /// [ctx] the parse tree
  void exitBuilt_in_method_call(Built_in_method_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.array_manipulation_call].
  /// [ctx] the parse tree
  void enterArray_manipulation_call(Array_manipulation_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.array_manipulation_call].
  /// [ctx] the parse tree
  void exitArray_manipulation_call(Array_manipulation_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.randomize_call].
  /// [ctx] the parse tree
  void enterRandomize_call(Randomize_callContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.randomize_call].
  /// [ctx] the parse tree
  void exitRandomize_call(Randomize_callContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.method_call_root].
  /// [ctx] the parse tree
  void enterMethod_call_root(Method_call_rootContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.method_call_root].
  /// [ctx] the parse tree
  void exitMethod_call_root(Method_call_rootContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.array_method_name].
  /// [ctx] the parse tree
  void enterArray_method_name(Array_method_nameContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.array_method_name].
  /// [ctx] the parse tree
  void exitArray_method_name(Array_method_nameContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inc_or_dec_expression].
  /// [ctx] the parse tree
  void enterInc_or_dec_expression(Inc_or_dec_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inc_or_dec_expression].
  /// [ctx] the parse tree
  void exitInc_or_dec_expression(Inc_or_dec_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inc_or_dec_operator].
  /// [ctx] the parse tree
  void enterInc_or_dec_operator(Inc_or_dec_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inc_or_dec_operator].
  /// [ctx] the parse tree
  void exitInc_or_dec_operator(Inc_or_dec_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.conditional_expression].
  /// [ctx] the parse tree
  void enterConditional_expression(Conditional_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.conditional_expression].
  /// [ctx] the parse tree
  void exitConditional_expression(Conditional_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_expression].
  /// [ctx] the parse tree
  void enterConstant_expression(Constant_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_expression].
  /// [ctx] the parse tree
  void exitConstant_expression(Constant_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_mintypmax_expression].
  /// [ctx] the parse tree
  void enterConstant_mintypmax_expression(Constant_mintypmax_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_mintypmax_expression].
  /// [ctx] the parse tree
  void exitConstant_mintypmax_expression(Constant_mintypmax_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_param_expression].
  /// [ctx] the parse tree
  void enterConstant_param_expression(Constant_param_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_param_expression].
  /// [ctx] the parse tree
  void exitConstant_param_expression(Constant_param_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.param_expression].
  /// [ctx] the parse tree
  void enterParam_expression(Param_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.param_expression].
  /// [ctx] the parse tree
  void exitParam_expression(Param_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_range_expression].
  /// [ctx] the parse tree
  void enterConstant_range_expression(Constant_range_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_range_expression].
  /// [ctx] the parse tree
  void exitConstant_range_expression(Constant_range_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_part_select_range].
  /// [ctx] the parse tree
  void enterConstant_part_select_range(Constant_part_select_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_part_select_range].
  /// [ctx] the parse tree
  void exitConstant_part_select_range(Constant_part_select_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_range].
  /// [ctx] the parse tree
  void enterConstant_range(Constant_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_range].
  /// [ctx] the parse tree
  void exitConstant_range(Constant_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_indexed_range].
  /// [ctx] the parse tree
  void enterConstant_indexed_range(Constant_indexed_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_indexed_range].
  /// [ctx] the parse tree
  void exitConstant_indexed_range(Constant_indexed_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.expression].
  /// [ctx] the parse tree
  void enterExpression(ExpressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.expression].
  /// [ctx] the parse tree
  void exitExpression(ExpressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tagged_union_expression].
  /// [ctx] the parse tree
  void enterTagged_union_expression(Tagged_union_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tagged_union_expression].
  /// [ctx] the parse tree
  void exitTagged_union_expression(Tagged_union_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inside_expression].
  /// [ctx] the parse tree
  void enterInside_expression(Inside_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inside_expression].
  /// [ctx] the parse tree
  void exitInside_expression(Inside_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.value_range].
  /// [ctx] the parse tree
  void enterValue_range(Value_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.value_range].
  /// [ctx] the parse tree
  void exitValue_range(Value_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.mintypmax_expression].
  /// [ctx] the parse tree
  void enterMintypmax_expression(Mintypmax_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.mintypmax_expression].
  /// [ctx] the parse tree
  void exitMintypmax_expression(Mintypmax_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_path_expression].
  /// [ctx] the parse tree
  void enterModule_path_expression(Module_path_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_path_expression].
  /// [ctx] the parse tree
  void exitModule_path_expression(Module_path_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_path_mintypmax_expression].
  /// [ctx] the parse tree
  void enterModule_path_mintypmax_expression(Module_path_mintypmax_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_path_mintypmax_expression].
  /// [ctx] the parse tree
  void exitModule_path_mintypmax_expression(Module_path_mintypmax_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.part_select_range].
  /// [ctx] the parse tree
  void enterPart_select_range(Part_select_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.part_select_range].
  /// [ctx] the parse tree
  void exitPart_select_range(Part_select_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.indexed_range].
  /// [ctx] the parse tree
  void enterIndexed_range(Indexed_rangeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.indexed_range].
  /// [ctx] the parse tree
  void exitIndexed_range(Indexed_rangeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.genvar_expression].
  /// [ctx] the parse tree
  void enterGenvar_expression(Genvar_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.genvar_expression].
  /// [ctx] the parse tree
  void exitGenvar_expression(Genvar_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_primary].
  /// [ctx] the parse tree
  void enterConstant_primary(Constant_primaryContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_primary].
  /// [ctx] the parse tree
  void exitConstant_primary(Constant_primaryContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_path_primary].
  /// [ctx] the parse tree
  void enterModule_path_primary(Module_path_primaryContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_path_primary].
  /// [ctx] the parse tree
  void exitModule_path_primary(Module_path_primaryContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.primary].
  /// [ctx] the parse tree
  void enterPrimary(PrimaryContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.primary].
  /// [ctx] the parse tree
  void exitPrimary(PrimaryContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_qualifier].
  /// [ctx] the parse tree
  void enterClass_qualifier(Class_qualifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_qualifier].
  /// [ctx] the parse tree
  void exitClass_qualifier(Class_qualifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.range_expression].
  /// [ctx] the parse tree
  void enterRange_expression(Range_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.range_expression].
  /// [ctx] the parse tree
  void exitRange_expression(Range_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.primary_literal].
  /// [ctx] the parse tree
  void enterPrimary_literal(Primary_literalContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.primary_literal].
  /// [ctx] the parse tree
  void exitPrimary_literal(Primary_literalContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.time_literal].
  /// [ctx] the parse tree
  void enterTime_literal(Time_literalContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.time_literal].
  /// [ctx] the parse tree
  void exitTime_literal(Time_literalContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.time_unit].
  /// [ctx] the parse tree
  void enterTime_unit(Time_unitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.time_unit].
  /// [ctx] the parse tree
  void exitTime_unit(Time_unitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.implicit_class_handle].
  /// [ctx] the parse tree
  void enterImplicit_class_handle(Implicit_class_handleContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.implicit_class_handle].
  /// [ctx] the parse tree
  void exitImplicit_class_handle(Implicit_class_handleContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bit_select].
  /// [ctx] the parse tree
  void enterBit_select(Bit_selectContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bit_select].
  /// [ctx] the parse tree
  void exitBit_select(Bit_selectContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.select].
  /// [ctx] the parse tree
  void enterSelect(SelectContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.select].
  /// [ctx] the parse tree
  void exitSelect(SelectContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.nonrange_select].
  /// [ctx] the parse tree
  void enterNonrange_select(Nonrange_selectContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.nonrange_select].
  /// [ctx] the parse tree
  void exitNonrange_select(Nonrange_selectContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_bit_select].
  /// [ctx] the parse tree
  void enterConstant_bit_select(Constant_bit_selectContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_bit_select].
  /// [ctx] the parse tree
  void exitConstant_bit_select(Constant_bit_selectContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_select].
  /// [ctx] the parse tree
  void enterConstant_select(Constant_selectContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_select].
  /// [ctx] the parse tree
  void exitConstant_select(Constant_selectContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_cast].
  /// [ctx] the parse tree
  void enterConstant_cast(Constant_castContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_cast].
  /// [ctx] the parse tree
  void exitConstant_cast(Constant_castContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constant_let_expression].
  /// [ctx] the parse tree
  void enterConstant_let_expression(Constant_let_expressionContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constant_let_expression].
  /// [ctx] the parse tree
  void exitConstant_let_expression(Constant_let_expressionContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cast].
  /// [ctx] the parse tree
  void enterCast(CastContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cast].
  /// [ctx] the parse tree
  void exitCast(CastContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_lvalue].
  /// [ctx] the parse tree
  void enterNet_lvalue(Net_lvalueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_lvalue].
  /// [ctx] the parse tree
  void exitNet_lvalue(Net_lvalueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_lvalue].
  /// [ctx] the parse tree
  void enterVariable_lvalue(Variable_lvalueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_lvalue].
  /// [ctx] the parse tree
  void exitVariable_lvalue(Variable_lvalueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.nonrange_variable_lvalue].
  /// [ctx] the parse tree
  void enterNonrange_variable_lvalue(Nonrange_variable_lvalueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.nonrange_variable_lvalue].
  /// [ctx] the parse tree
  void exitNonrange_variable_lvalue(Nonrange_variable_lvalueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unary_operator].
  /// [ctx] the parse tree
  void enterUnary_operator(Unary_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unary_operator].
  /// [ctx] the parse tree
  void exitUnary_operator(Unary_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.binary_operator].
  /// [ctx] the parse tree
  void enterBinary_operator(Binary_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.binary_operator].
  /// [ctx] the parse tree
  void exitBinary_operator(Binary_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unary_module_path_operator].
  /// [ctx] the parse tree
  void enterUnary_module_path_operator(Unary_module_path_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unary_module_path_operator].
  /// [ctx] the parse tree
  void exitUnary_module_path_operator(Unary_module_path_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.binary_module_path_operator].
  /// [ctx] the parse tree
  void enterBinary_module_path_operator(Binary_module_path_operatorContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.binary_module_path_operator].
  /// [ctx] the parse tree
  void exitBinary_module_path_operator(Binary_module_path_operatorContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.number].
  /// [ctx] the parse tree
  void enterNumber(NumberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.number].
  /// [ctx] the parse tree
  void exitNumber(NumberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.integral_number].
  /// [ctx] the parse tree
  void enterIntegral_number(Integral_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.integral_number].
  /// [ctx] the parse tree
  void exitIntegral_number(Integral_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.decimal_number].
  /// [ctx] the parse tree
  void enterDecimal_number(Decimal_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.decimal_number].
  /// [ctx] the parse tree
  void exitDecimal_number(Decimal_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.binary_number].
  /// [ctx] the parse tree
  void enterBinary_number(Binary_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.binary_number].
  /// [ctx] the parse tree
  void exitBinary_number(Binary_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.octal_number].
  /// [ctx] the parse tree
  void enterOctal_number(Octal_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.octal_number].
  /// [ctx] the parse tree
  void exitOctal_number(Octal_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hex_number].
  /// [ctx] the parse tree
  void enterHex_number(Hex_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hex_number].
  /// [ctx] the parse tree
  void exitHex_number(Hex_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sign].
  /// [ctx] the parse tree
  void enterSign(SignContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sign].
  /// [ctx] the parse tree
  void exitSign(SignContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.size].
  /// [ctx] the parse tree
  void enterSize(SizeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.size].
  /// [ctx] the parse tree
  void exitSize(SizeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_zero_unsigned_number].
  /// [ctx] the parse tree
  void enterNon_zero_unsigned_number(Non_zero_unsigned_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_zero_unsigned_number].
  /// [ctx] the parse tree
  void exitNon_zero_unsigned_number(Non_zero_unsigned_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.real_number].
  /// [ctx] the parse tree
  void enterReal_number(Real_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.real_number].
  /// [ctx] the parse tree
  void exitReal_number(Real_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.fixed_point_number].
  /// [ctx] the parse tree
  void enterFixed_point_number(Fixed_point_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.fixed_point_number].
  /// [ctx] the parse tree
  void exitFixed_point_number(Fixed_point_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.exp].
  /// [ctx] the parse tree
  void enterExp(ExpContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.exp].
  /// [ctx] the parse tree
  void exitExp(ExpContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unsigned_number].
  /// [ctx] the parse tree
  void enterUnsigned_number(Unsigned_numberContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unsigned_number].
  /// [ctx] the parse tree
  void exitUnsigned_number(Unsigned_numberContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.binary_value].
  /// [ctx] the parse tree
  void enterBinary_value(Binary_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.binary_value].
  /// [ctx] the parse tree
  void exitBinary_value(Binary_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.octal_value].
  /// [ctx] the parse tree
  void enterOctal_value(Octal_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.octal_value].
  /// [ctx] the parse tree
  void exitOctal_value(Octal_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hex_value].
  /// [ctx] the parse tree
  void enterHex_value(Hex_valueContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hex_value].
  /// [ctx] the parse tree
  void exitHex_value(Hex_valueContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.non_zero_decimal_digit].
  /// [ctx] the parse tree
  void enterNon_zero_decimal_digit(Non_zero_decimal_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.non_zero_decimal_digit].
  /// [ctx] the parse tree
  void exitNon_zero_decimal_digit(Non_zero_decimal_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.decimal_digit].
  /// [ctx] the parse tree
  void enterDecimal_digit(Decimal_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.decimal_digit].
  /// [ctx] the parse tree
  void exitDecimal_digit(Decimal_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.binary_digit].
  /// [ctx] the parse tree
  void enterBinary_digit(Binary_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.binary_digit].
  /// [ctx] the parse tree
  void exitBinary_digit(Binary_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.octal_digit].
  /// [ctx] the parse tree
  void enterOctal_digit(Octal_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.octal_digit].
  /// [ctx] the parse tree
  void exitOctal_digit(Octal_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hex_digit].
  /// [ctx] the parse tree
  void enterHex_digit(Hex_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hex_digit].
  /// [ctx] the parse tree
  void exitHex_digit(Hex_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.x_digit].
  /// [ctx] the parse tree
  void enterX_digit(X_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.x_digit].
  /// [ctx] the parse tree
  void exitX_digit(X_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.z_digit].
  /// [ctx] the parse tree
  void enterZ_digit(Z_digitContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.z_digit].
  /// [ctx] the parse tree
  void exitZ_digit(Z_digitContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.unbased_unsized_literal].
  /// [ctx] the parse tree
  void enterUnbased_unsized_literal(Unbased_unsized_literalContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.unbased_unsized_literal].
  /// [ctx] the parse tree
  void exitUnbased_unsized_literal(Unbased_unsized_literalContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.attribute_instance].
  /// [ctx] the parse tree
  void enterAttribute_instance(Attribute_instanceContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.attribute_instance].
  /// [ctx] the parse tree
  void exitAttribute_instance(Attribute_instanceContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.attr_spec].
  /// [ctx] the parse tree
  void enterAttr_spec(Attr_specContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.attr_spec].
  /// [ctx] the parse tree
  void exitAttr_spec(Attr_specContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.attr_name].
  /// [ctx] the parse tree
  void enterAttr_name(Attr_nameContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.attr_name].
  /// [ctx] the parse tree
  void exitAttr_name(Attr_nameContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.array_identifier].
  /// [ctx] the parse tree
  void enterArray_identifier(Array_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.array_identifier].
  /// [ctx] the parse tree
  void exitArray_identifier(Array_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.bin_identifier].
  /// [ctx] the parse tree
  void enterBin_identifier(Bin_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.bin_identifier].
  /// [ctx] the parse tree
  void exitBin_identifier(Bin_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.block_identifier].
  /// [ctx] the parse tree
  void enterBlock_identifier(Block_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.block_identifier].
  /// [ctx] the parse tree
  void exitBlock_identifier(Block_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cell_identifier].
  /// [ctx] the parse tree
  void enterCell_identifier(Cell_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cell_identifier].
  /// [ctx] the parse tree
  void exitCell_identifier(Cell_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.checker_identifier].
  /// [ctx] the parse tree
  void enterChecker_identifier(Checker_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.checker_identifier].
  /// [ctx] the parse tree
  void exitChecker_identifier(Checker_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_identifier].
  /// [ctx] the parse tree
  void enterClass_identifier(Class_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_identifier].
  /// [ctx] the parse tree
  void exitClass_identifier(Class_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.clocking_identifier].
  /// [ctx] the parse tree
  void enterClocking_identifier(Clocking_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.clocking_identifier].
  /// [ctx] the parse tree
  void exitClocking_identifier(Clocking_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.config_identifier].
  /// [ctx] the parse tree
  void enterConfig_identifier(Config_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.config_identifier].
  /// [ctx] the parse tree
  void exitConfig_identifier(Config_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.const_identifier].
  /// [ctx] the parse tree
  void enterConst_identifier(Const_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.const_identifier].
  /// [ctx] the parse tree
  void exitConst_identifier(Const_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.constraint_identifier].
  /// [ctx] the parse tree
  void enterConstraint_identifier(Constraint_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.constraint_identifier].
  /// [ctx] the parse tree
  void exitConstraint_identifier(Constraint_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cover_point_identifier].
  /// [ctx] the parse tree
  void enterCover_point_identifier(Cover_point_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cover_point_identifier].
  /// [ctx] the parse tree
  void exitCover_point_identifier(Cover_point_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.covergroup_identifier].
  /// [ctx] the parse tree
  void enterCovergroup_identifier(Covergroup_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.covergroup_identifier].
  /// [ctx] the parse tree
  void exitCovergroup_identifier(Covergroup_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.cross_identifier].
  /// [ctx] the parse tree
  void enterCross_identifier(Cross_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.cross_identifier].
  /// [ctx] the parse tree
  void exitCross_identifier(Cross_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.enum_identifier].
  /// [ctx] the parse tree
  void enterEnum_identifier(Enum_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.enum_identifier].
  /// [ctx] the parse tree
  void exitEnum_identifier(Enum_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.formal_identifier].
  /// [ctx] the parse tree
  void enterFormal_identifier(Formal_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.formal_identifier].
  /// [ctx] the parse tree
  void exitFormal_identifier(Formal_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.formal_port_identifier].
  /// [ctx] the parse tree
  void enterFormal_port_identifier(Formal_port_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.formal_port_identifier].
  /// [ctx] the parse tree
  void exitFormal_port_identifier(Formal_port_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.function_identifier].
  /// [ctx] the parse tree
  void enterFunction_identifier(Function_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.function_identifier].
  /// [ctx] the parse tree
  void exitFunction_identifier(Function_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.generate_block_identifier].
  /// [ctx] the parse tree
  void enterGenerate_block_identifier(Generate_block_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.generate_block_identifier].
  /// [ctx] the parse tree
  void exitGenerate_block_identifier(Generate_block_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.genvar_identifier].
  /// [ctx] the parse tree
  void enterGenvar_identifier(Genvar_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.genvar_identifier].
  /// [ctx] the parse tree
  void exitGenvar_identifier(Genvar_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.index_variable_identifier].
  /// [ctx] the parse tree
  void enterIndex_variable_identifier(Index_variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.index_variable_identifier].
  /// [ctx] the parse tree
  void exitIndex_variable_identifier(Index_variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.inout_port_identifier].
  /// [ctx] the parse tree
  void enterInout_port_identifier(Inout_port_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.inout_port_identifier].
  /// [ctx] the parse tree
  void exitInout_port_identifier(Inout_port_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.input_port_identifier].
  /// [ctx] the parse tree
  void enterInput_port_identifier(Input_port_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.input_port_identifier].
  /// [ctx] the parse tree
  void exitInput_port_identifier(Input_port_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.instance_identifier].
  /// [ctx] the parse tree
  void enterInstance_identifier(Instance_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.instance_identifier].
  /// [ctx] the parse tree
  void exitInstance_identifier(Instance_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_identifier].
  /// [ctx] the parse tree
  void enterInterface_identifier(Interface_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_identifier].
  /// [ctx] the parse tree
  void exitInterface_identifier(Interface_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.interface_instance_identifier].
  /// [ctx] the parse tree
  void enterInterface_instance_identifier(Interface_instance_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.interface_instance_identifier].
  /// [ctx] the parse tree
  void exitInterface_instance_identifier(Interface_instance_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.library_identifier].
  /// [ctx] the parse tree
  void enterLibrary_identifier(Library_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.library_identifier].
  /// [ctx] the parse tree
  void exitLibrary_identifier(Library_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.member_identifier].
  /// [ctx] the parse tree
  void enterMember_identifier(Member_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.member_identifier].
  /// [ctx] the parse tree
  void exitMember_identifier(Member_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.method_identifier].
  /// [ctx] the parse tree
  void enterMethod_identifier(Method_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.method_identifier].
  /// [ctx] the parse tree
  void exitMethod_identifier(Method_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.modport_identifier].
  /// [ctx] the parse tree
  void enterModport_identifier(Modport_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.modport_identifier].
  /// [ctx] the parse tree
  void exitModport_identifier(Modport_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.module_identifier].
  /// [ctx] the parse tree
  void enterModule_identifier(Module_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.module_identifier].
  /// [ctx] the parse tree
  void exitModule_identifier(Module_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_identifier].
  /// [ctx] the parse tree
  void enterNet_identifier(Net_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_identifier].
  /// [ctx] the parse tree
  void exitNet_identifier(Net_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.net_type_identifier].
  /// [ctx] the parse tree
  void enterNet_type_identifier(Net_type_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.net_type_identifier].
  /// [ctx] the parse tree
  void exitNet_type_identifier(Net_type_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.output_port_identifier].
  /// [ctx] the parse tree
  void enterOutput_port_identifier(Output_port_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.output_port_identifier].
  /// [ctx] the parse tree
  void exitOutput_port_identifier(Output_port_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_identifier].
  /// [ctx] the parse tree
  void enterPackage_identifier(Package_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_identifier].
  /// [ctx] the parse tree
  void exitPackage_identifier(Package_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.parameter_identifier].
  /// [ctx] the parse tree
  void enterParameter_identifier(Parameter_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.parameter_identifier].
  /// [ctx] the parse tree
  void exitParameter_identifier(Parameter_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.port_identifier].
  /// [ctx] the parse tree
  void enterPort_identifier(Port_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.port_identifier].
  /// [ctx] the parse tree
  void exitPort_identifier(Port_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.production_identifier].
  /// [ctx] the parse tree
  void enterProduction_identifier(Production_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.production_identifier].
  /// [ctx] the parse tree
  void exitProduction_identifier(Production_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.program_identifier].
  /// [ctx] the parse tree
  void enterProgram_identifier(Program_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.program_identifier].
  /// [ctx] the parse tree
  void exitProgram_identifier(Program_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.property_identifier].
  /// [ctx] the parse tree
  void enterProperty_identifier(Property_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.property_identifier].
  /// [ctx] the parse tree
  void exitProperty_identifier(Property_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.sequence_identifier].
  /// [ctx] the parse tree
  void enterSequence_identifier(Sequence_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.sequence_identifier].
  /// [ctx] the parse tree
  void exitSequence_identifier(Sequence_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.signal_identifier].
  /// [ctx] the parse tree
  void enterSignal_identifier(Signal_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.signal_identifier].
  /// [ctx] the parse tree
  void exitSignal_identifier(Signal_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.specparam_identifier].
  /// [ctx] the parse tree
  void enterSpecparam_identifier(Specparam_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.specparam_identifier].
  /// [ctx] the parse tree
  void exitSpecparam_identifier(Specparam_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.task_identifier].
  /// [ctx] the parse tree
  void enterTask_identifier(Task_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.task_identifier].
  /// [ctx] the parse tree
  void exitTask_identifier(Task_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.terminal_identifier].
  /// [ctx] the parse tree
  void enterTerminal_identifier(Terminal_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.terminal_identifier].
  /// [ctx] the parse tree
  void exitTerminal_identifier(Terminal_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.tf_identifier].
  /// [ctx] the parse tree
  void enterTf_identifier(Tf_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.tf_identifier].
  /// [ctx] the parse tree
  void exitTf_identifier(Tf_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.topmodule_identifier].
  /// [ctx] the parse tree
  void enterTopmodule_identifier(Topmodule_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.topmodule_identifier].
  /// [ctx] the parse tree
  void exitTopmodule_identifier(Topmodule_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.type_identifier].
  /// [ctx] the parse tree
  void enterType_identifier(Type_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.type_identifier].
  /// [ctx] the parse tree
  void exitType_identifier(Type_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.udp_identifier].
  /// [ctx] the parse tree
  void enterUdp_identifier(Udp_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.udp_identifier].
  /// [ctx] the parse tree
  void exitUdp_identifier(Udp_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.variable_identifier].
  /// [ctx] the parse tree
  void enterVariable_identifier(Variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.variable_identifier].
  /// [ctx] the parse tree
  void exitVariable_identifier(Variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.class_variable_identifier].
  /// [ctx] the parse tree
  void enterClass_variable_identifier(Class_variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.class_variable_identifier].
  /// [ctx] the parse tree
  void exitClass_variable_identifier(Class_variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.covergroup_variable_identifier].
  /// [ctx] the parse tree
  void enterCovergroup_variable_identifier(Covergroup_variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.covergroup_variable_identifier].
  /// [ctx] the parse tree
  void exitCovergroup_variable_identifier(Covergroup_variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.dynamic_array_variable_identifier].
  /// [ctx] the parse tree
  void enterDynamic_array_variable_identifier(Dynamic_array_variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.dynamic_array_variable_identifier].
  /// [ctx] the parse tree
  void exitDynamic_array_variable_identifier(Dynamic_array_variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_array_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_array_identifier(Hierarchical_array_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_array_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_array_identifier(Hierarchical_array_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_block_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_block_identifier(Hierarchical_block_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_block_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_block_identifier(Hierarchical_block_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_event_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_event_identifier(Hierarchical_event_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_event_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_event_identifier(Hierarchical_event_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_net_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_net_identifier(Hierarchical_net_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_net_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_net_identifier(Hierarchical_net_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_parameter_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_parameter_identifier(Hierarchical_parameter_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_parameter_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_parameter_identifier(Hierarchical_parameter_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_property_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_property_identifier(Hierarchical_property_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_property_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_property_identifier(Hierarchical_property_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_sequence_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_sequence_identifier(Hierarchical_sequence_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_sequence_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_sequence_identifier(Hierarchical_sequence_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_task_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_task_identifier(Hierarchical_task_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_task_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_task_identifier(Hierarchical_task_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_tf_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_tf_identifier(Hierarchical_tf_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_tf_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_tf_identifier(Hierarchical_tf_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_variable_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_variable_identifier(Hierarchical_variable_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_variable_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_variable_identifier(Hierarchical_variable_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.hierarchical_identifier].
  /// [ctx] the parse tree
  void enterHierarchical_identifier(Hierarchical_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.hierarchical_identifier].
  /// [ctx] the parse tree
  void exitHierarchical_identifier(Hierarchical_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.identifier].
  /// [ctx] the parse tree
  void enterIdentifier(IdentifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.identifier].
  /// [ctx] the parse tree
  void exitIdentifier(IdentifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.package_scope].
  /// [ctx] the parse tree
  void enterPackage_scope(Package_scopeContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.package_scope].
  /// [ctx] the parse tree
  void exitPackage_scope(Package_scopeContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_checker_identifier].
  /// [ctx] the parse tree
  void enterPs_checker_identifier(Ps_checker_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_checker_identifier].
  /// [ctx] the parse tree
  void exitPs_checker_identifier(Ps_checker_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_class_identifier].
  /// [ctx] the parse tree
  void enterPs_class_identifier(Ps_class_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_class_identifier].
  /// [ctx] the parse tree
  void exitPs_class_identifier(Ps_class_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_covergroup_identifier].
  /// [ctx] the parse tree
  void enterPs_covergroup_identifier(Ps_covergroup_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_covergroup_identifier].
  /// [ctx] the parse tree
  void exitPs_covergroup_identifier(Ps_covergroup_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_identifier].
  /// [ctx] the parse tree
  void enterPs_identifier(Ps_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_identifier].
  /// [ctx] the parse tree
  void exitPs_identifier(Ps_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_array_identifier].
  /// [ctx] the parse tree
  void enterPs_or_hierarchical_array_identifier(Ps_or_hierarchical_array_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_array_identifier].
  /// [ctx] the parse tree
  void exitPs_or_hierarchical_array_identifier(Ps_or_hierarchical_array_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_net_identifier].
  /// [ctx] the parse tree
  void enterPs_or_hierarchical_net_identifier(Ps_or_hierarchical_net_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_net_identifier].
  /// [ctx] the parse tree
  void exitPs_or_hierarchical_net_identifier(Ps_or_hierarchical_net_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_property_identifier].
  /// [ctx] the parse tree
  void enterPs_or_hierarchical_property_identifier(Ps_or_hierarchical_property_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_property_identifier].
  /// [ctx] the parse tree
  void exitPs_or_hierarchical_property_identifier(Ps_or_hierarchical_property_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_sequence_identifier].
  /// [ctx] the parse tree
  void enterPs_or_hierarchical_sequence_identifier(Ps_or_hierarchical_sequence_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_sequence_identifier].
  /// [ctx] the parse tree
  void exitPs_or_hierarchical_sequence_identifier(Ps_or_hierarchical_sequence_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_tf_identifier].
  /// [ctx] the parse tree
  void enterPs_or_hierarchical_tf_identifier(Ps_or_hierarchical_tf_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_or_hierarchical_tf_identifier].
  /// [ctx] the parse tree
  void exitPs_or_hierarchical_tf_identifier(Ps_or_hierarchical_tf_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_parameter_identifier].
  /// [ctx] the parse tree
  void enterPs_parameter_identifier(Ps_parameter_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_parameter_identifier].
  /// [ctx] the parse tree
  void exitPs_parameter_identifier(Ps_parameter_identifierContext ctx);

  /// Enter a parse tree produced by [SystemVerilogParser.ps_type_identifier].
  /// [ctx] the parse tree
  void enterPs_type_identifier(Ps_type_identifierContext ctx);
  /// Exit a parse tree produced by [SystemVerilogParser.ps_type_identifier].
  /// [ctx] the parse tree
  void exitPs_type_identifier(Ps_type_identifierContext ctx);
}