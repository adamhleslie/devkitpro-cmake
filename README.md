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
devkitPro's root directory is expected to be installed at `/opt/devkitpro`, but `DEVKITPRO` may defined as a CMake variable or environment variable to supply a custom install location.

If the package fails to find anything it expects, it will fail CMake with a `FATAL_ERROR` message.

### Custom Executables
When locating each executable provided by devkitPro, the package will first check for a CMake variable or environment 
variable of the form `DEVKITPRO_X`, where X is replaced by the upper case name of the executable, ie. `DEVKITPRO_BIN2S`. 
The relevant functions will use the provided path to the executable instead of the default path.

## Definitions
`DEVKITPRO`: devkitPro root directory

`DEVKITPRO_X`: path to executable (where X is replaced by the upper case name of the executable ie. `DEVKITPRO_BIN2S`)

`devkitpro_add_bin2s(target binary_files)`

`devkitpro_add_elf2dol(target dol_file_name source_file default_build_target)`

`devkitpro_add_gxtexconv(target scf_files)` + Target Property: `DEVKITPRO_GXTEXCONV_TPL_FILES`

## Debugging

Each target generating function logs `VERBOSE` messages for relevant properties. Set your CMake log level to `VERBOSE` to greater
to see them: `set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE)`.

# TODO
- Analyze existing dkp toolchain files for things that should go into
- Test dkp toolchain files with package
- Package simplified toolchain files, under `toolchains/`
- Determine naming convention, whether to base on dkp toolchain files or not
- Update docs
- wii and nds support next
