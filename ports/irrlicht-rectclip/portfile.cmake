include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO edo9300/irrlicht1-8-4
    REF 2386fdcef9f9d401d3db88f7c84f233b9ed2226b
    SHA512 f036a972dda973e2803fb10e253f59b7e1344f0e7897e067d14b44af4de324fae87fea376aed2e0b85ea7cb423cc29b5af94dea7a63b1458548ebcc2c8c768dd   
    HEAD_REF 1.9-custom
)

# Copy CMakeLists.txt to the source, because Irrlicht does not have one.
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/LICENSE.txt DESTINATION ${SOURCE_PATH})

set(FAST_MATH FALSE)
if("fast-fpu" IN_LIST FEATURES)
    set(FAST_MATH TRUE)
endif()

set(BUILD_TOOLS FALSE)
if("tools" IN_LIST FEATURES)
    set(BUILD_TOOLS TRUE)
endif()

set(SHARED_LIB TRUE)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(SHARED_LIB FALSE)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS 
        -DIRR_SHARED_LIB=${SHARED_LIB} 
        -DIRR_FAST_MATH=${FAST_MATH}
        -DIRR_BUILD_TOOLS=${BUILD_TOOLS}
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(TARGET_PATH share/irrlicht)

if(BUILD_TOOLS)
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/irrlicht-rectclip/)
endif()

file(WRITE ${CURRENT_PACKAGES_DIR}/share/irrlicht-rectclip/irrlicht-config.cmake "include(\${CMAKE_CURRENT_LIST_DIR}/irrlicht-targets.cmake)")

vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(COPY ${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/irrlicht-rectclip)
endif()
# Post-build test for cmake libraries
vcpkg_test_cmake(PACKAGE_NAME irrlicht)

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
