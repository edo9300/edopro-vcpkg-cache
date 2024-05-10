vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libgit2/libgit2
    REF v1.8.0
    SHA512 e5634267bd9c6a594c9a954d09c657e7b8aadf213609bf7dd83b99863d0d0c7109a5277617dd508abc2da54ea3f12c2af1908d1aeb73c000e94056e2f3653144
    HEAD_REF main
    PATCHES
        c-standard.diff # for 'inline' in system headers
        cli-include-dirs.diff
        dependencies.diff
        mingw-winhttp.diff
        unofficial-config-export.diff
        cctools-libs.patch
        winxp-path.patch
        winxp-utf.patch
        winxp-wsapoll.patch
)
file(REMOVE_RECURSE
    "${SOURCE_PATH}/cmake/FindPCRE.cmake"
    "${SOURCE_PATH}/cmake/FindPCRE2.cmake"
    "${SOURCE_PATH}/deps/chromium-zlib"
    "${SOURCE_PATH}/deps/winhttp"
    "${SOURCE_PATH}/deps/zlib"
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" STATIC_CRT)

set(REGEX_BACKEND "builtin")
set(USE_HTTPS "OpenSSL")
set(USE_SSH ON)

if(NOT REGEX_BACKEND)
    message(FATAL_ERROR "Must choose pcre or pcre2 regex backend")
endif()

vcpkg_find_acquire_program(PKGCONFIG)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS GIT2_FEATURES
    FEATURES
        tools   BUILD_CLI
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS=OFF
        -DUSE_HTTP_PARSER=builtin
        -DUSE_HTTPS=${USE_HTTPS}
        -DREGEX_BACKEND=${REGEX_BACKEND}
        -DUSE_SSH=${USE_SSH}
        -DSTATIC_CRT=${STATIC_CRT}
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
        -DCMAKE_DISABLE_FIND_PACKAGE_GSSAPI:BOOL=ON
        -DUSE_WINHTTP=OFF
        ${GIT2_FEATURES}
    OPTIONS_DEBUG
        -DBUILD_CLI=OFF
    MAYBE_UNUSED_VARIABLES
        STATIC_CRT
        USE_WINHTTP
)

vcpkg_cmake_install()
vcpkg_fixup_pkgconfig()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/unofficial-git2-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-git2")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/unofficial-libgit2-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-libgit2")
vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-libgit2 CONFIG_PATH share/unofficial-libgit2)

if("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(TOOL_NAMES git2 AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

set(file_list "${SOURCE_PATH}/COPYING")
if(NOT VCPKG_TARGET_IS_WINDOWS)
    file(WRITE "${CURRENT_BUILDTREES_DIR}/Notice for ntlmclient" [[
Copyright (c) Edward Thomson.  All rights reserved.
These source files are part of ntlmclient, distributed under the MIT license.
]])
    list(APPEND file_list "${CURRENT_BUILDTREES_DIR}/Notice for ntlmclient")
endif()
vcpkg_install_copyright(FILE_LIST ${file_list})
