# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

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
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /root/hw3/assign3

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /root/hw3/assign3/build

# Include any dependencies generated for this target.
include CMakeFiles/assignment3.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/assignment3.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/assignment3.dir/flags.make

CMakeFiles/assignment3.dir/LLVMAssignment.cpp.o: CMakeFiles/assignment3.dir/flags.make
CMakeFiles/assignment3.dir/LLVMAssignment.cpp.o: ../LLVMAssignment.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/root/hw3/assign3/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/assignment3.dir/LLVMAssignment.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/assignment3.dir/LLVMAssignment.cpp.o -c /root/hw3/assign3/LLVMAssignment.cpp

CMakeFiles/assignment3.dir/LLVMAssignment.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/assignment3.dir/LLVMAssignment.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /root/hw3/assign3/LLVMAssignment.cpp > CMakeFiles/assignment3.dir/LLVMAssignment.cpp.i

CMakeFiles/assignment3.dir/LLVMAssignment.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/assignment3.dir/LLVMAssignment.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /root/hw3/assign3/LLVMAssignment.cpp -o CMakeFiles/assignment3.dir/LLVMAssignment.cpp.s

# Object files for target assignment3
assignment3_OBJECTS = \
"CMakeFiles/assignment3.dir/LLVMAssignment.cpp.o"

# External object files for target assignment3
assignment3_EXTERNAL_OBJECTS =

assignment3: CMakeFiles/assignment3.dir/LLVMAssignment.cpp.o
assignment3: CMakeFiles/assignment3.dir/build.make
assignment3: /usr/local/llvm10ra/lib/libLLVMCore.a
assignment3: /usr/local/llvm10ra/lib/libLLVMIRReader.a
assignment3: /usr/local/llvm10ra/lib/libLLVMPasses.a
assignment3: /usr/local/llvm10ra/lib/libLLVMCodeGen.a
assignment3: /usr/local/llvm10ra/lib/libLLVMTarget.a
assignment3: /usr/local/llvm10ra/lib/libLLVMipo.a
assignment3: /usr/local/llvm10ra/lib/libLLVMIRReader.a
assignment3: /usr/local/llvm10ra/lib/libLLVMAsmParser.a
assignment3: /usr/local/llvm10ra/lib/libLLVMInstrumentation.a
assignment3: /usr/local/llvm10ra/lib/libLLVMScalarOpts.a
assignment3: /usr/local/llvm10ra/lib/libLLVMAggressiveInstCombine.a
assignment3: /usr/local/llvm10ra/lib/libLLVMInstCombine.a
assignment3: /usr/local/llvm10ra/lib/libLLVMVectorize.a
assignment3: /usr/local/llvm10ra/lib/libLLVMBitWriter.a
assignment3: /usr/local/llvm10ra/lib/libLLVMLinker.a
assignment3: /usr/local/llvm10ra/lib/libLLVMTransformUtils.a
assignment3: /usr/local/llvm10ra/lib/libLLVMAnalysis.a
assignment3: /usr/local/llvm10ra/lib/libLLVMObject.a
assignment3: /usr/local/llvm10ra/lib/libLLVMBitReader.a
assignment3: /usr/local/llvm10ra/lib/libLLVMMCParser.a
assignment3: /usr/local/llvm10ra/lib/libLLVMMC.a
assignment3: /usr/local/llvm10ra/lib/libLLVMDebugInfoCodeView.a
assignment3: /usr/local/llvm10ra/lib/libLLVMDebugInfoMSF.a
assignment3: /usr/local/llvm10ra/lib/libLLVMTextAPI.a
assignment3: /usr/local/llvm10ra/lib/libLLVMProfileData.a
assignment3: /usr/local/llvm10ra/lib/libLLVMCore.a
assignment3: /usr/local/llvm10ra/lib/libLLVMBinaryFormat.a
assignment3: /usr/local/llvm10ra/lib/libLLVMRemarks.a
assignment3: /usr/local/llvm10ra/lib/libLLVMBitstreamReader.a
assignment3: /usr/local/llvm10ra/lib/libLLVMSupport.a
assignment3: /usr/lib/x86_64-linux-gnu/libz3.so
assignment3: /usr/local/llvm10ra/lib/libLLVMDemangle.a
assignment3: CMakeFiles/assignment3.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/root/hw3/assign3/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable assignment3"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/assignment3.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/assignment3.dir/build: assignment3

.PHONY : CMakeFiles/assignment3.dir/build

CMakeFiles/assignment3.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/assignment3.dir/cmake_clean.cmake
.PHONY : CMakeFiles/assignment3.dir/clean

CMakeFiles/assignment3.dir/depend:
	cd /root/hw3/assign3/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /root/hw3/assign3 /root/hw3/assign3 /root/hw3/assign3/build /root/hw3/assign3/build /root/hw3/assign3/build/CMakeFiles/assignment3.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/assignment3.dir/depend

