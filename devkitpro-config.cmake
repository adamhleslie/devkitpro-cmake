cmake_minimum_required(VERSION 4.2.0)

include("${CMAKE_CURRENT_LIST_DIR}/dkp-helpers.cmake")

# Set up devkitPro variable
if(DEFINED DEVKITPRO)
    dkp_message(STATUS "Using existing DEVKITPRO value: ${DEVKITPRO}")
else()
    if(DEFINED ENV{DEVKITPRO})
        set(DEVKITPRO $ENV{DEVKITPRO})
        dkp_message(STATUS "Setting DEVKITPRO from environment: ${DEVKITPRO}")
    elseif(EXISTS "/opt/devkitpro")
        set(DEVKITPRO "/opt/devkitpro")
        dkp_message(STATUS "Setting DEVKITPRO to default location: ${DEVKITPRO}")
    endif()
endif()

if(NOT EXISTS ${DEVKITPRO})
    set(devkitpro_FOUND FALSE)
    set(devkitpro_NOT_FOUND_MESSAGE "DEVKITPRO not found. Install to default location \"/opt/devkitpro\" or provide custom install location via DEVKITPRO environment variable or cmake variable.\nSee wiki for installation instructions: https://devkitpro.org/wiki/Getting_Started")
    dkp_message(WARNING "DEVKITPRO not found. Install to default location \"/opt/devkitpro\" or provide custom install location via DEVKITPRO environment variable or cmake variable.\nSee wiki for installation instructions: https://devkitpro.org/wiki/Getting_Started")
    return()
endif()

# Find all files to include
file(GLOB_RECURSE include_files LIST_DIRECTORIES false
    "${CMAKE_CURRENT_LIST_DIR}/platforms/*.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/libraries/*.cmake"
    "${CMAKE_CURRENT_LIST_DIR}/tools/*.cmake"
)

foreach(include_file IN LISTS include_files)
    include(${include_file})
endforeach()

# Handle component requests
if(devkitpro_FIND_COMPONENTS)
    block(SCOPE_FOR VARIABLES PROPAGATE devkitpro_FOUND devkitpro_NOT_FOUND_MESSAGE)
        set(required_failed_components "")
        set(required_unsupported_components "")

        # Iterate over all requested components
        dkp_message(CHECK_START "Checking for components")
        list(APPEND CMAKE_MESSAGE_INDENT "  ")
        foreach(component ${devkitpro_FIND_COMPONENTS})
            dkp_message(CHECK_START "Checking ${component}")
            if(DEFINED devkitpro_${component}_FOUND)
                if(devkitpro_${component}_FOUND)
                    dkp_message(CHECK_PASS "Found")
                else()
                    dkp_message(CHECK_FAIL "Not Found")
                    if(devkitpro_FIND_REQUIRED_${component})
                        list(APPEND required_failed_components ${component})
                    endif()
                endif()
            else()
                dkp_message(CHECK_FAIL "Unsupported")
                if(devkitpro_FIND_REQUIRED_${component})
                    list(APPEND required_failed_components ${component})
                    list(APPEND required_unsupported_components ${component})
                endif()
            endif()
        endforeach()
        list(POP_BACK CMAKE_MESSAGE_INDENT)

        # Handle required components
        if(required_failed_components)
            dkp_message(CHECK_FAIL "Missing required components")
            set(devkitpro_FOUND FALSE)
            list(JOIN required_failed_components ", " required_missing_str)
            set(devkitpro_NOT_FOUND_MESSAGE "Failed to find required components: ${required_missing_str}")
            if(required_unsupported_components)
                list(JOIN required_unsupported_components ", " required_unsupported_str)
                string(APPEND devkitpro_NOT_FOUND_MESSAGE "\nRequired components not supported: ${required_unsupported_str}")
            endif()

            foreach(component ${required_failed_components})
                if(DEFINED devkitpro_${component}_NOT_FOUND_MESSAGE)
                    string(APPEND devkitpro_NOT_FOUND_MESSAGE "\n${component}: ${devkitpro_${component}_NOT_FOUND_MESSAGE}")
                endif()
            endforeach()
        else()
            dkp_message(CHECK_FAIL "Found required components")
            set(devkitpro_FOUND TRUE)
        endif()
    endblock()
endif()