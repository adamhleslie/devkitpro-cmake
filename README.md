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

If the package fails to find anything it expects, it will fail CMake with a `FATAL_ERROR` message.

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
- Test dkp toolchain files with package
- DEVKITPRO -> DKP
- DKP_BIN2S_ALIGNMENT support
- GCDSPTOOL_EXE
- Update compiler flags (package config / template) based on dkp-rule-overrides.cmake
- Analyze remaining dkp toolchain files for things that should be added
- Update docs
- wii and nds support next

# Compatibility
Toolchain Differences:
* No setting of CMAKE_MODULE_PATH, CMAKE_TRY_COMPILE_PLATFORM_VARIABLES, CMAKE_FIND_PACKAGE_PREFER_CONFIG, CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH variables
* No addition of standard system environment variables to CMAKE_SYSTEM_PROGRAM_PATH - not needed without CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH being set
* No setting of
  * DKP_BIN2S - use package config's DKP_BIN2S + dkp_add_bin2s
* Variable changes: DKP_OBJCOPY -> CMAKE_OBJCOPY, DKP_NM -> CMAKE_NM
* New variable: CMAKE_OBJDUMP
* No language flag overrides or compiler output extension overrides from dkp-rule-overrides.cmake - these are good options but not required for the platforms
  * CMAKE\_\${lang}\_OUTPUT_EXTENSION, CMAKE\_\${lang}\_OUTPUT\_EXTENSION\_REPLACE, CMAKE\_\${lang}\_FLAGS\_DEBUG\_INIT, CMAKE\_\${lang}\_FLAGS\_MINSIZEREL\_INIT, CMAKE\_\${lang}\_FLAGS\_RELEASE\_INIT, CMAKE\_\${lang}\_FLAGS\_RELWITHDEBINFO\_INIT
* No setting of DKP_INSTALL_PREFIX_INIT
* Gamecube
  * No setting of OGC_... variables
  * No Setting of
    * ELF2DOL_EXE - use package config's DKP_ELF2DOL + dkp_add_elf2dol
    * GXTEXCONV_EXE - use package config's DKP_GXTEXCONV + dkp_add_gxtexconv
    * GCDSPTOOL_EXE - TODO

Package Config Differences:
* No catnip
* ...