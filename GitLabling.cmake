#
# Tags from git-log
#
find_program(EXE_GIT git)
if(EXE_GIT STREQUAL "GIT-NOTFOUND")
    message(FATAL_ERROR "Please install git")
endif()

find_package(Git)
execute_process(COMMAND
  "${GIT_EXECUTABLE}" describe --match=NeVeRmAtCh --always --abbrev=7 --dirty
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  OUTPUT_VARIABLE GIT_SHA1
  ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

set(PROJECT_VERSION_TWEAK ${GIT_SHA1})
