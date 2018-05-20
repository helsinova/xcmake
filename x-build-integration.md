# Integration

Integration and tweaking into your own root CMakeFiles.txt.

*NOTE:* This text is for project maintainers.

Ideally tweaking and integrating from tool-chain files should not be needed.
But you might want to do it anyway to benefit from some special features or
abilities. Especially from tool-chain files that try to deduct stuff, or to
aid ability to build your project with a tool-chain that isn't exactly for
your target, but close enough.

References:
* Further reading for the interested about `CMake` and cross-build support
  in the official docs: 
  [cmake-toolchains](https://cmake.org/cmake/help/v3.8/manual/cmake-toolchains.7.htm)
* Some useful reading from
 [queezythegreat](https://github.com/queezythegreat/arduino-cmake/issues/38)

Sections below are for each tool-chain file in
`$YOUR_PROJECT/cmake/toolchains/` respectively.

## `Android.cmake`

### `SYSROOT`

Somewhere early in your `CNakeLists.txt` you might want't to add the
following snippet to aid change of `SYSROOT` in case the tool-chain file's
guess isn't what you want:

```CMake
set(SYSROOT
	${CMAKE_SYSROOT}
	CACHE STRING
	"System path (--system=)")
```

This should enable change of `SYSROOT` even after the project is once
configured. This is the main feature of this tool-chain file btw. One nifty
use is for compiling code for a system for which you don't have an exact
match of cross-tools but where the `CPU achitecture` and `ABI` is otherwise
correct. For example building for `Chrome OS` using Android `NDK` or vice
versa.

### `C_FLAGS` management

The tool-chain file injects `C_FLAGS` not directly but in a variable
`CMAKE_EXTRA_C_FLAGS`. This is so that you (or other CMake modules) can
conveniently bother only about `CMAKE_C_FLAGS`. You need to concatenate the
options at some point for example like this:

```CMake
set(CMAKE_C_FLAGS "${CMAKE_EXTRA_C_FLAGS} -no-integrated-cpp -Wno-unused-function -Wall")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_EXTRA_C_FLAGS} -g3 -ggdb3 -O0")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_EXTRA_C_FLAGS} -no-integrated-cpp -Wno-unused-function -O2 -Wall")
```

If you want to be able to additionally moderate `CMAKE_EXTRA_C_FLASGS` in
your project, add the following prior to the lines above:

```CMake
set(CMAKE_EXTRA_C_FLAGS
	"${CMAKE_EXTRA_C_FLAGS} -DSOME_DEFAULT_OPTION"
	CACHE STRING
	"Compiler options appended to CMAKE_C_FLAGS")
```

Be careful if using the above this so that the tool-chains options will not get
overwritten. I.e. especially if configuring using command-line options.
Personally I use `ccmake` for post configure fine-tuning.


