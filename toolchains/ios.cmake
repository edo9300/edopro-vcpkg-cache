set(CMAKE_CXX_COMPILER /opt/cctools/bin/${CMAKE_OSX_ARCHITECTURES}-iphoneos-clang++)
set(CMAKE_C_COMPILER /opt/cctools/bin/${CMAKE_OSX_ARCHITECTURES}-iphoneos-clang)
set(CMAKE_RANLIB /opt/cctools/bin/arm-apple-darwin11-ranlib)
set(CMAKE_AR /opt/cctools/bin/arm-apple-darwin11-ar)
set(CMAKE_EXE_LINKER_FLAGS /opt/cctools/darwin/libclang_rt.ios.a)
set(CMAKE_OSX_SYSROOT /opt/cctools/sdk/iPhoneOS.sdk)

include("${CMAKE_CURRENT_LIST_DIR}/ios-base.cmake")
