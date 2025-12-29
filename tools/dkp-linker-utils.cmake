include_guard(GLOBAL)
# OUT: dkp_target_generate_symbol_table function adds link options and POST_BUILD command to generate .map and .lst files

if(CMAKE_NM)
    # Adds link options and POST_BUILD command to generate .map and .lst files
    function(dkp_target_generate_symbol_table target)

        get_target_property(target_binary_dir ${target} BINARY_DIR)
        get_target_property(target_output_name ${target} OUTPUT_NAME)
        if(NOT target_output_name)
            set(target_output_name ${target})
        endif()

        # Use configure-time paths (not generator expressions) for Ninja compatibility
        cmake_path(APPEND map_file "${target_binary_dir}" "${target_output_name}.map")
        cmake_path(APPEND lst_file "${target_binary_dir}" "${target_output_name}.lst")

        # Linker generates the .map file (not tracked as byproduct by build system)
        target_link_options(${target} PRIVATE
                -Wl,-Map,${map_file}
        )
        
        # Ensure map file is cleaned
        set_target_properties(${target} PROPERTIES
                ADDITIONAL_CLEAN_FILES "${map_file}"
        )

        # POST_BUILD: nm generates the .lst file
        add_custom_command(
                TARGET ${target} POST_BUILD
                COMMAND ${CMAKE_NM} -CSn $<TARGET_FILE:${target}> > ${lst_file}
                BYPRODUCTS ${lst_file}
                COMMENT "Generating symbol table for ${target}"
        )

        # Log Target Info
        dkp_message(VERBOSE ${target})
        dkp_message(VERBOSE "    Map File: ${map_file}")
        dkp_message(VERBOSE "    Symbol Table: ${lst_file}")

    endfunction()
endif()