SET(CMAKE_SYSTEM_NAME iOS)

set(CMAKE_CXX_COMPILER /opt/cctools/bin/armv7-iphoneos-clang++)
set(CMAKE_C_COMPILER /opt/cctools/bin/armv7-iphoneos-clang)
set(CMAKE_OSX_ARCHITECTURES armv7)
set(CLANG_ARCH arm)
set(CMAKE_RANLIB /opt/cctools/bin/arm-apple-darwin11-ranlib)
set(CMAKE_AR /opt/cctools/bin/arm-apple-darwin11-ar)
set(CMAKE_INSTALL_NAME_TOOL /opt/cctools/bin/install_name_tool)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_MACOSX_RPATH TRUE)
set(VCPKG_LINKER_FLAGS /opt/cctools/darwin/libclang_rt.ios.a)
set(CMAKE_LIBRARY_PATH /opt/cctools/sdk/iPhoneOS.sdk/System/Library/)
set(CMAKE_SYSTEM_FRAMEWORK_PATH /opt/cctools/sdk/iPhoneOS.sdk/System/Library/Frameworks/)
set(CMAKE_OSX_SYSROOT /opt/cctools/sdk/iPhoneOS.sdk)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_SIZEOF_DATA_PTR 4)
set(CMAKE_CXX_SIZEOF_DATA_PTR 4)

set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".dylib")
set(CMAKE_SHARED_MODULE_PREFIX "lib")
set(CMAKE_SHARED_MODULE_SUFFIX ".so")
set(CMAKE_C_COMPILER_ABI ELF)
set(CMAKE_CXX_COMPILER_ABI ELF)
set(CMAKE_C_HAS_ISYSROOT 1)
set(CMAKE_CXX_HAS_ISYSROOT 1)
set(CMAKE_MODULE_EXISTS 1)
set(CMAKE_DL_LIBS "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ALWAYS)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
if(NOT _CMAKE_IN_TRY_COMPILE)
	string(APPEND CMAKE_C_FLAGS_INIT " -fPIC ")
	string(APPEND CMAKE_CXX_FLAGS_INIT " -fPIC ")

	set(CCTOOLS_LINKER_FLAGS /opt/cctools/darwin/libclang_rt.ios.a)

	string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_MODULE_LINKER_FLAGS_DEBUG_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_MODULE_LINKER_FLAGS_RELEASE_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT " ${CCTOOLS_LINKER_FLAGS} ")
	string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT " ${CCTOOLS_LINKER_FLAGS} ")
endif()