# xcmake

CMake tool-chain file(s) for cross-building used by many of
[Helsinova's](https://github.com/helsinova) and
[mambrus's](https://github.com/mambrus) projects.

Add this project to your own projects root-directory, preferably as a git submodule

Conventionally tool-chain files are stored in a sub-directory called `cmake`
but that is not strictly required.

```bash
cd $YOUR_PROJECT
git submodule add cmake https://github.com/helsinova/xcmake.git
```

Read on in [x-build](x-build.md) for how use the tool-chain files, including
quirks and adaptations into your own `CMakeLists.txt`.

The above link you can also refer to from your own project-documentation for
project users. For maintainers there is another one more in depth with
tweaks and gotchas: [x-build-integration](x-build-integration.md) 

## Origin

This project was originally part of
[mambrus/sampler](https://github.com/mambrus/sampler) but is now separated
to aid re-use.
