#ifndef __MiniLpp_PARSER_HPP__
#define __MiniLpp_PARSER_HPP__

#include "MiniLppParserImpl.hpp"
#include "MiniLppLexer.hpp"

class MiniLppParser
{
public:
    MiniLppParser(MiniLppLexer& lexer)
      : lexer(lexer)
    {}

    int parse();

    void setValue(double _value)
    { value = _value; }

    double getValue() const
    { return value; }

    MiniLppLexer& getLexer()
    { return lexer; }

private:
    double value;
    MiniLppLexer& lexer;
};

#endif