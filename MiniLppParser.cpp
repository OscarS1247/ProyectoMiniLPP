#include "MiniLppParser.hpp"

int MiniLppParser::parse()
{
    return yyparse(*this);
}

