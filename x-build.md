
# Cross-compiling
For cross-compiling you need so called *tool-chain* files. In this project
there is one such available ``Android.cmake``, but normally these are
external components.

Further reading for the interested about `CMake`
[cmake-toolchains](https://cmake.org/cmake/help/v3.8/manual/cmake-toolchains.7.htm)

Note: The tool-chain files below are not to be confused with possible
distribution supplied ones with the same name.

## Android.cmake

`Android.cmake` is generic and can be used for any ARM-based Linux system.
Actually any Linux-system if you also tweak the `TRIPLET_PREFIX`. The
tool-chain file tries to deduct suitable settings and options based on the
binary in `$PATH`. I.e. you must subsequently have you's tool-chain in
`$PATH`, which can originate either from `NDK`, `SDK` or full-fledged AOSP
system-development environment.

What you need to take special note about is the `CMAKE_SYSROOT`
variable. This expands to `SYSROOT` and need to correspond to where your
systems headers and library-files are stored on your build-host. For the
simple case the X-tools have a default. But or Android, this is the part of
the NDK and must defined explicitly. It usually looks something like the
following:

```bash
$SOME_NDK_PATH/platforms/android-NN/arch-arm
```

* For an Android build (recommended method):
```bash
mkdir BUILD_android
cd BUILD_android
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchains/Android.cmake  ../
ccmake .         #Adjust settings. Optional but do verify SYSROOT
make -j$(cat /proc/cpuinfo | grep processor | wc -l)
```

