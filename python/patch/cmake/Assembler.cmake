# CMake ignores .S files, so we have to add compile commands for them manually
macro(add_assembler ADD_ASSEMBLER_OUTPUTVAR ADD_ASSEMBLER_FILE)
    get_filename_component(ADD_ASSEMBLER_PATH ${ADD_ASSEMBLER_FILE} PATH)
    get_filename_component(ADD_ASSEMBLER_NAME_WE ${ADD_ASSEMBLER_FILE} NAME_WE)

    if(WIN32)
        set(ADD_ASSEMBLER_EXT ".obj")
    else(WIN32)
        set(ADD_ASSEMBLER_EXT ".o")
    endif(WIN32)
    
    # We're going to create an .o file in the binary directory
    set(ADD_ASSEMBLER_OUTPUT "${CMAKE_BINARY_DIR}/${ADD_ASSEMBLER_PATH}/${ADD_ASSEMBLER_NAME_WE}${ADD_ASSEMBLER_EXT}")
    
    # Make sure the parent directory exists
    file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/${ADD_ASSEMBLER_PATH}/")

    # Build up a list of cflags to pass to gcc.
    # Start with the normal cmake ones.
    set(ADD_ASSEMBLER_CFLAGS ${CMAKE_C_FLAGS})
    separate_arguments(ADD_ASSEMBLER_CFLAGS)

    # Add -I flags for include directories that are set on this subdirectory.
    # Also take any additional directories passed to this function.
    get_directory_property(ADD_ASSEMBLER_INCLUDE_DIRS INCLUDE_DIRECTORIES)
    foreach(ADD_ASSEMBLER_INCLUDE_DIR ${ADD_ASSEMBLER_INCLUDE_DIRS} ${ARGN})
        list(APPEND ADD_ASSEMBLER_CFLAGS "-I${ADD_ASSEMBLER_INCLUDE_DIR}")
    endforeach(ADD_ASSEMBLER_INCLUDE_DIR)

    # Add the command to compile the assembler.
    if(WIN32)
        if(CMAKE_CL_64)
            set(ASSEMBLER_COMPILER "ml64")
        else(CMAKE_CL_64)
            set(ASSEMBLER_COMPILER "ml")
        endif(CMAKE_CL_64)
        add_custom_command(
            OUTPUT ${ADD_ASSEMBLER_OUTPUT}
            COMMAND ${ASSEMBLER_COMPILER}
                    /Fo ${ADD_ASSEMBLER_OUTPUT} 
                    /nologo /Zi 
                    /c ${CMAKE_SOURCE_DIR}/${ADD_ASSEMBLER_FILE}
            DEPENDS ${CMAKE_SOURCE_DIR}/${ADD_ASSEMBLER_FILE}
        )
    else(WIN32)
        add_custom_command(
            OUTPUT ${ADD_ASSEMBLER_OUTPUT}
            COMMAND ${CMAKE_C_COMPILER} ${ADD_ASSEMBLER_CFLAGS}
                    -c ${CMAKE_SOURCE_DIR}/${ADD_ASSEMBLER_FILE}
                    -o ${ADD_ASSEMBLER_OUTPUT}
            DEPENDS ${CMAKE_SOURCE_DIR}/${ADD_ASSEMBLER_FILE}
        )
    endif(WIN32)
    
    # Link this .obj in the target.
    list(APPEND ${ADD_ASSEMBLER_OUTPUTVAR} ${ADD_ASSEMBLER_OUTPUT})
endmacro(add_assembler)
