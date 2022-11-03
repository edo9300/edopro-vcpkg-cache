include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO edo9300/irrlicht1-8-4
    REF 3bac1d89d72e57757008046dd2f853de9699ed4b
    SHA512 742ffd1c56ac2d55fcb4c712c93a817bc307b896574d9cf5726e975e39a1824b8c7b8347d7771cf5c3a041aa78f20d6fadb5f08b15dab70c6a9b82848a562250   
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
