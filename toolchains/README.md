# Compatibility
Toolchain Differences:
* No setting of CMAKE_MODULE_PATH, CMAKE_TRY_COMPILE_PLATFORM_VARIABLES, CMAKE_FIND_PACKAGE_PREFER_CONFIG, CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH variables
* No addition of standard system environment variables to CMAKE_SYSTEM_PROGRAM_PATH - not needed without CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH being set
* No setting of
    * DKP_BIN2S - use package config's DKP_BIN2S + dkp_add_bin2s
* Variable changes: DKP_OBJCOPY -> CMAKE_OBJCOPY, DKP_NM -> CMAKE_NM
* New variable: CMAKE_OBJDUMP
* No language flag overrides or compiler output extension overrides from dkp-rule-overrides.cmake - these are good options but not required for the platforms
    * CMAKE\_\${lang}\_OUTPUT_EXTENSION, CMAKE\_\${lang}\_OUTPUT\_EXTENSION\_REPLACE, CMAKE\_\${lang}\_FLAGS\_DEBUG\_INIT, CMAKE\_\${lang}\_FLAGS\_MINSIZEREL\_INIT, CMAKE\_\${lang}\_FLAGS\_RELEASE\_INIT, CMAKE\_\${lang}\_FLAGS\_RELWITHDEBINFO\_INIT
* No setting of DKP_INSTALL_PREFIX_INIT
* Gamecube
    * No setting of OGC_... variables - Use Package Config's libogc targets
    * No setting of
        * ELF2DOL_EXE - use Package Config's DKP_ELF2DOL + dkp_add_elf2dol
        * GXTEXCONV_EXE - use Package Config's DKP_GXTEXCONV + dkp_add_gxtexconv
        * GCDSPTOOL_EXE - TODO