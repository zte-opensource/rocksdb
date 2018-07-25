# - Find Snappy
# Find the snappy compression library and includes
#
# SNAPPY_INCLUDE_DIR - where to find snappy.h, etc.
# SNAPPY_LIBRARIES - List of libraries when using snappy.
# SNAPPY_FOUND - True if snappy found.

find_package(PkgConfig)
pkg_search_module(PC_snappy
  QUIET snappy)

find_path(SNAPPY_INCLUDE_DIR
  NAMES snappy.h
  HINTS
    ${PC_snappy_INCLUDE_DIRS}
    ${SNAPPY_ROOT_DIR}/include)


if(SNAPPY_USE_STATIC_LIB)
  set(_snappy_orig_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()
find_library(SNAPPY_LIBRARIES
  NAMES snappy
  HINTS
    ${PC_snappy_LIBRARY_DIRS}
    ${SNAPPY_ROOT_DIR}/lib)
if(SNAPPY_USE_STATIC_LIB)
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${_snappy_orig_FIND_LIBRARY_SUFFIXES})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(snappy DEFAULT_MSG SNAPPY_LIBRARIES SNAPPY_INCLUDE_DIR)

mark_as_advanced(
  SNAPPY_LIBRARIES
  SNAPPY_INCLUDE_DIR)
