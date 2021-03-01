include(FindPackageHandleStandardArgs)
find_package(PkgConfig REQUIRED)

pkg_search_module(SCALAPACK scalapack)

# we need to be able to select between mkl scalapack and scalapack

find_library(SCALAPACK_LIBRARIES
  NAMES scalapack scalapack-openmpi
  HINTS
  ${_SCALAPACK_LIBRARY_DIRS}
  ENV SCALAPACKROOT
  /usr
  PATH_SUFFIXES lib
  DOC "scalapack library path")

find_package_handle_standard_args(Scalapack DEFAULT_MSG SCALAPACK_LIBRARIES)

if (SCALAPACK_FOUND AND NOT TARGET scalapack::scalapack)
  add_library(scalapack::scalapack INTERFACE IMPORTED)
  set_target_properties(scalapack::scalapack PROPERTIES
    INTERFACE_LINK_LIBRARIES "${SCALAPACK_LIBRARIES}")
endif ()
