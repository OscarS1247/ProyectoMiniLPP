#ifndef __MiniLpp_PARSER_HPP__
#define __MiniLpp_PARSER_HPP__

#include "MiniLppParserImpl.hpp"
#include "MiniLppLexer.hpp"
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

class MiniLppParser
{
public:
    MiniLppParser(MiniLppLexer& lexer, const string& filename)
      : lexer(lexer) ,  filename(filename)
    {}

    int parse();

    void setValue(double _value)
    { value = _value; }

    double getValue() const
    { return value; }

    void createCodeFile(const string& code);

    MiniLppLexer& getLexer()
    { return lexer; }

private:
    std::vector<AstNode *> statements;
    double value;
    MiniLppLexer& lexer;
    const string filename;  
};

#endif