# devkitpro-cmake-config
Unofficial CMake Package Config for devkitPro.

## Why?

1. Better Documentation  
Unlike the CMake files packaged with devkitPro, this package config has its features and side effects well documented. All files have comments indicating what they are doing (CMake can be difficult to read!).

2. Fully Featured Modern CMake  
By using modern "Target Based" CMake, there's less you have to worry about to include the stuff you need. Less complexity means less dependencies so your build system is less error prone!

3. Examples!  
At the core of this project's design philosophy is sharing examples, so that you can learn how things work and get past the tough learning phase of integratig CMake.

## Setup
devkitPro's root directory is expected to be installed at `/opt/devkitpro`, but `DEVKITPRO` may be defined as a CMake variable or environment variable to supply a custom install location.

If the package fails to find anything required, it will fail with a `FATAL_ERROR` message.

### Custom Executables
When locating each executable provided by devkitPro, the package will first check for a CMake variable or environment 
variable of the form `DKP_X`, where X is replaced by the upper case name of the executable, ie. `DKP_BIN2S`. 
The relevant functions will use the provided path to the executable instead of the default path.

### Toolchains
Optional toolchain files for devkitPro platforms are included under the [toolchains](toolchains) directory.
These are simpler than the ones packaged with devkitPro since they leave libraries and tools to the package config.
For a list of differences, see the [toolchains directory readme](toolchains/README.md).  
The package config does not require these toolchain files, the ones packaged with devkitPro work as well.

Toolchain files should be passed to cmake with the -[DCMAKE_TOOLCHAIN_FILE](https://cmake.org/cmake/help/latest/variable/CMAKE_TOOLCHAIN_FILE.html) option, as in `-DCMAKE_TOOLCHAIN_FILE=path/to/toolchains/gamecube.toolchain.cmake`.

## Definitions
`DEVKITPRO`: devkitPro root directory

`DKP_X`: path to executable (where X is replaced by the upper case name of the executable ie. `DKP_BIN2S`)

`dkp_add_bin2s(target binary_files)`

`dkp_add_elf2dol(target dol_file_name source_file default_build_target)`

`dkp_add_gxtexconv(target scf_files)` + Target Property: `DKP_GXTEXCONV_TPL_FILES`

## Debugging

Each target generating function logs `VERBOSE` messages for relevant properties. Set your CMake log level to `VERBOSE` to greater
to see them: `set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE)`.

# TODO
- Handle failure of finding libs and programs eloquently
- Analyze remaining dkp toolchain files for things that should be added
- Update docs
- wii and nds support next

# Compatibility
Package Config Differences:
* No catnip
* ...
