# Barely modified from the original vcpkg discord-rpc portfile

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO edo9300/discord-rpc
    REF 7fb7e2e9dc9ed48111a4dc41e8add0cc052144fe
    SHA512 24f8a6d824d40dc1bc410469b87b87e9b92062d1fd69994a8913650958060ae251901a049f939b9ad16b0eedc723fefe33dc834056e89b74fe6ee01571cdcab5
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
