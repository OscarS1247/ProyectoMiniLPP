%define parse.error verbose
%define api.pure full

%parse-param {MiniLppParser& parser}

%code top {
#include <iostream>
#include <stdexcept>
#include "MiniLppLexer.hpp"
#include "MiniLppParser.hpp"

#define yylex(v) static_cast<int>(parser.getLexer().nextToken(v))

void yyerror(const MiniLppParser& parser, const char *msg)
{
      std::cerr << "Error sintactico linea: " << (const_cast<MiniLppParser&>(parser)).getLexer().getLine() << std::endl;

      throw std::runtime_error(msg);
}
}

%code requires {
#include <string>
#include <variant>
#include <MiniLppAst.hpp>


class MiniLppParser;

using ParserValueType = AstNode *;

#define YYSTYPE ParserValueType
#define YYSTYPE_IS_DECLARED 1

}

%token Plus "+"
%token Minus "-"
%token Multiply "*"
%token Divide "div"
%token Modulus "mod"
%token OpenParen "("
%token CloseParen ")"
%token Equals "="
%token Semicolon ";"
%token EqualTo "=="
%token NotEqualTo "<>"
%token LessThan "<"
%token LessThanOrEqual "<="
%token GreaterThan ">"
%token GreaterThanOrEqual ">="
%token Comma ","
%token Assignment "<-"
%token OpenBracket "["
%token CloseBracket "]"
%token Colon ":"
%token And "y"
%token Or "o"
%token Number "numero"
%token Hex "Hexa"
%token Binary "Binary"
%token Identifier "identificador"
%token IntegerType "entero"
%token RealType "real"
%token StringType "cadena"
%token CharType "caracter"
%token BoolType "booleano"
%token ArrayType "arreglo"
%token Of "de"
%token Function "funcion"
%token Procedure "procedimiento"
%token Variable "var"
%token Begin "inicio"
%token End "fin"
%token Final "final"
%token If "si"
%token Then "entonces"
%token Else "sino"
%token For "para"
%token While "mientras"
%token Do "haga"
%token Repeat "repita"
%token Until "hasta"
%token Call "llamar"
%token Return "retorne"
%token StringConst "stringConstant"
%token CharConst "charConstant"
%token True "verdadero"
%token False "falso"
%token Write "escriba"
%token Read "leer"
%token Elseif "sino si"
%token Is "es"
%token Lea "lea"
%token Type "tipo"



%%

start: program { parser.createCodeFile($1->generateCode()); }

program: Begin block End {$$ = new Program((Definitions*)nullptr, (Definitions*)nullptr, (FunProcList*)nullptr, (Stmt*)$2);}
      | definitions Begin block End {$$ = new Program((Definitions*)$1, (Definitions*)nullptr, (FunProcList*)nullptr, (Stmt*)$3);}
      | typesDefs Begin block End {$$ = new Program((Definitions*)nullptr, (Definitions*)$1, (FunProcList*)nullptr, (Stmt*)$3);}
      | funcprocblock Begin block End {$$ = new Program((Definitions*)nullptr, (Definitions*)nullptr, (FunProcList*)$1, (Stmt*)$3);}
      | definitions typesDefs Begin block End {$$ = new Program((Definitions*)$1, (Definitions*)$2, (FunProcList*)nullptr, (Stmt*)$4);}
      | typesDefs definitions Begin block End {$$ = new Program((Definitions*)$2, (Definitions*)$1, (FunProcList*)nullptr, (Stmt*)$4);}
      | definitions funcprocblock Begin block End {$$ = new Program((Definitions*)$1, (Definitions*)nullptr, (FunProcList*)$2, (Stmt*)$4);}
      | typesDefs funcprocblock Begin block End {$$ = new Program((Definitions*)nullptr, (Definitions*)$1, (FunProcList*)$2, (Stmt*)$4);}
      | typesDefs definitions funcprocblock Begin block End {$$ = new Program((Definitions*)$2, (Definitions*)$1, (FunProcList*)$3, (Stmt*)$5);}
      | definitions typesDefs funcprocblock Begin block End {$$ = new Program((Definitions*)$1, (Definitions*)$2, (FunProcList*)$3, (Stmt*)$5);}
;

block: block line {$$ = new CodeStmt((AstNode*)$1, (AstNode*)$2);}
      | line {$$ = $1;}
;

line: write {$$ = $1;}
      | assignblock {$$ = $1;}
      | estructuras {$$ = $1;}
      | calls {$$ = $1;}
      | return {$$ = $1;}
;

return: Return expr
;

read: Lea id
;

write: write Comma StringConst
      | write Comma expr
      | Write StringConst {$$ = new WriteStatement((Expr*)$2);}
      | Write expr {$$ = new WriteStatement((Expr*)$2);}
;

tipoVar: IntegerType {$$ = $1;}
      | CharType {$$ = $1;}
      | BoolType {$$ = $1;}
      | Identifier {$$ = $1;}
;

idArreglo: Identifier OpenBracket expr CloseBracket
;

programcall: Identifier OpenParen CloseParen
      | Identifier OpenParen entradaParam CloseParen
;

id: Identifier {$$ = $1;}
      | idArreglo {$$ = $1;}
      | programcall {$$ = $1;}
;

valorBool: True
      | False
;

defSimple: defSimple Comma Identifier {$$ = new VariableList((VariableList*)$1, new VariableExpr((Id*)$3));}
      | Identifier {$$ = new VariableExpr((Id*)$1);}
;

def: tipoVar defSimple {$$ = new Def((String*)$1, (VariableList*)$2);}
      | ArrayType OpenBracket expr CloseBracket Of tipoVar Identifier
