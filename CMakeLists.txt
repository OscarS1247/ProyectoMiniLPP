cmake_minimum_required(VERSION 3.14)
project(MiniLPP)

find_package(FLEX)
find_package(BISON)

FLEX_TARGET(MiniLppLexer MiniLppLexerImpl.l
            ${CMAKE_CURRENT_BINARY_DIR}/MiniLppLexerImpl.cpp
            DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/MiniLppLexerImpl.h
            )

BISON_TARGET(MiniLppParser MiniLppParserImpl.y
            ${CMAKE_CURRENT_BINARY_DIR}/MiniLppParserImpl.cpp
            COMPILE_FLAGS -Wcounterexamples
            DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/MiniLppParserImpl.hpp
            )

ADD_FLEX_BISON_DEPENDENCY(MiniLppLexer MiniLppParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_SOURCE_DIR})

add_executable(${PROJECT_NAME}
    ${FLEX_MiniLppLexer_OUTPUTS}
    ${BISON_MiniLppParser_OUTPUTS}
    MiniLppLexer.hpp
    MiniLppLexer.cpp
    MiniLppParser.hpp
    MiniLppParser.cpp
    main.cpp
 )
