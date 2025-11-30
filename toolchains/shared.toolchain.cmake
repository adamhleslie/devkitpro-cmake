include_guard(GLOBAL)

# Set up devkitPro variable
if(NOT DEFINED DEVKITPRO)
    if(DEFINED ENV{DEVKITPRO})
        set(DEVKITPRO $ENV{DEVKITPRO})
        message(STATUS "Setting DEVKITPRO from environment: ${DEVKITPRO}")
    elseif(EXISTS "/opt/devkitpro")
        set(DEVKITPRO "/opt/devkitpro")
        message(STATUS "Setting DEVKITPRO to default location: ${DEVKITPRO}")
    else()
        message(FATAL_ERROR "DEVKITPRO not valid: Default location \"/opt/devkitpro\" does not exist, and DEVKITPRO not set in environment")
    endif()
endif()

# Suppress "System is unknown to cmake" warning via "./modules/platform/..." files
list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_LIST_DIR}/modules"
)

# Use .elf extension for compiled binaries
set(CMAKE_EXECUTABLE_SUFFIX .elf)

# Disable shared library support
set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available")
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

# Set assembly to be compiled with CPP
string(APPEND CMAKE_ASM_FLAGS_INIT " -x assembler-with-cpp")
