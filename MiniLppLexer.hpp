#ifndef __MiniLppLexer_HPP__
#define __MiniLppLexer_HPP__

#include <iosfwd>
#include <string>
#include "MiniLppParserImpl.hpp"


enum class Token: int {
    Eof = 0,
    Error = 256,
    Undef = 257,
    Plus = 258,
    Minus = 259,
    Multiply = 260,
    Divide = 261,
    Modulus = 262,
    OpenParen = 263,
    CloseParen = 264,
    Equals = 265,
    Semicolon = 266,
    EqualTo = 267,
    NotEqualTo = 268,
    LessThan = 269,
    LessThanOrEqual = 270,
    GreaterThan = 271,
    GreaterThanOrEqual = 272,
    Comma = 273,
    Assignment = 274,
    OpenBracket = 275,
    CloseBracket = 276,
    Colon = 277,
    And = 278,
    Or = 279,
    Number = 280,
    Hex = 281,
    Binary = 282,
    Identifier = 283,
    IntegerType = 284,
    RealType = 285,
    StringType = 286,
    CharType = 287,
    BoolType = 288,
    ArrayType = 289,
    Of = 290,
    Function = 291,
    Procedure = 292,
    Variable = 293,
    Begin = 294,
    End = 295,
    Final = 296,
    If = 297,
    Then = 298,
    Else = 299,
    For = 300,
    While = 301,
    Do = 302,
    Repeat = 303,
    Until = 304,
    Call = 305,
    Return = 306,
    StringConst = 307,
    CharConst = 308,
    True = 309,
    False = 310,
    Write = 311,
    Read = 312
};



class MiniLppLexer
{
public:
    using yyscan_t = void*;

public:
    MiniLppLexer(std::istream& _in);
    ~MiniLppLexer();

    Token nextToken(ParserValueType *lval)
    { return nextTokenHelper(yyscanner, lval); }

    std::string text() const;

    const int getLine() const;

    static const char *tokenString(Token tk);

private:
    Token nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval);

private:
    std::istream& in;
    yyscan_t yyscanner;
};

#endif

