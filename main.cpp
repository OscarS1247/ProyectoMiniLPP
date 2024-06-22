#include <iostream>
#include <fstream>
#include "MiniLppLexer.hpp"
#include "MiniLppParser.hpp"

void printToken(Token token, const ParserValueType& lval) {
    switch (token) {
        case Token::Identifier:
            //std::cout << "Identifier: " << std::get<std::string>(lval) << std::endl;
            std::cout << "Identifier" << std::endl;
            break;
        case Token::Number:
            std::cout << "Number" << std::endl;    
            //std::cout << "Number: " << std::get<int>(lval) << std::endl;
            break;
        case Token::CharConst:
            std::cout << "CharConst" << std::endl;
            //std::cout << "CharConst: " << std::get<char>(lval) << std::endl;
            break;
        case Token::StringConst:
            std::cout << "StringConst" << std::endl;
            //std::cout << "StringConst: " << std::get<std::string>(lval) << std::endl;
            break;
        case Token::IntegerType:
            std::cout << "Keyword: int" << std::endl;
            break;
        case Token::RealType:
            std::cout << "Keyword: real" << std::endl;
            break;
        case Token::StringType:
            std::cout << "Keyword: string" << std::endl;
            break;
        case Token::CharType:
            std::cout << "Keyword: char" << std::endl;
            break;
        case Token::BoolType:
            std::cout << "Keyword: boolean" << std::endl;
            break;
        case Token::ArrayType:
            std::cout << "Keyword: array" << std::endl;
            break;
        case Token::Of:
            std::cout << "Keyword: of" << std::endl;
            break;
        case Token::Function:
            std::cout << "Keyword: function" << std::endl;
            break;
        case Token::Procedure:
            std::cout << "Keyword: procedure" << std::endl;
            break;
        case Token::Variable:
            std::cout << "Keyword: var" << std::endl;
            break;
        case Token::Begin:
            std::cout << "Keyword: begin" << std::endl;
            break;
        case Token::End:
            std::cout << "Keyword: end" << std::endl;
            break;
        case Token::Final:
            std::cout << "Keyword: final" << std::endl;
            break;
        case Token::If:
            std::cout << "Keyword: if" << std::endl;
            break;
        case Token::Then:
            std::cout << "Keyword: then" << std::endl;
            break;
        case Token::Else:
            std::cout << "Keyword: else" << std::endl;
            break;
        case Token::For:
            std::cout << "Keyword: for" << std::endl;
            break;
        case Token::While:
            std::cout << "Keyword: while" << std::endl;
            break;
        case Token::Do:
            std::cout << "Keyword: do" << std::endl;
            break;
        case Token::Repeat:
            std::cout << "Keyword: repeat" << std::endl;
            break;
        case Token::Until:
            std::cout << "Keyword: until" << std::endl;
            break;
        case Token::Call:
            std::cout << "Keyword: call" << std::endl;
            break;
        case Token::Read:
            std::cout << "Keyword: read" << std::endl;
            break;
        case Token::Write:
            std::cout << "Keyword: write" << std::endl;
            break;
        case Token::Return:
            std::cout << "Keyword: return" << std::endl;
            break;
        case Token::True:
            std::cout << "Keyword: true" << std::endl;
            break;
        case Token::False:
            std::cout << "Keyword: false" << std::endl;
            break;
        case Token::Plus:
            std::cout << "Operator: +" << std::endl;
            break;
        case Token::Minus:
            std::cout << "Operator: -" << std::endl;
            break;
        case Token::Multiply:
            std::cout << "Operator: *" << std::endl;
            break;
        case Token::Divide:
            std::cout << "Operator: /" << std::endl;
            break;
        case Token::Modulus:
            std::cout << "Operator: mod" << std::endl;
            break;
        case Token::Assignment:
            std::cout << "Operator: <-" << std::endl;
            break;
        case Token::EqualTo:
            std::cout << "Operator: ==" << std::endl;
            break;
        case Token::NotEqualTo:
            std::cout << "Operator: <>" << std::endl;
            break;
        case Token::LessThan:
            std::cout << "Operator: <" << std::endl;
            break;
        case Token::LessThanOrEqual:
            std::cout << "Operator: <=" << std::endl;
            break;
        case Token::GreaterThan:
            std::cout << "Operator: >" << std::endl;
            break;
        case Token::GreaterThanOrEqual:
            std::cout << "Operator: >=" << std::endl;
            break;
        case Token::And:
            std::cout << "Operator: and" << std::endl;
            break;
        case Token::Or:
            std::cout << "Operator: or" << std::endl;
            break;
        case Token::OpenParen:
            std::cout << "Punctuation: (" << std::endl;
            break;
        case Token::CloseParen:
            std::cout << "Punctuation: )" << std::endl;
            break;
        case Token::OpenBracket:
            std::cout << "Punctuation: [" << std::endl;
            break;
        case Token::CloseBracket:
            std::cout << "Punctuation: ]" << std::endl;
            break;
        case Token::Comma:
            std::cout << "Punctuation: ," << std::endl;
            break;
        case Token::Colon:
            std::cout << "Punctuation: :" << std::endl;
            break;
        case Token::Semicolon:
            std::cout << "Punctuation: ;" << std::endl;
            break;
        default:
            std::cout << "Unknown token: " << static_cast<int>(token) << std::endl;
            break;
    }
}

void analyzeLexical(std::istream& source_file) {
    MiniLppLexer lexer(source_file);
    ParserValueType lval;

    std::cout << "Lexical Analysis:" << std::endl;
    while (true) {
        Token token = lexer.nextToken(&lval);
        if (token == Token::Eof) break;
        printToken(token, lval);
    }
    std::cout << "End of Lexical Analysis" << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <source-file>" << " <output-file>" << std::endl;
        return 1;
    }

    const char* filename = argv[1];
    const char* output_filename = argv[2];
    std::ifstream source_file(filename, std::ios::in);

    if (!source_file) {
        std::cerr << "Error: Could not open file " << filename << std::endl;
        return 1;
    }

    // Perform lexical analysis
    analyzeLexical(source_file);

    // Reset the file stream for parsing
    source_file.clear();
    source_file.seekg(0, std::ios::beg);

    try {
        MiniLppLexer lexer(source_file);
        MiniLppParser parser(lexer, output_filename);

        int result = parser.parse();

        if (result == 0) {
            std::cout << "Parsing completed successfully." << std::endl;
        } else {
            std::cout << "Parsing failed with errors." << std::endl;
        }
    } catch (const std::runtime_error& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}