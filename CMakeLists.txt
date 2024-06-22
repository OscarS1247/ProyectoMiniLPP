cmake_minimum_required(VERSION 3.14)
project(MiniLPP)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX)
find_package(BISON)

find_program (TREECC treecc
              PATHS / /usr /usr/local /opt /opt/local $ENV{TREECC_DIR}
              PATH_SUFFIXES treecc/bin bin )

if (TREECC)
    message(STATUS "Using treecc executable ${TREECC}")
else(TREECC)
    message(FATAL_ERROR "treecc was not found. Try setting TREECC_DIR environment variable")
endif(TREECC)

# Run treecc to generate the AST
add_custom_command (
  OUTPUT MiniLppAst.cpp MiniLppAst.hpp
  COMMAND ${TREECC} -o MiniLppAst.cpp -h MiniLppAst.hpp ${PROJECT_SOURCE_DIR}/MiniLppAst.tc
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/MiniLppAst.tc
  )

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
    MiniLppAst.hpp
    MiniLppAst.cpp
    main.cpp
 )
