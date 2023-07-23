vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kcat/openal-soft
    REF ${VERSION}
    SHA512 7384e734ba6b0668adbb2b2629c950bdb61814584a745ced2327cc20b1b9ff9bc53a8e10ec3260ef2a2915048f4e3af8499d91f8515bb18a4e61c5eeef609d1a
    HEAD_REF master
    PATCHES
      c12ada68951ea67a59bef7d4fcdf22334990c12a.patch # Merged upstream, remove in next version
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        pipewire  ALSOFT_BACKEND_PIPEWIRE
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(OPENAL_LIBTYPE "SHARED")
else()
    set(OPENAL_LIBTYPE "STATIC")
endif()

set(ALSOFT_REQUIRE_LINUX OFF)
set(ALSOFT_REQUIRE_WINDOWS OFF)
set(ALSOFT_REQUIRE_APPLE OFF)
set(ALSOFT_CPUEXT_NEON OFF)

if(VCPKG_TARGET_IS_LINUX)
    set(ALSOFT_REQUIRE_LINUX ON)
endif()
if(VCPKG_TARGET_IS_WINDOWS)
    set(ALSOFT_REQUIRE_WINDOWS ON)
endif()
if(VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_IOS)
    set(ALSOFT_REQUIRE_APPLE ON)
endif()
if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(ALSOFT_CPUEXT_NEON ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        -DLIBTYPE=${OPENAL_LIBTYPE}
        -DALSOFT_UTILS=OFF
        -DALSOFT_NO_CONFIG_UTIL=ON
        -DALSOFT_EXAMPLES=OFF
        -DALSOFT_CONFIG=OFF
        -DALSOFT_HRTF_DEFS=OFF
        -DALSOFT_AMBDEC_PRESETS=OFF
        -DALSOFT_BACKEND_ALSA=${ALSOFT_REQUIRE_LINUX}
        -DALSOFT_BACKEND_OSS=OFF
        -DALSOFT_BACKEND_SOLARIS=OFF
        -DALSOFT_BACKEND_SNDIO=OFF
        -DALSOFT_BACKEND_PORTAUDIO=OFF
        -DALSOFT_BACKEND_PULSEAUDIO=${ALSOFT_REQUIRE_LINUX}
        -DALSOFT_BACKEND_COREAUDIO=${ALSOFT_REQUIRE_APPLE}
        -DALSOFT_BACKEND_JACK=OFF
        -DALSOFT_BACKEND_OPENSL=${VCPKG_TARGET_IS_ANDROID}
        -DALSOFT_BACKEND_WAVE=ON
        -DALSOFT_BACKEND_WINMM=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_BACKEND_DSOUND=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_REQUIRE_WASAPI=${ALSOFT_REQUIRE_WINDOWS}
        -DALSOFT_CPUEXT_NEON=${ALSOFT_CPUEXT_NEON}
        -DCMAKE_DISABLE_FIND_PACKAGE_WindowsSDK=ON
    MAYBE_UNUSED_VARIABLES
        ALSOFT_AMBDEC_PRESETS
        ALSOFT_BACKEND_ALSA
        ALSOFT_BACKEND_COREAUDIO
        ALSOFT_BACKEND_JACK
        ALSOFT_BACKEND_OPENSL
        ALSOFT_BACKEND_OSS
        ALSOFT_BACKEND_PORTAUDIO
        ALSOFT_BACKEND_PIPEWIRE
        ALSOFT_BACKEND_PULSEAUDIO
        ALSOFT_BACKEND_SNDIO
        ALSOFT_BACKEND_SOLARIS
        ALSOFT_CONFIG
        ALSOFT_CPUEXT_NEON
        ALSOFT_HRTF_DEFS
        ALSOFT_BACKEND_WINMM
        ALSOFT_BACKEND_DSOUND
        CMAKE_DISABLE_FIND_PACKAGE_WindowsSDK
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/OpenAL")

foreach(HEADER al.h alc.h)
    file(READ "${CURRENT_PACKAGES_DIR}/include/AL/${HEADER}" AL_H)
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        string(REPLACE "defined(AL_LIBTYPE_STATIC)" "1" AL_H "${AL_H}")
    else()
        # Normally we would say:
        # string(REPLACE "defined(AL_LIBTYPE_STATIC)" "0" AL_H "${AL_H}")
        # but we are leaving these undefined macros alone in support of
        # https://github.com/microsoft/vcpkg/issues/18098
    endif()
    file(WRITE "${CURRENT_PACKAGES_DIR}/include/AL/${HEADER}" "${AL_H}")
endforeach()

vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

vcpkg_copy_pdbs()
