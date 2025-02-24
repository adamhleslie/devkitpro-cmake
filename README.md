# devkitpro-cmake-better
Better CMake Package for devkitPro.

## Why?

1. Better Documentation  
Unlike the CMake files packaged with devkitPro, this package config has its features and side effects well documented. All files have comments indicating what they are doing, and every function generating a target logs important properties.

2. Fully Featured Modern CMake  
By using modern "Target Based" CMake, there's less you have to worry about to include the stuff you need. Less dependencies so your build system is less error prone!

3. Examples!  
Template projects are provided for each toolchain, and everything provided by this project has example usage, so you can make your homebrew ideas come to life. See Templates and Examples below

## Setup
devkitPro's root directory is expected to be installed at `/opt/devkitpro`, but `DEVKITPRO` may be defined as a CMake variable or environment variable to supply a custom install location. For installing devkitPro, see their [Getting Started Wiki page](https://devkitpro.org/wiki/Getting_Started).

If the package fails to find anything required, it will fail with a `FATAL_ERROR` message.

### Toolchains
Optional toolchain files for devkitPro platforms are included under the [toolchains](toolchains) directory.
These are simpler than the ones packaged with devkitPro since they leave libraries and tools to the package config.
For a list of differences, see the [toolchains directory readme](toolchains/README.md).  
These are not required to use the package config, the toolchain files included with devkitPro work as well.

Toolchain files should be passed to cmake with the -[DCMAKE_TOOLCHAIN_FILE](https://cmake.org/cmake/help/latest/variable/CMAKE_TOOLCHAIN_FILE.html) option, as in `-DCMAKE_TOOLCHAIN_FILE=path/to/toolchains/gamecube.toolchain.cmake`.

### Custom Executables
When locating each executable provided by devkitPro, the package will first check for a CMake variable or environment 
variable of the form `DKP_X`, where X is replaced by the upper case name of the executable, ie. `DKP_BIN2S`. 
The relevant functions will use the provided path to the executable instead of the default path.

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
- Analyze remaining Wii / GameCube dkp toolchain files for things that should be added, and start tracking compatibility / changes
- Handle failure of finding libs and programs eloquently, add support for indicating devkitpro packages for logging's sake, and indicate supported versioning of devkitPro packages
- Update docs
- Test Visual Studio, and VS Code
- nds support next

# Compatibility
Package Config Differences:
* No catnip
* ...