;

definitions: definitions def {$$ = new Definitions((Definitions*)$1, (Def*)$2);}
      | def {$$ = $1;} 
;

typesDefs: typesDefs types
      | types {$$ = $1;}
;

types: Type Identifier Is tipoVar
      | Type Identifier Is ArrayType OpenBracket expr CloseBracket Of tipoVar
;

assignment: Identifier Assignment expr {$$ = new AssignStatement((Id*)$1, (Expr*)$3);}
      | Identifier Assignment valorBool {$$ = new AssignStatement((Id*)$1, (Expr*)$3);}
      | Identifier Assignment CharType {$$ = new AssignStatement((Id*)$1, (Expr*)$3);}
;

assignarray: idArreglo Assignment expr
      | idArreglo Assignment CharType
      | idArreglo Assignment valorBool
;

assignblock: assignment {$$ = $1;}
      | assignarray {$$ = $1;}
;

expr: expr Plus term {$$ = new Add((Expr*)$1, (Expr*)$3);}
      | expr Minus term {$$ = new Sub((Expr*)$1, (Expr*)$3);}
      | term {$$ = $1;}
;

term: term Multiply factor {$$ = new Mul((Expr*)$1, (Expr*)$3);}
      | term Divide factor {$$ = new Div((Expr*)$1, (Expr*)$3);}
      | term Modulus factor {$$ = new Mod((Expr*)$1, (Expr*)$3);}
      | factor {$$ = $1;}
;

factor: OpenParen expr CloseParen 
      | Number {$$ = $1;}
      | Hex 
      | Binary
      | id {$$ = $1;}
;

expresionBool: expresionBool Or termBool 
      | termBool {$$ = $1;}
;

termBool: termBool And factorBool 
      | factorBool {$$ = $1;}
;

factorBool: OpenParen expresionBool CloseParen 
      | operacionBool {$$ = $1;}
;

operacionBool: expr EqualTo expr {$$ = new Equal((Expr*)$1, (Expr*)$3);}
      | expr NotEqualTo expr {$$ = new NonEqual((Expr*)$1, (Expr*)$3);}
      | expr LessThan expr {$$ = new LessThanTo((Expr*)$1, (Expr*)$3);}
      | expr LessThanOrEqual expr {$$ = new LessEqual((Expr*)$1, (Expr*)$3);}
      | expr GreaterThan expr {$$ = new GreaterThanTo((Expr*)$1, (Expr*)$3);}
      | expr GreaterThanOrEqual expr {$$ = new GreaterEqual((Expr*)$1, (Expr*)$3);}
;

tipoParam: Variable tipoVar Identifier 
      | Variable ArrayType OpenBracket Number CloseBracket Of tipoVar Identifier
      | tipoVar Identifier
      | ArrayType OpenBracket Number CloseBracket Of tipoVar Identifier
;

listaParams: listaParams Comma tipoParam
      | tipoParam {$$ = $1;}
;

entradaParam: entradaParam Comma expr
      | expr {$$ = $1;}
;

procedure: Procedure Identifier OpenParen listaParams CloseParen definitions Begin block End
      | Procedure Identifier OpenParen listaParams CloseParen Begin block End
      | Procedure Identifier OpenParen CloseParen definitions Begin block End
      | Procedure Identifier OpenParen CloseParen Begin block End
      | Procedure Identifier definitions Begin block End
      | Procedure Identifier Begin block End
;

function: Function Identifier OpenParen listaParams CloseParen Colon tipoVar definitions Begin block End
      | Function Identifier OpenParen listaParams CloseParen Colon tipoVar Begin block End
      | Function Identifier OpenParen CloseParen Colon tipoVar definitions Begin block End
      | Function Identifier OpenParen CloseParen Colon tipoVar Begin block End
      | Function Identifier Colon tipoVar definitions Begin block End
      | Function Identifier Colon tipoVar Begin block End
;

funcprocblock: funcprocblock procedure
      | funcprocblock function 
      | procedure {$$ = $1;}
      | function {$$ = $1;}
;

calls: Call programcall
      | Call Identifier
;

repeatstatement: Repeat block Until expresionBool {$$ = new RepeatStatement((Expr*)$4, (Stmt*)$2);}
;

whilestatement: While expresionBool Do block End While {$$ = new WhileStatement((Expr*)$2, (Stmt*)$4);}
;

forstatement: For assignment Until expr Do block End For {$$ = new ForStatement((AssignStatement*)$2,(Expr*)$4, (Stmt*)$6);}
;

ifstatement: If expresionBool Then block End If { $$ = new IfStatement((Expr*)$2, (Stmt*)$4, (Stmt*)nullptr); }
      | If expresionBool Then block elsestatement End If { $$ = new IfStatement((Expr*)$2, (Stmt*)$4, (Stmt*)$5); }
      | If expresionBool Then block elseifstatement End If { $$ = new IfStatement((Expr*)$2, (Stmt*)$4, (Stmt*)$5); }
;

elsestatement: Else block { $$ = $2; }
;

elseifstatement: Elseif expresionBool Then block { $$ = new ElseIfStatement((Expr*)$2, (Stmt*)$4);}
;

elseblock: elseblock elseifstatement { $$ = new ElseIfBlock((Stmt*)$1, (Stmt*)$2); }
      | elseifstatement { $$ = $1; }
;

estructuras: repeatstatement {$$ = $1;}
      | whilestatement {$$ = $1;}
      | forstatement {$$ = $1;}
      | ifstatement {$$ = $1;}
;



