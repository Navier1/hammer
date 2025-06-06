message(STATUS "Configuring Address Sanitizer")

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND WIN32)
    set(CMAKE_C_FLAGS      "${CMAKE_C_FLAGS}      -fsanitize=address -fno-omit-frame-pointer")
    set(CMAKE_CXX_FLAGS    "${CMAKE_CXX_FLAGS}    -fsanitize=address -fno-omit-frame-pointer")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fsanitize=address")

    # Add required runtime library for Address Sanitizer on Windows
    # (needed for Clang on Windows)
    add_compile_options(-fsanitize=address)
    add_link_options(-fsanitize=address)
elseif(UNIX)
    set(CMAKE_C_FLAGS          "${CMAKE_C_FLAGS}          -fsanitize=address -fno-omit-frame-pointer")
    set(CMAKE_CXX_FLAGS        "${CMAKE_CXX_FLAGS}        -fsanitize=address -fno-omit-frame-pointer")
    set(CMAKE_LINKER_FLAGS     "${CMAKE_LINKER_FLAGS}     -fsanitize=address")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address")
else()
    message(WARNING "Address Sanitizer is not supported on this platform or compiler.")
endif()