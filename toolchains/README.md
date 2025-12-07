# Toolchain Compatibility Reference

Reference for differences between official devkitPro CMake toolchains and this package.

## File Mapping

| Official  | New                                                             |
|---------------------------|-----------------------------------------------------------------|
| `dkp-toolchain-common.cmake` | `shared.toolchain.cmake` + `devkitppc.toolchain.cmake`          |
| `dkp-rule-overrides.cmake` | *(not included)*                                                |
| `devkitPPC.cmake` | `devkitppc.toolchain.cmake`                                     |
| `GameCube.cmake` + `ogc-common.cmake` | `gamecube.toolchain.cmake`                                      |
| `Wii.cmake` + `ogc-common.cmake` | `wii.toolchain.cmake`                                           |
| `Platform/libogc.cmake` | `../platforms/dkp-gamecube.cmake`, `../platforms/dkp-wii.cmake` |

## Variable Differences

### Renamed

| Official | New             | Official File | New File                       |
|----------|-----------------|---------------|--------------------------------|
| `DKP_OBJCOPY` | `CMAKE_OBJCOPY` | `dkp-toolchain-common.cmake:60` | `devkitppc.toolchain.cmake:32` |
| `DKP_NM` | `CMAKE_NM`      | `dkp-toolchain-common.cmake:61` | `devkitppc.toolchain.cmake:34` |

### Removed (use package config instead)

| Official Variable | Replacement | Official File |
|-------------------|---------------------------|---------------|
| `DKP_BIN2S` | `DKP_BIN2S` + `dkp_add_bin2s()` | `dkp-toolchain-common.cmake:64` |
| `OGC_ROOT`, `OGC_CONSOLE`, `OGC_SUBDIR`, `OGC_MACHINE` | `dkp::libogc::*` targets | `ogc-common.cmake:3-13` |
| `ELF2DOL_EXE` | `DKP_ELF2DOL` + `dkp_add_elf2dol()` | `ogc-common.cmake:32` |
| `GXTEXCONV_EXE` | `DKP_GXTEXCONV` + `dkp_add_gxtexconv()` | `ogc-common.cmake:34` |
| `GCDSPTOOL_EXE` | `DKP_GCDSPTOOL` *(function TODO)* | `ogc-common.cmake:33` |
| `devkitPPC` (identification) | *(not set)* | `dkp-toolchain-common.cmake:4` |

### Not Set (handled differently)

| Official Variable | New Approach                                               | Official File | New File |
|-------------------|------------------------------------------------------------|---------------|----------|
| `CMAKE_TRY_COMPILE_PLATFORM_VARIABLES` | Not needed                                                 | `dkp-toolchain-common.cmake:26` | — |
| `CMAKE_FIND_PACKAGE_PREFER_CONFIG` | Not set                                                    | `dkp-toolchain-common.cmake:29` | — |
| `CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH` | Not set                                                    | `dkp-toolchain-common.cmake:33` | — |
| `CMAKE_SYSTEM_PROGRAM_PATH` | Not set (no PATH parsing)                                  | `dkp-toolchain-common.cmake:34` | — |
| `CMAKE_C_FLAGS_INIT`, `CMAKE_CXX_FLAGS_INIT` | Platform interface libraries (`dkp::gamecube`, `dkp::wii`) | `Platform/libogc.cmake:11` | `../platforms/dkp-gamecube.cmake`, `../platforms/dkp-wii.cmake` |
| `CMAKE_<LANG>_STANDARD_LIBRARIES` | Library targets (`dkp::libogc::*`)                         | `Platform/libogc.cmake:14` | `../libraries/dkp-libogc.cmake` |
| `CMAKE_<LANG>_STANDARD_INCLUDE_DIRECTORIES` | Library targets                                            | `Platform/libogc.cmake:15` | `../libraries/dkp-libogc.cmake` |
| `DKP_INSTALL_PREFIX_INIT` | Not set                                                    | `ogc-common.cmake:19` | — |

### Added

| Variable | Value | File |
|----------|-------|------|
| `CMAKE_OBJDUMP` | `${triplet}-objdump` | `devkitppc.toolchain.cmake:33` |
| `CMAKE_EXECUTABLE_SUFFIX` | `.elf` | `shared.toolchain.cmake:22` |
| `BUILD_SHARED_LIBS` | `OFF` | `shared.toolchain.cmake:25` |
| `TARGET_SUPPORTS_SHARED_LIBS` | `FALSE` | `shared.toolchain.cmake:26` |
| `CMAKE_ASM_FLAGS_INIT` | `-x assembler-with-cpp` | `shared.toolchain.cmake:29` |
| `CMAKE_MODULE_PATH` | `modules/` (for platform discovery) | `shared.toolchain.cmake:17-19` |

## Function Differences

| Official | New                 | Official File | New File                     |
|----------|---------------------|---------------|------------------------------|
| `ogc_create_dol()` | `dkp_add_elf2dol()` | `Platform/libogc.cmake:22-35` | `../tools/dkp-elf2dol.cmake` |
| `dkp_add_embedded_binary_library()` | `dkp_add_bin2s()`   | `dkp-embedded-binary.cmake:7-46` | `../tools/dkp-bin2s.cmake`   |

## Toolchain Program Differences

| Program | Official | New                 | Official File | New File                       |
|---------|----------|---------------------|---------------|--------------------------------|
| `CMAKE_AR` | `${triplet}-gcc-ar` | `${triplet}-ar`     | `dkp-toolchain-common.cmake:57` | `devkitppc.toolchain.cmake:29` |
| `CMAKE_RANLIB` | `${triplet}-gcc-ranlib` | `${triplet}-ranlib` | `dkp-toolchain-common.cmake:58` | `devkitppc.toolchain.cmake:30` |

## Other Differences

| Feature                       | Official | This Package         |
|-------------------------------|----------|----------------------|
| Build Flag Overrides          |    `dkp-rule-overrides.cmake`      | None / Left to user  |
| Default `CMAKE_SYSTEM_NAME`   | `Generic-dkP` | `Generic`            |
| `find_program` error handling | No `REQUIRED` flag | Uses `REQUIRED` flag |
| `DKP_BUILD_TOOL_HOOK`         | Supported | Not supported        |
