include_guard(GLOBAL)
# OUT: dkp_add_elf2dol function adds a custom target for converting an executable elf file to a dol file

dkp_find_component_file(elf2dol DKP_ELF2DOL "tools/bin/elf2dol" "gamecube-tools")

if(devkitpro_elf2dol_FOUND)
    function(dkp_add_elf2dol target dol_file_name source_file default_build_target)

        cmake_path(APPEND dol_file ${CMAKE_CURRENT_BINARY_DIR} ${dol_file_name})

        add_custom_command(
            OUTPUT ${dol_file}
            DEPENDS ${source_file}
            COMMAND ${DKP_ELF2DOL} ${source_file} ${dol_file}
        )

        if(${default_build_target})
            add_custom_target(${target}
                ALL
                DEPENDS ${dol_file}
            )
        else()
            add_custom_target(${target}
                DEPENDS ${dol_file}
            )
        endif()

        # Log Target Info
        message(VERBOSE ${target})
        message(VERBOSE "    Source File: ${source_file}")
        message(VERBOSE "    .dol File: ${dol_file}")

    endfunction()
endif()
