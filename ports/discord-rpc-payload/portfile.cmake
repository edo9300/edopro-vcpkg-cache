# Barely modified from the original vcpkg discord-rpc portfile

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO edo9300/discord-rpc
    REF 1291afe7a7a466695e5db8c277c6c6d4ac9316a6
    SHA512 9f8163a18d4a70ebc403e6e3ac4b1f844f8a9506c1920cd02de3d5009e9ab7a7d4ab29b0153fcab1b293d1e3719938a484e9068fa89261c5bd6288c3f169963c
    HEAD_REF master
    PATCHES disable-downloading.patch
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" STATIC_CRT)
file(REMOVE_RECURSE ${SOURCE_PATH}/thirdparty)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DUSE_STATIC_CRT=${STATIC_CRT}
        -DBUILD_EXAMPLES=OFF
        -DRAPIDJSONTEST=TRUE
        -DRAPIDJSON=${CURRENT_INSTALLED_DIR}
)

if(EXISTS ${SOURCE_PATH}/thirdparty)
    message(FATAL_ERROR "The source directory should not be modified during the build.")
endif()

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Copy copyright information
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/discord-rpc-payload" RENAME "copyright")

vcpkg_copy_pdbs()
