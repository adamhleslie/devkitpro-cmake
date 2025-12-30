include_guard(GLOBAL)
# OUT: dkp::wii interface library providing compile and link options

block(SCOPE_FOR VARIABLES)
    add_library(dkp::wii INTERFACE IMPORTED)
    set(arch_flags "-mrvl" "-mcpu=750" "-meabi" "-mhard-float")
    set(definitions "GEKKO")
    target_compile_options(dkp::wii
        INTERFACE ${arch_flags}
    )
    target_link_options(dkp::wii
        INTERFACE ${arch_flags}
    )
    target_compile_definitions(dkp::wii
        INTERFACE ${definitions}
    )
endblock()
