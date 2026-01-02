include_guard(GLOBAL)
# OUT: Various devkitPPC static libraries in the form dkp::ppc::X and package component of the form ppc-libX

function(dkp_ppc_pkgconfig_import pkgconfig_name package)
    set(target_name dkp::ppc::${pkgconfig_name})
    set(component_name ppc-lib${pkgconfig_name})
    dkp_message(CHECK_START "Importing ${component_name}")

    # Import with PkgConfig::${target_name} format
    cmake_pkg_config(
        IMPORT ${pkgconfig_name}
        QUIET
        NAME ${target_name}
        PREFIX "ppc"
        ${ARGN}
    )

    # If successfully imported, alias the target
    if(PKGCONFIG_${pkgconfig_name}_FOUND AND TARGET PkgConfig::${target_name})
        add_library(${target_name} INTERFACE IMPORTED)
        list(APPEND link_libraries PkgConfig::${target_name})

        # Extract Requires.private - Since we are linking static libraries, private should be treated as dependencies as well
        cmake_pkg_config(EXTRACT ${pkgconfig_name})
        set(requires_private ${CMAKE_PKG_CONFIG_REQUIRES_PRIVATE})

        # Attempt to link previously imported dependencies
        foreach(dependency ${requires_private})
            set(dependency_target PkgConfig::dkp::ppc::${dependency})
            if(TARGET ${dependency_target})
                list(APPEND link_libraries ${dependency_target})
            else()
                list(APPEND link_libraries_failed ${dependency})
            endif()
        endforeach()

        if(link_libraries_failed)
            list(JOIN link_libraries_failed ", " link_libraries_failed_str)
            dkp_message(CHECK_FAIL "Private dependency(s) not found: ${link_libraries_failed_str}")
            set(devkitpro_${component_name}_FOUND FALSE PARENT_SCOPE)
            set(devkitpro_${component_name}_NOT_FOUND_MESSAGE "Private dependency(s) not found: ${link_libraries_failed_str}" PARENT_SCOPE)
            return()
        endif()

        set_target_properties(${target_name} PROPERTIES INTERFACE_LINK_LIBRARIES "${link_libraries}")

        dkp_message(CHECK_PASS "Imported ${target_name}")
        set(devkitpro_${component_name}_FOUND TRUE PARENT_SCOPE)
    else()
        dkp_message(CHECK_FAIL "pkg-config file not found or import failed")
        set(devkitpro_${component_name}_FOUND FALSE PARENT_SCOPE)
        set(devkitpro_${component_name}_NOT_FOUND_MESSAGE "pkg-config file not found or import failed. This library is found in the package '${package}'. Please check your installation, or install via:\n     dkp-pacman -S ${package}" PARENT_SCOPE)
    endif()
endfunction()

dkp_message(STATUS "Importing devkitPPC libraries")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# Order matters: Dependencies need to be imported first in order to support the "Requires" pkg-config field
dkp_ppc_pkgconfig_import(ogg        "ppc-libogg")
dkp_ppc_pkgconfig_import(vorbisidec "ppc-libvorbisidec")

list(POP_BACK CMAKE_MESSAGE_INDENT)
dkp_message(STATUS "Importing devkitPPC libraries - Finished")

