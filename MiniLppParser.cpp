#include "MiniLppParser.hpp"
using namespace std;

int MiniLppParser::parse()
{
    return yyparse(*this);
}

void MiniLppParser::createCodeFile(const std::string& code)
{
    ofstream file;

    file.open(filename, ios::out);

    if(!file) 
        cerr << "Error in creating code file: " << filename << "!" << endl;
    else
        cout << "Code file created successfully" << endl;
    
    file << code;
    file.close();
}