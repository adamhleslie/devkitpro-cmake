include_guard(GLOBAL)
# OUT: dkp_add_bin2s function adds an object library for converting binary files to object files

dkp_find_file(DKP_BIN2S "tools/bin/bin2s")

if(DKP_BIN2S)
    # Generates assembly and header files from binary files, maintaining the original directory structure
    # Extensions in binary file names are appended to the generated file names with an underscore
    # - texture.tpl -> texture_tpl.h / texture_tpl.s
    # If binary_files are relative, they are evaluated based on binary_files_dir
    # If binary_files are absolute, they must be under binary_files_dir
    # If binary_files_dir is relative, CMAKE_CURRENT_SOURCE_DIR will be used as its base directory
    # If out_dir is relative, CMAKE_CURRENT_BINARY_DIR will be used as its base directory
    # Optional: extra argument will be used as the BIN2S alignment, and if not provided, DKP_BIN2S_ALIGNMENT or the default value of 4
    function(dkp_add_bin2s target binary_files binary_files_dir out_dir #[[optional: alignment]])

        dkp_make_absolute_if_relative(binary_files_dir ${CMAKE_CURRENT_SOURCE_DIR})
        dkp_make_absolute_if_relative(out_dir ${CMAKE_CURRENT_BINARY_DIR})

        # Try get alignment from optional argument ARGV4 or DKP_BIN2S_ALIGNMENT
        if(ARGC GREATER 4)
            set(alignment ${ARGV4})
        elseif(DEFINED DKP_BIN2S_ALIGNMENT)
            set(alignment ${DKP_BIN2S_ALIGNMENT})
        else()
            set(alignment 4)
        endif()

        # Add a command to process each file with bin2s
        foreach(binary_file IN LISTS binary_files)

            dkp_get_relative_and_absolute(${binary_file} ${binary_files_dir} binary_file_relative binary_file_absolute)

            # Compute output files
            cmake_path(HAS_EXTENSION binary_file binary_file_has_extension)
            if(${binary_file_has_extension})
                cmake_path(GET binary_file EXTENSION binary_file_extension)
                string(REPLACE "." "_" out_file_suffix ${binary_file_extension})
                cmake_path(REMOVE_EXTENSION binary_file_relative OUTPUT_VARIABLE binary_file_relative_extensionless)
                cmake_path(APPEND out_file_base ${out_dir} "${binary_file_relative_extensionless}${out_file_suffix}")
            else()
                cmake_path(APPEND out_file_base ${out_dir} ${binary_file_relative})
            endif()

            cmake_path(REPLACE_EXTENSION out_file_base ".h" OUTPUT_VARIABLE out_file_h)
            cmake_path(REPLACE_EXTENSION out_file_base ".s" OUTPUT_VARIABLE out_file_s)

            # Create target directory
            cmake_path(GET out_file_base PARENT_PATH out_file_path)
            file(MAKE_DIRECTORY ${out_file_path})

            # Append to files list
            list(APPEND out_files_h ${out_file_h})
            list(APPEND out_files_s ${out_file_s})

            # Create bin2s command
            add_custom_command(
                    OUTPUT ${out_file_h} ${out_file_s}
                    DEPENDS ${binary_file_absolute}
                    COMMAND ${DKP_BIN2S} ARGS -a ${alignment} -H ${out_file_h} ${binary_file_absolute} > ${out_file_s}
            )

        endforeach(binary_file)

        add_library(${target} OBJECT ${out_files_s})
        target_include_directories(${target}
                INTERFACE ${out_dir}
        )
        target_sources(${target}
                INTERFACE
                FILE_SET bin2s
                TYPE HEADERS
                BASE_DIRS ${out_dir}
                FILES ${out_files_h}
        )

        # Log Target Info
        dkp_message(VERBOSE ${target})
        get_target_property(include_dirs ${target} INTERFACE_INCLUDE_DIRECTORIES)
        dkp_message(VERBOSE "    Include Dirs: ${include_dirs}")
        get_target_property(hfiles ${target} HEADER_SET_bin2s)
        dkp_message(VERBOSE "    Headers: ${hfiles}")
        get_target_property(sfiles ${target} SOURCES)
        dkp_message(VERBOSE "    Sources: ${sfiles}")

    endfunction(dkp_add_bin2s)
endif()
