cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(lab_06 VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(Boost_USE_STATIC_LIBS OFF)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")

find_package(Boost REQUIRED COMPONENTS system)
include_directories(${Boost_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})

file(GLOB APP_FILES
        src/beast.hpp
        src/http_session.cpp
        src/http_session.hpp
        src/listener.cpp
        src/listener.hpp
        src/main.cpp
        src/net.hpp
        src/shared_state.cpp
        src/shared_state.hpp
        )

add_executable(server ${APP_FILES})

add_subdirectory(libs/ozo/)
target_link_libraries(server PRIVATE yandex::ozo)

if (NOT WIN32)
    find_package(Threads)
    target_link_libraries(server PRIVATE Threads::Threads ${Boost_SYSTEM_LIBRARY})
endif ()
