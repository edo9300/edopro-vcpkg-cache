set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)

set(CMAKE_RANLIB /opt/cctools/bin/arm-apple-darwin11-ranlib)
set(CMAKE_AR /opt/cctools/bin/arm-apple-darwin11-ar)
set(VCPKG_OSX_SYSROOT /opt/cctools/sdk/iPhoneSimulator.sdk)
set(VCPKG_LINKER_FLAGS /opt/cctools/darwin/libclang_rt.iossim.a)

set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME iOS)
