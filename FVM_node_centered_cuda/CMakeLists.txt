cmake_minimum_required (VERSION 3.5)

project (demo)

FIND_PACKAGE(CUDA REQUIRED)
if (NOT CUDA_FOUND)
  message(STATUS "CUDA not found. Project will not be built.")
endif(NOT CUDA_FOUND)

set (EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin) ## bin is the EXECUTABLE_OUTPUT_PATH

set (SRC_LIST ${PROJECT_SOURCE_DIR}/src/main.cu)

include_directories (/usr/local/include/)
include_directories (/usr/local/include/opencascade)

INCLUDE_DIRECTORIES (${PROJECT_SOURCE_DIR}/include)

find_library(GMSH_LIB gmsh HINTS /usr/local/lib)

# OpenCASCADE

INCLUDE (${PROJECT_SOURCE_DIR}/FindOpenCASCADE.cmake)
INCLUDE_DIRECTORIES (${OCC_INCLUDE_DIR})
#

INCLUDE_DIRECTORIES(/home/tingchangyin/mechsys/lib/dfn/Geometry_H)
INCLUDE_DIRECTORIES(/home/tingchangyin/pkg/)

FIND_PACKAGE(Boost)
IF (Boost_FOUND)
    INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIR})
    ADD_DEFINITIONS( "-DHAS_BOOST" )
ENDIF()

# UMFPACK
include_directories ($ENV{HOME}/pkg/SuiteSparse-master/include)
find_library(AMD_LIB amd HINTS $ENV{HOME}/pkg/SuiteSparse-master/lib)
find_library(UMFPACK_LIB umfpack HINTS $ENV{HOME}/pkg/SuiteSparse-master/lib)

####
add_subdirectory(GPU)
include_directories(GPU)
###
#cuda
include_directories(/usr/local/cuda/include)
#find_library(CUDA_cuda cuda HINTS /usr/local/cuda/lib64)
#find_library(CUDA_cudart cudart HINTS /usr/local/cuda/lib64)

CUDA_ADD_EXECUTABLE(main
    ${PROJECT_SOURCE_DIR}/src/main.cu
    OPTIONS -arch=sm_60
)
target_link_libraries (main ${GMSH_LIB})
target_link_libraries (main ${OCC_LIBRARIES})
#target_link_libraries (main CUDA_cuda)
#target_link_libraries (main CUDA_cudart)
target_link_libraries (main GPU_mat)
#target_link_libraries (main GPU_device)
TARGET_LINK_LIBRARIES( main ${CUDA_LIBRARIES} ${CUDA_cusparse_LIBRARY} ${CUDA_cublas_LIBRARY} ${CUDA_cusolver_LIBRARY})

target_link_libraries (main ${AMD_LIB})
target_link_libraries (main ${UMFPACK_LIB})

if ( CMAKE_COMPILER_IS_GNUCC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wmaybe-uninitialized")
endif()
if ( MSVC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} /W4 -Wmaybe-uninitialized")
endif()