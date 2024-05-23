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

class MiniLppParser;

using ParserValueType = std::variant<std::string, int, char, double>;

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



%%

programa: Begin block End
      | defblock Begin block End
      | defblock funcprocblocck Begin block End
      | funcprocblocck Begin block End
;

block: block line
      | line
;

line: write
      | assignblock
      | estructuras
      | calls
      | return
;

return: Return expr
;

write: Write StringConst
      | Write expr
;

tipoVar: IntegerType
      | CharType
      | BoolType
;

idArreglo: Identifier OpenBracket expr CloseBracket
;

programcall: Identifier OpenParen CloseParen
      | Identifier OpenParen entradaParam CloseParen
;

id: Identifier
      | idArreglo
      | programcall
;

valorBool: True
      | False
;

booloperator: Equals
      | EqualTo
      | NotEqualTo
      | LessThan
      | LessThanOrEqual
      | GreaterThan
      | GreaterThanOrEqual
;

defSimple: defSimple Comma Identifier
      | tipoVar Identifier
;

def: defSimple
      | ArrayType OpenBracket expr CloseBracket Of tipoVar Identifier
;

defblock: defblock def
      | def
;

assignment: Identifier Assignment expr 
      | Identifier Assignment valorBool
      | Identifier Assignment CharType
;

assignarray: idArreglo Assignment expr
      | idArreglo Assignment CharType
      | idArreglo Assignment valorBool
;

assignblock: assignment
      | assignarray
;

expr: expr Plus term 
      | expr Minus term 
      | term 
;
term: term Multiply factor 
      | term Divide factor 
      | term Modulus factor 
      | factor 
;
factor: OpenParen expr CloseParen 
      | Number 
      | Hex 
      | Binary
      | id  
;

expresionBool: expresionBool Or termBool 
      | termBool 
;

termBool: termBool And factorBool 
      | factorBool 
;

factorBool: OpenParen expresionBool CloseParen 
      | operacionBool 
;

operacionBool: expr booloperator expr
;

tipoParam: Variable tipoVar Identifier
      | Variable ArrayType OpenBracket Number CloseBracket Of tipoVar Identifier
      | tipoVar Identifier
      | ArrayType OpenBracket Number CloseBracket Of tipoVar Identifier
;

listaParams: listaParams Comma tipoParam
      | tipoParam
;
entradaParam: entradaParam Comma expr
      | expr
;

procedure: Procedure Identifier OpenParen listaParams CloseParen defblock Begin block End
      | Procedure Identifier OpenParen listaParams CloseParen Begin block End
      | Procedure Identifier OpenParen CloseParen defblock Begin block End
      | Procedure Identifier OpenParen CloseParen Begin block End
      | Procedure Identifier defblock Begin block End
      | Procedure Identifier Begin block End
;

function: Function Identifier OpenParen listaParams CloseParen Colon tipoVar defblock Begin block End
      | Function Identifier OpenParen listaParams CloseParen Colon tipoVar Begin block End
      | Function Identifier OpenParen CloseParen Colon tipoVar defblock Begin block End
      | Function Identifier OpenParen CloseParen Colon tipoVar Begin block End
      | Function Identifier Colon tipoVar defblock Begin block End
      | Function Identifier Colon tipoVar Begin block End
;

funcprocblocck: funcprocblocck procedure
      | funcprocblocck function
      | procedure
      | function
;

calls: Call programcall
      | Call Identifier
;

repetir: Repeat block Until expresionBool
;

mientras: While expresionBool Until block End While
;

para: For assignment Until expr Until block End Until
;

si: If expresionBool Then block End If
      | If expresionBool Then block Else block End If
;

estructuras: repetir
      | mientras
      | para
      | si
;



