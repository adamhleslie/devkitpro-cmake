include_guard(GLOBAL)
# OUT: devkitpro_add_gxtexconv function adds a interface library for converting .scf files and their associated textures into .tpl files
#      DEVKITPRO_GXTEXCONV_TPL_FILES property on target set to the list of generated .tpl files

devkitpro_find_file(DEVKITPRO_GXTEXCONV "tools/bin/gxtexconv")

if(DEVKITPRO_GXTEXCONV)
    define_property(
            TARGET
            PROPERTY DEVKITPRO_GXTEXCONV_TPL_FILES
            BRIEF_DOCS "List of TPL files generated for a gxtexconv target"
    )

    # Generates tpl and header files from scf files and their dependencies, maintaining the original directory structure
    # If scf_files are relative, they are evaluated based on scf_files_dir
    # If scf_files are absolute, they must be under scf_files_dir
    # If scf_files_dir is relative, CMAKE_CURRENT_SOURCE_DIR will be used as its base directory
    # If out_dir is relative, CMAKE_CURRENT_BINARY_DIR will be used as its base directory
    function(devkitpro_add_gxtexconv target scf_files scf_files_dir out_dir)

        devkitpro_make_absolute_if_relative(scf_files_dir ${CMAKE_CURRENT_SOURCE_DIR})
        devkitpro_make_absolute_if_relative(out_dir ${CMAKE_CURRENT_BINARY_DIR})

        # Add a command to process each file with gxtexconv
        foreach(scf_file IN LISTS scf_files)

            devkitpro_get_relative_and_absolute(${scf_file} ${scf_files_dir} scf_file_relative scf_file_absolute)

            # Compute output files
            cmake_path(APPEND out_file_base ${out_dir} ${scf_file_relative})
            cmake_path(REPLACE_EXTENSION out_file_base ".h" OUTPUT_VARIABLE out_file_h)
            cmake_path(REPLACE_EXTENSION out_file_base ".tpl" OUTPUT_VARIABLE out_file_tpl)
            cmake_path(REPLACE_EXTENSION out_file_base ".d" OUTPUT_VARIABLE out_file_dep)

            # Create target directory
            cmake_path(GET out_file_base PARENT_PATH out_file_path)
            file(MAKE_DIRECTORY ${out_file_path})

            # Append to files list
            list(APPEND out_files_h ${out_file_h})
            list(APPEND out_files_tpl ${out_file_tpl})

            # Create gxtexconv command
            add_custom_command(
                    OUTPUT ${out_file_h} ${out_file_tpl} ${out_file_dep}
                    DEPENDS ${out_file_tpl} # Self-dependency to cause re-checking of DEPFILE for command
                    DEPFILE ${out_file_dep}
                    COMMAND ${DEVKITPRO_GXTEXCONV} ARGS -s ${scf_file_absolute} -o ${out_file_tpl} -d ${out_file_dep}
            )

        endforeach(scf_file)

        # Custom target for file generation
        set(target_custom "${target}_custom")
        add_custom_target(${target_custom}
                DEPENDS ${out_files_h} ${out_files_tpl} ${out_file_dep}
                SOURCES ${scf_files}
        )

        # Interface target for include dependency
        add_library(${target} INTERFACE)
        target_include_directories(${target}
                INTERFACE ${out_dir}
        )
        target_sources(${target}
                INTERFACE
                FILE_SET gxtexconv
                TYPE HEADERS
                BASE_DIRS ${out_dir}
                FILES ${out_files_h}
        )
        set_target_properties(${target} PROPERTIES
                DEVKITPRO_GXTEXCONV_TPL_FILES "${out_files_tpl}"
        )
        add_dependencies(${target} ${target_custom})

        # Log Target Info
        devkitpro_message(VERBOSE ${target})
        get_target_property(include_dirs ${target} INTERFACE_INCLUDE_DIRECTORIES)
        devkitpro_message(VERBOSE "    Include Dirs: ${include_dirs}")
        get_target_property(hfiles ${target} HEADER_SET_gxtexconv)
        devkitpro_message(VERBOSE "    Headers: ${hfiles}")
        get_target_property(tplfiles ${target} DEVKITPRO_GXTEXCONV_TPL_FILES)
        devkitpro_message(VERBOSE "    TPLs: ${tplfiles}")

    endfunction(devkitpro_add_gxtexconv)
endif()
