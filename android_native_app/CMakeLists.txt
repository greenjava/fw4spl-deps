cmake_minimum_required(VERSION 2.8)

project(android_native_app)

include_directories(
  ${ANDROID_NDK}/platforms/android-${ANDROID_NATIVE_API_LEVEL}/arch-${ANDROID_ARCH_NAME}/usr/include
  ${ANDROID_NDK}/sources/android/native_app_glue
)

add_library(android_native_app STATIC 
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c
)

add_custom_command(TARGET android_native_app 
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.h 
                                                  ${CMAKE_INSTALL_PREFIX}/include/android_native_app_glue.h
)

