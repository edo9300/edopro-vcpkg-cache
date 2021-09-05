# libgit2 uses winapi functions not available in WindowsStore
vcpkg_fail_port_install(ON_TARGET "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libgit2/libgit2
    REF 4fd32be01c79a5c003bb47674ac1d76d948518b7#version 1.2.0
    SHA512 f9defe0dd51537ae374fe25ef3ccea74d8d05588f26b1865275067e63ad65a7cd283ee83099b97cea50ef5c367036734ba34be73a06b030be2903344b2778fff
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" STATIC_CRT)

if ("pcre" IN_LIST FEATURES)
    set(REGEX_BACKEND pcre)
elseif ("pcre2" IN_LIST FEATURES)
    set(REGEX_BACKEND pcre2)
else()
    set(REGEX_BACKEND builtin)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_CLAR=OFF
        -DREGEX_BACKEND=${REGEX_BACKEND}
        -DSTATIC_CRT=${STATIC_CRT}
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
