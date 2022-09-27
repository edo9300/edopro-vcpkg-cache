set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(CMAKE_CXX_COMPILER /opt/cctools/bin/x86_64-macosx-clang++)
set(CMAKE_C_COMPILER /opt/cctools/bin/x86_64-macosx-clang)
set(CLANG_ARCH x86_64)
set(CMAKE_RANLIB /opt/cctools/bin/x86_64-apple-darwin11-ranlib)
set(CMAKE_AR /opt/cctools/bin/x86_64-apple-darwin11-ar)
set(CMAKE_INSTALL_NAME_TOOL /opt/cctools/bin/x86_64-apple-darwin11-install_name_tool)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_MACOSX_RPATH TRUE)
set(CMAKE_EXE_LINKER_FLAGS /opt/cctools/darwin/libclang_rt.osx.a)
set(CMAKE_LIBRARY_PATH /opt/cctools/sdk/MacOSX12.1.sdk/System/Library/)
set(CMAKE_SYSTEM_FRAMEWORK_PATH /opt/cctools/sdk/MacOSX12.1.sdk/System/Library/Frameworks/)

set(VCPKG_CMAKE_SYSTEM_NAME Darwin)
set(VCPKG_OSX_ARCHITECTURES x86_64)

