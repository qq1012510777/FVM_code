# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.13

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/cmake-3.13.0/bin/cmake

# The command to remove a file.
RM = /opt/cmake-3.13.0/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/tingchangyin/Desktop/FVM_node_centered

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/tingchangyin/Desktop/FVM_node_centered/build

# Include any dependencies generated for this target.
include CMakeFiles/main.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/main.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/main.dir/flags.make

CMakeFiles/main.dir/src/main.cpp.o: CMakeFiles/main.dir/flags.make
CMakeFiles/main.dir/src/main.cpp.o: ../src/main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/tingchangyin/Desktop/FVM_node_centered/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/main.dir/src/main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/main.dir/src/main.cpp.o -c /home/tingchangyin/Desktop/FVM_node_centered/src/main.cpp

CMakeFiles/main.dir/src/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/main.dir/src/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/tingchangyin/Desktop/FVM_node_centered/src/main.cpp > CMakeFiles/main.dir/src/main.cpp.i

CMakeFiles/main.dir/src/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/main.dir/src/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/tingchangyin/Desktop/FVM_node_centered/src/main.cpp -o CMakeFiles/main.dir/src/main.cpp.s

# Object files for target main
main_OBJECTS = \
"CMakeFiles/main.dir/src/main.cpp.o"

# External object files for target main
main_EXTERNAL_OBJECTS =

../bin/main: CMakeFiles/main.dir/src/main.cpp.o
../bin/main: CMakeFiles/main.dir/build.make
../bin/main: /usr/local/lib/libgmsh.so
../bin/main: /usr/local/lib/libTKBinL.so
../bin/main: /usr/local/lib/libTKBin.so
../bin/main: /usr/local/lib/libTKBinTObj.so
../bin/main: /usr/local/lib/libTKBinXCAF.so
../bin/main: /usr/local/lib/libTKBool.so
../bin/main: /usr/local/lib/libTKBO.so
../bin/main: /usr/local/lib/libTKBRep.so
../bin/main: /usr/local/lib/libTKCAF.so.7.5.0
../bin/main: /usr/local/lib/libTKCDF.so
../bin/main: /usr/local/lib/libTKernel.so
../bin/main: /usr/local/lib/libTKFeat.so
../bin/main: /usr/local/lib/libTKFillet.so
../bin/main: /usr/local/lib/libTKG2d.so
../bin/main: /usr/local/lib/libTKG3d.so
../bin/main: /usr/local/lib/libTKGeomAlgo.so
../bin/main: /usr/local/lib/libTKGeomBase.so
../bin/main: /usr/local/lib/libTKHLR.so
../bin/main: /usr/local/lib/libTKIGES.so
../bin/main: /usr/local/lib/libTKLCAF.so
../bin/main: /usr/local/lib/libTKMath.so
../bin/main: /usr/local/lib/libTKMesh.so
../bin/main: /usr/local/lib/libTKMeshVS.so
../bin/main: /usr/local/lib/libTKOffset.so
../bin/main: /usr/local/lib/libTKOpenGl.so
../bin/main: /usr/local/lib/libTKPrim.so
../bin/main: /usr/local/lib/libTKService.so
../bin/main: /usr/local/lib/libTKShHealing.so
../bin/main: /usr/local/lib/libTKSTEP209.so
../bin/main: /usr/local/lib/libTKSTEPAttr.so
../bin/main: /usr/local/lib/libTKSTEPBase.so
../bin/main: /usr/local/lib/libTKSTEP.so
../bin/main: /usr/local/lib/libTKSTL.so
../bin/main: /usr/local/lib/libTKTObj.so
../bin/main: /usr/local/lib/libTKTopAlgo.so
../bin/main: /usr/local/lib/libTKV3d.so
../bin/main: /usr/local/lib/libTKVRML.so
../bin/main: /usr/local/lib/libTKXCAF.so
../bin/main: /usr/local/lib/libTKXDEIGES.so
../bin/main: /usr/local/lib/libTKXDESTEP.so
../bin/main: /usr/local/lib/libTKXMesh.so
../bin/main: /usr/local/lib/libTKXmlL.so
../bin/main: /usr/local/lib/libTKXml.so
../bin/main: /usr/local/lib/libTKXmlTObj.so
../bin/main: /usr/local/lib/libTKXmlXCAF.so
../bin/main: /usr/local/lib/libTKXSBase.so
../bin/main: CMakeFiles/main.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/tingchangyin/Desktop/FVM_node_centered/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../bin/main"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/main.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/main.dir/build: ../bin/main

.PHONY : CMakeFiles/main.dir/build

CMakeFiles/main.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/main.dir/cmake_clean.cmake
.PHONY : CMakeFiles/main.dir/clean

CMakeFiles/main.dir/depend:
	cd /home/tingchangyin/Desktop/FVM_node_centered/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/tingchangyin/Desktop/FVM_node_centered /home/tingchangyin/Desktop/FVM_node_centered /home/tingchangyin/Desktop/FVM_node_centered/build /home/tingchangyin/Desktop/FVM_node_centered/build /home/tingchangyin/Desktop/FVM_node_centered/build/CMakeFiles/main.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/main.dir/depend

