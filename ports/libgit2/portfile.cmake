vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libgit2/libgit2
    REF v1.4.4
    SHA512 8f4cc43de9b92866ac12e01613efe0ff808deca29ff82b6da98a38c814bb711ff3133145d0219210af7015955fbe381be6f1cb98915811d3c37e92b01eb522e9
    HEAD_REF maint/v1.4
    PATCHES
        fix-configcmake.patch
        native_win_cert.patch
        winxp_path.patch
        winxp_utf.patch
)

file(REMOVE_RECURSE "${SOURCE_PATH}/cmake/FindPCRE.cmake")

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" STATIC_CRT)

set(REGEX_BACKEND OFF)
set(USE_HTTPS OFF)

function(set_regex_backend VALUE)
    if(REGEX_BACKEND)
        message(FATAL_ERROR "Only one regex backend (pcre,pcre2) is allowed")
    endif()
    set(REGEX_BACKEND ${VALUE} PARENT_SCOPE)
endfunction()

function(set_tls_backend VALUE)
    if(USE_HTTPS)
        message(FATAL_ERROR "Only one TLS backend (openssl,winhttp,sectransp,mbedtls) is allowed")
    endif()
    set(USE_HTTPS ${VALUE} PARENT_SCOPE)
endfunction()

set_regex_backend("builtin")
set_tls_backend("OpenSSL")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS=OFF
        -DUSE_WINHTTP=OFF
        -DUSE_HTTPS=${USE_HTTPS}
        -DREGEX_BACKEND=${REGEX_BACKEND}
        -DSTATIC_CRT=${STATIC_CRT}
        -DUSE_SSH=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-git2 CONFIG_PATH share/unofficial-git2)
# vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
