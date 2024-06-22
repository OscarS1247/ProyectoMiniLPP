%option noyywrap
%option reentrant
%option yylineno
%option case-insensitive
%option extra-type = "std::istream *"

%{
#include <iostream>
#include <cstdlib>
#include "MiniLppLexer.hpp"

#define YY_DECL Token MiniLppLexer::nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval)
#define yyterminate() return Token::Eof

#define YY_INPUT(buf, result, max_size) \
    { \
        auto *in = yyget_extra(yyscanner); \
        in->read(buf, max_size); \
        result = in->gcount(); \
    }
%}

%x comment
%x str

%%
[ \t\n]     {  }
[\r\n]      {    }
"//"[^\n]*\n    { }
"/*"        { BEGIN(comment); }
\"          { BEGIN(str); }
\'[^\n]\'                  { return Token::CharConst; }
"entero"                   { *lval = new String(std::string(yytext)); return Token::IntegerType; }
"real"                     { return Token::RealType; }
"cadena"                   { return Token::StringType; }
"caracter"                  { *lval = new String(std::string(yytext)); return Token::CharType; }
"booleano"                  { *lval = new String(std::string(yytext)); return Token::BoolType; }
"arreglo"                    { return Token::ArrayType; }
"de"                       { return Token::Of; }
"funcion"                 { return Token::Function; }
"procedimiento"                { return Token::Procedure; }
"var"                      { return Token::Variable; }
"inicio"                    { return Token::Begin; }
"fin"                      { return Token::End; }
"final"                    { return Token::Final; }
"si"                       { return Token::If; }
"entonces"                     { return Token::Then; }
"sino"                     { return Token::Else; }
"sino si"                  { return Token::Elseif; }
"para"                      { return Token::For; }
"mientras"                    { return Token::While; }
"haga"                       { return Token::Do; }
"escriba"                    { return Token::Write; }
"leer"                     { return Token::Read; }
"verdadero"                     {*lval = new Boolean(1); return Token::True; }
"falso"                    { *lval = new Boolean(0); return Token::False; }
"repita"                   { return Token::Repeat; }
"hasta"                    { return Token::Until; }
"y"                      { return Token::And; }
"o"                       { return Token::Or; }
"llamar"                     { return Token::Call; }
":"                        { return Token::Colon; }
"retorne"                   { return Token::Return; }
"tipo"                     { return Token::Type; }
"es"                       { return Token::Is; }
"lea"                      { return Token::Lea; }
"+"                        { return Token::Plus; }
"-"                        { return Token::Minus; }
"*"                        { return Token::Multiply; }
"div"                      { return Token::Divide; }
"mod"                      { return Token::Modulus; }
"("                        { return Token::OpenParen; }
")"                        { return Token::CloseParen; }
"["                        { return Token::OpenBracket; }
"]"                        { return Token::CloseBracket; }
"="                        { return Token::Equals; }
"<-"                       { return Token::Assignment; }
"=="                       { return Token::EqualTo; }
"<>"                       { return Token::NotEqualTo; }
"<"                        { return Token::LessThan; }
"<="                       { return Token::LessThanOrEqual; }
">"                        { return Token::GreaterThan; }
">="                       { return Token::GreaterThanOrEqual; }
";"                        { return Token::Semicolon; }
","                        { return Token::Comma; }
"0x"([0-9a-fA-F])+         { return Token::Hex; }
"0b"[0-1]+                 { return Token::Binary; }
[0-9]+(\.[0-9]+)?	        { *lval = new Num(std::atof(yytext)); return Token::Number; }
[a-zA-Z_][a-zA-Z0-9_]*	    { *lval = new Id(std::string(yytext)); return Token::Identifier; }
.                          { std::cerr << "Invalid symbol: " << yytext[0] << '\n'; return Token::Error; }

<str>[^"]*                 { *lval = new String(yytext); }
<str>\"                    { BEGIN(INITIAL); return Token::StringConst; }


<comment>"*/" { BEGIN(INITIAL); }
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }

%%