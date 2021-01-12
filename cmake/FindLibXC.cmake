include(FindPackageHandleStandardArgs)
find_package(PkgConfig REQUIRED)

pkg_check_modules(LIBXC libxc<=${LibXC_FIND_VERSION} libxcf03 libxcf90 QUIET)

find_library(LIBXC_LIBRARIES NAMES xc
  PATH_SUFFIXES lib
  HINTS
  ENV EBROOTLIBXC
  ENV LIBXCROOT
  ENV LIBXC_ROOT
  ENV LIBXC_PREFIX
  ${_LIBXC_LIBRARY_DIRS}
  DOC "libxc libraries list")

find_library(LIBXCF90_LIBRARIES NAMES xcf90
  PATH_SUFFIXES lib
  HINTS
  ENV EBROOTLIBXC
  ENV LIBXCROOT
  ENV LIBXC_ROOT
  ENV LIBXC_PREFIX
  ${_LIBXC_LIBRARY_DIRS}
  DOC "fortran 90 binding of the libxc library")

find_library(LIBXCF03_LIBRARIES NAMES xcf03
  PATH_SUFFIXES lib
  HINTS
  ENV EBROOTLIBXC
  ENV LIBXCROOT
  ENV LIBXC_ROOT
  ENV LIBXC_PREFIX
  ${_LIBXC_LIBRARY_DIRS}
  DOC "fortran 2003 binding of the libxc library")

find_path(LIBXC_INCLUDE_DIR NAMES xc.h xc_f90_types_m.mod
  PATH_SUFFIXES inc include
  HINTS
  ${_LIBXC_INCLUDE_DIRS}
  ENV EBROOTLIBXC
  ENV LIBXCROOT
  ENV LIBXC_ROOT
  ENV LIBXC_PREFIX
  )

set(LIBXC_LIBRARIES ${LIBXC_LIBRARIES} ${LIBXC90_LIBRARIES} ${LIBXC03_LIBRARIES})

if (LIBXC_FOUND)
  find_package_handle_standard_args(LibXC DEFAULT_MSG LIBXC_LIBRARIES LIBXC_INCLUDE_DIR)
else()
  message(FATAL_ERROR "CP2K requires libxc 4.3.* with fortran support. LibXC 5.0.0 is NOT supported.")
endif()

if(LibXC_FOUND AND NOT TARGET libxc::libxc)
  add_library(libxc::libxc INTERFACE IMPORTED)
  set_target_properties(libxc::libxc PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${LIBXC_INCLUDE_DIR}"
    INTERFACE_LINK_LIBRARIES "${LIBXC_LIBRARIES}")
endif()
