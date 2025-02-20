include_guard(GLOBAL)

# devkitPPC toolchain file
include("${CMAKE_CURRENT_LIST_DIR}/devkitppc.toolchain.cmake")

# Override devkitPPC's system name
set(CMAKE_SYSTEM_NAME "NintendoWii")

# Add Wii specific find_... function paths
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
        "${DEVKITPRO}/portlibs/wii"
)

# Find pkg-config specific to Wii
find_program(PKG_CONFIG_EXECUTABLE "powerpc-eabi-pkg-config" HINTS "${DEVKITPRO}/portlibs/wii/bin" REQUIRED)