cmake_minimum_required(VERSION 3.5.1)
project(Test)
set(CMAKE_LEGACY_CYGWIN_WIN32 0)
set(CMAKE_CXX_STANDARD 11)
find_package(Boost REQUIRED COMPONENTS
	program_options
    filesystem
    system
    thread
    date_time
    regex
    unit_test_framework
    timer
)
if(NOT Boost_FOUND)
    message("Not found Boost")
endif()

include_directories(${Boost_INCLUDE_DIRS})
message("${Boost_INCLUDE_DIRS}")
message("${Boost_LIBRARIES}")

add_executable(Test main.cpp)
target_link_libraries(Test ${Boost_LIBRARIES})