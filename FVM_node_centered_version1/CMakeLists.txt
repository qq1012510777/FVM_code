cmake_minimum_required (VERSION 3.5)

project (demo)

set (EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin) ## bin is the EXECUTABLE_OUTPUT_PATH

set (SRC_LIST ${PROJECT_SOURCE_DIR}/src/main.cpp)

include_directories (/usr/local/include/)
include_directories (/usr/local/include/opencascade)

INCLUDE_DIRECTORIES (${PROJECT_SOURCE_DIR}/include)

find_library(GMSH_LIB gmsh HINTS /usr/local/lib)

# OpenCASCADE

INCLUDE (${PROJECT_SOURCE_DIR}/FindOpenCASCADE.cmake)
INCLUDE_DIRECTORIES (${OCC_INCLUDE_DIR})
#


INCLUDE_DIRECTORIES(/home/tingchangyin/mechsys/lib/dfn/Geometry_H)
INCLUDE_DIRECTORIES(/home/tingchangyin/pkg/Eigen)

FIND_PACKAGE(Boost)
IF (Boost_FOUND)
    INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIR})
    ADD_DEFINITIONS( "-DHAS_BOOST" )
ENDIF()

add_executable (main ${SRC_LIST})

target_link_libraries (main ${GMSH_LIB})

target_link_libraries (main ${OCC_LIBRARIES})

if ( CMAKE_COMPILER_IS_GNUCC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wmaybe-uninitialized")
endif()
if ( MSVC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} /W4 -Wmaybe-uninitialized")
endif()