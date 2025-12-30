include_guard(GLOBAL)
# OUT: dkp::gamecube interface library providing compile and link options

block(SCOPE_FOR VARIABLES)
    add_library(dkp::gamecube INTERFACE IMPORTED)
    set(arch_flags "-mogc" "-mcpu=750" "-meabi" "-mhard-float")
    set(definitions "GEKKO")
    target_compile_options(dkp::gamecube
        INTERFACE ${arch_flags}
    )
    target_link_options(dkp::gamecube
        INTERFACE ${arch_flags}
    )
    target_compile_definitions(dkp::gamecube
        INTERFACE ${definitions}
    )
endblock()
