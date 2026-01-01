include_guard(GLOBAL)

# Set up devkitPro variable
if(NOT DEFINED DEVKITPRO)
    if(DEFINED ENV{DEVKITPRO})
        set(DEVKITPRO $ENV{DEVKITPRO})
        message(STATUS "Setting DEVKITPRO from environment: ${DEVKITPRO}")
    elseif(EXISTS "/opt/devkitpro")
        set(DEVKITPRO "/opt/devkitpro")
        message(STATUS "Setting DEVKITPRO to default location: ${DEVKITPRO}")
    endif()
endif()

if(NOT EXISTS ${DEVKITPRO})
    message(FATAL_ERROR "DEVKITPRO not found. Install to default location \"/opt/devkitpro\" or provide custom install location via DEVKITPRO environment variable or cmake variable.\nSee wiki for installation instructions: https://devkitpro.org/wiki/Getting_Started")
endif()

# Suppress "System is unknown to cmake" warning via "./modules/platform/..." files
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/modules")

# Use .elf extension for compiled binaries
set(CMAKE_EXECUTABLE_SUFFIX .elf)

# Disable shared library support
set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available")
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

# Set assembly to be preprocessed by GCC
string(APPEND CMAKE_ASM_FLAGS_INIT " -x assembler-with-cpp")
