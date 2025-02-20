include_guard(GLOBAL)
# OUT: dkp_add_elf2dol function adds a custom target for converting an executable elf file to a dol file

dkp_find_file(DKP_ELF2DOL "tools/bin/elf2dol")

if(DKP_ELF2DOL)
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
        dkp_message(VERBOSE ${target})
        dkp_message(VERBOSE "    Source File: ${source_file}")
        dkp_message(VERBOSE "    .dol File: ${dol_file}")

    endfunction(dkp_add_elf2dol)
endif()
