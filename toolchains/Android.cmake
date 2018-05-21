include (CMakeForceCompiler)
set(CMAKE_SYSTEM_NAME Generic)

# Tool-chain file which auto-deducts options from x-tool in PATH.

set(XTOOL_PREFIX
	arm-linux-androideabi
	CACHE STRING
	"Cross compiler PREFIX in the format <CPUarchitecture>-<system>-<ABI>")

set(X_PREFIX ${XTOOL_PREFIX}-)

find_program(GCC_EXECUTABLE ${XTOOL_PREFIX}-gcc)

if(NOT GCC_EXECUTABLE)
	message( FATAL_ERROR  "Executable ${XTOOL_PREFIX}-gcc not in \$PATH. Can't continue.")
endif(NOT GCC_EXECUTABLE)


set(CMAKE_C_COMPILER_TARGET ${X_PREFIX})

#Autodetect if tool-chain can build for Android
execute_process(
	COMMAND ${X_PREFIX}gcc -dM -E -
	INPUT_FILE /dev/null
	COMMAND grep ANDROID
	OUTPUT_VARIABLE __ANDROID_TARGET_TEST
)
string(STRIP "${__ANDROID_TARGET_TEST}" ANDROID_TARGET_TEST)

CMAKE_FORCE_C_COMPILER(${X_PREFIX}gcc ${X_PREFIX}gcc)
CMAKE_FORCE_CXX_COMPILER(${X_PREFIX}g++ ${X_PREFIX}g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

if (NOT ANDROID_TARGET_TEST STREQUAL "")
	set	(HAVE_ANDROID_OS_DEFAULT 1)
	message(STATUS "Tool-chain can buld for Android: ${ANDROID_TARGET_TEST}" )
endif (NOT ANDROID_TARGET_TEST STREQUAL "")

set(HAVE_ANDROID_OS
	${HAVE_ANDROID_OS_DEFAULT}
	CACHE BOOL
	"Is this build intended for an Android system?")

if (HAVE_ANDROID_OS)
	message(STATUS "Going to build for Android target" )

	# Autodetect SYSROOT in NDK
	execute_process(
		COMMAND which "${X_PREFIX}gcc"
		OUTPUT_VARIABLE NDK_GCC_FULLPATH
	)
	message(STATUS "NDK_GCC_FULLPATH: ${NDK_GCC_FULLPATH}" )
	execute_process(
		COMMAND ${PROJECT_SOURCE_DIR}/cmake/host/android_sysroot.sh
			${NDK_GCC_FULLPATH}
			OUTPUT_VARIABLE __DETECTED_SYSROOT
	)
	string(STRIP "${__DETECTED_SYSROOT}" DETECTED_SYSROOT)
	message(STATUS "DETECTED_SYSROOT: ${DETECTED_SYSROOT}" )

	if (NOT DETECTED_SYSROOT STREQUAL "")
		set(CMAKE_SYSROOT "${DETECTED_SYSROOT}")
	endif (NOT DETECTED_SYSROOT STREQUAL "")

	# Set *C_FLAGS section but avoid build-up
	#
	# CMAKE_EXTRA_C_FLAGS: Independent of CMAKE_C_FLAGS so they can be
	#                      concatenated, but concatenation must be done in
	#                      root CMakeLists.txt
	if (NOT HAVE_TOOLFILE_SET_EXTRA_C_FLAGS)
		set(CMAKE_EXTRA_C_FLAGS "${CMAKE_EXTRA_C_FLAGS} -fPIE -pie -DHAVE_ANDROID_OS")

		# If tool-chain isn't specifically for Android, but user configured
		# HAVE_ANDROID_OS anyway, at lest set -DANDROID
		if (ANDROID_TARGET_TEST STREQUAL "")
			set(CMAKE_EXTRA_C_FLAGS "${CMAKE_EXTRA_C_FLAGS} -DANDROID")
			message(
				WARNING
				"Non-Android tool-chain used for building Android: ${ANDROID_TARGET_TEST}"
			)
		endif (ANDROID_TARGET_TEST STREQUAL "")

		# Append --sysroot option. Needed for this CMAKE_SYSTEM_NAME
		if (NOT SYSROOT STREQUAL "")
			set(CMAKE_EXTRA_C_FLAGS "${CMAKE_EXTRA_C_FLAGS} --sysroot=${CMAKE_SYSROOT}")
		endif (NOT SYSROOT STREQUAL "")

		set	(HAVE_TOOLFILE_SET_EXTRA_C_FLAGS 1)
	endif (NOT HAVE_TOOLFILE_SET_EXTRA_C_FLAGS)

	# Convenience version of the above.
	# WARNING: Could be overwritten by user-configuration which may not be what you
	# want. See CMAKE_EXTRA_C_FLAGS for a better way of handling C_FLAGS
	if (NOT HAVE_TOOLFILE_SET_C_FLAGS)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_EXTRA_C_FLAGS}")

		set	(HAVE_TOOLFILE_SET_C_FLAGS 1)
	endif (NOT HAVE_TOOLFILE_SET_C_FLAGS)

endif (HAVE_ANDROID_OS)

