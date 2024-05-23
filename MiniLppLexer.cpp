#include <fstream>
#include "MiniLppLexer.hpp"
#include "MiniLppLexerImpl.h"

MiniLppLexer::MiniLppLexer(std::istream& _in)
  : in(_in)
{
    yylex_init_extra(&in, &yyscanner);
}

MiniLppLexer::~MiniLppLexer()
{
    yylex_destroy(yyscanner);
}

std::string MiniLppLexer::text() const
{
    return std::string(yyget_text(yyscanner));
}

const char *MiniLppLexer::tokenString(Token tk)
{
    return "Unknown";
}

const int MiniLppLexer::getLine() const
{
    return yyget_lineno(yyscanner);
}







