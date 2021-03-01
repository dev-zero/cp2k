include(FindPackageHandleStandardArgs)

find_library(LIBVORI_LIBRARY NAMES vori
  PATH_SUFFIXES lib
  HINTS
  ENV EBLIBVORI
  ENV LIBVORIROOT
  ENV LIBVORI_ROOT
  ENV LIBVORI_PREFIX
  DOC "libvori library")

find_path(LIBVORI_INCLUDE_DIRS NAMES voro++.h
  PATH_SUFFIXES include inc vori include/vori
  HINTS
  ENV EBLIBVORI
  ENV LIBVORIROOT
  ENV LIBVORI_ROOT
  ENV LIBVORI_PREFIX
  DOC "libvori header files directory")


find_package_handle_standard_args(LibVORI DEFAULT_MSG LIBVORI_LIBRARIES LIBVORI_INCLUDE_DIRS)

if (LIBVORI_LIBRARY_FOUND NOT TARGET vori::vori)
  add_library(vori::vori INTERFACE IMPORTED)
  set_target_properties(vori::vori PROPERTIES
    INTERFACE_LINK_LIBRARIES "${LIBVORI_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${LIBXC_INCLUDE_DIR}")
endif ()
