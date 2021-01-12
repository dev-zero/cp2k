###
#
# - Find PTSCOTCH include dirs and libraries
# Use this module by invoking find_package with the form:
#  find_package(PTSCOTCH
#               [REQUIRED]             # Fail with error if ptscotch is not found
#               [COMPONENTS <comp1> <comp2> ...] # dependencies
#              )
#
#  PTSCOTCH depends on the following libraries:
#   - Threads
#   - MPI
#
#  COMPONENTS can be some of the following:
#   - ESMUMPS: to activate detection of PT-Scotch with the esmumps interface
#
# This module finds headers and ptscotch library.
# Results are reported in variables:
#  PTSCOTCH_FOUND            - True if headers and requested libraries were found
#  PTSCOTCH_LINKER_FLAGS     - list of required linker flags (excluding -l and -L)
#  PTSCOTCH_INCLUDE_DIRS     - ptscotch include directories
#  PTSCOTCH_LIBRARY_DIRS     - Link directories for ptscotch libraries
#  PTSCOTCH_LIBRARIES        - ptscotch component libraries to be linked
#
# The user can give specific paths where to find the libraries adding cmake
# options at configure (ex: cmake path/to/project -DPTSCOTCH=path/to/ptscotch):
#  PTSCOTCH_DIR              - Where to find the base directory of ptscotch
#  PTSCOTCH_INCDIR           - Where to find the header files
#  PTSCOTCH_LIBDIR           - Where to find the library files
# The module can also look for the following environment variables if paths
# are not given as cmake variable: PTSCOTCH_DIR, PTSCOTCH_INCDIR, PTSCOTCH_LIBDIR


if (NOT PTSCOTCH_FOUND)
  set(PTSCOTCH_DIR "" CACHE PATH "Installation directory of PTSCOTCH library")
  if (NOT PTSCOTCH_FIND_QUIETLY)
    message(STATUS "A cache variable, namely PTSCOTCH_DIR, has been set to specify the install directory of PTSCOTCH")
  endif()
endif()

# Set the version to find
set(PTSCOTCH_LOOK_FOR_ESMUMPS OFF)

if( PTSCOTCH_FIND_COMPONENTS )
  foreach( component ${PTSCOTCH_FIND_COMPONENTS} )
    if (${component} STREQUAL "ESMUMPS")
      # means we look for esmumps library
      set(PTSCOTCH_LOOK_FOR_ESMUMPS ON)
    endif()
  endforeach()
endif()

# Try to find the ptscotch header in the given paths
# -------------------------------------------------

find_path(PTSCOTCH_INCLUDE_DIRS NAMES ptscotch.h scotch.h
  PATH_SUFFIXES inc include include/ptscotch ptscotch include/openmpi-x86_64 include/mpich-x86_64
  HINTS
  ENV EBROOTPTSCOTCH
  ENV PTSCOTCHROOT
  ENV PTSCOTCH_ROOT
  ENV PTSCOTCH_ROOT
  ENV PTSCOTCH_PREFIX
  ENV PTSCOTCH_PREFIX)

list(REMOVE_DUPLICATES PTSCOTCH_INCLUDE_DIRS)

# Looking for lib
# ---------------

find_library(PTSCOTCH_LIBRARIES NAMES ptscotch scotch
  PATH_SUFFIXES lib
  HINTS
  ENV EBROOTPTSCOTCH
  ENV PTSCOTCHROOT
  ENV PTSCOTCH_ROOT
  ENV PTSCOTCH_ROOT
  ENV PTSCOTCH_PREFIX
  ENV PTSCOTCH_PREFIX
  DOC "ptscotch libraries list"
  )

list(REMOVE_DUPLICATES PTSCOTCH_LIBRARY_DIRS)

message(${PTSCOTCH_LIBRARIES})

# check that PTSCOTCH has been found
# ---------------------------------
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Ptscotch DEFAULT_MSG
  PTSCOTCH_LIBRARIES PTSCOTCH_INCLUDE_DIRS)

if (PTSCOTCH_FOUND AND NOT TARGET ptscotch::ptscotch)
  add_library(ptscotch::ptscotch INTERFACE IMPORTED)
  set_target_properties(ptscotch::ptscotch PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${PTSCOTCH_INCLUDE_DIRS}"
    INTERFACE_LINK_LIBRARIES "${PTSCOTCH_LIBRARIES}"
    INTERFACE_LINK_DIRECTORIES "${PTSCOTCH_LIBRARY_DIRS}")
endif()
