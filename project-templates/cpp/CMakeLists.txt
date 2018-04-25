# Minimum version for target_compile_features
cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(REPLACETHIS VERSION 1.2.3 LANGUAGES CXX)

add_executable(${PROJECT_NAME} "src/main.cpp")
target_compile_features(${PROJECT_NAME} PRIVATE
	cxx_std_11
)
