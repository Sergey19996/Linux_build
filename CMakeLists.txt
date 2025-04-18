cmake_minimum_required(VERSION 3.13)


project(BrickCrusher VERSION 1.0)

set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR})


#FREETYPE
#include_directories(${CMAKE_SOURCE_DIR}/Linking/include/freetype)
#include_directories(${CMAKE_SOURCE_DIR}/Linking/include)

#link_directories(${CMAKE_SOURCE_DIR}/Linking/lib/freetype)


# Находим библиотеки через vcpkg
#find_package(glfw3 REQUIRED)
#find_package(glm REQUIRED)
##find_package(OpenAL CONFIG REQUIRED)
#find_package(SndFile CONFIG REQUIRED)
find_package(glfw3 REQUIRED)
find_package(glm REQUIRED)
find_package(OpenAL REQUIRED)
#find_package(SndFile REQUIRED)
find_package(Freetype REQUIRED)


find_package(PkgConfig REQUIRED)
pkg_check_modules(SNDFILE REQUIRED sndfile)

message(STATUS "libsndfile include dirs: ${SNDFILE_INCLUDE_DIRS}")
message(STATUS "libsndfile libraries: ${SNDFILE_LIBRARIES}")




set(GLAD_SOURCE ${CMAKE_SOURCE_DIR}/Linking/lib/glad.c)


message(STATUS "Компилятор C++: ${CMAKE_CXX_COMPILER}")
message(STATUS "Компилятор C: ${CMAKE_C_COMPILER}")

configure_file(BrickConfig.h.in BrickConfig.h)

# Добавление всех .cpp файлов из подкаталогов
file(GLOB_RECURSE SOURCES
    src/*.cpp
    src/graphics/*.cpp
    src/graphics/algorithms/*.cpp
    src/graphics/Effects/*.cpp
    src/graphics/Level/*.cpp
    src/graphics/models/*.cpp
    src/graphics/rendering/*.cpp
    src/graphics/Text/*.cpp
    src/audio/*.cpp
)


add_executable(${PROJECT_NAME} ${SOURCES} ${GLAD_SOURCE})





# ==============================
#       DOWNLOAD ALL THE SUBMODULES
# ==============================
find_package(Git QUIET)

if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Опция: обновлять подмодули во время сборки
    option(GIT_SUBMODULE "Check submodules during build" ON)

    if(GIT_SUBMODULE)
        message(STATUS "Submodule update")
        execute_process(
            COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            RESULT_VARIABLE GIT_SUBMOD_RESULT
        )

        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
        endif()
    endif()
endif()




target_include_directories(${PROJECT_NAME}
 PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src
 PRIVATE ${SNDFILE_INCLUDE_DIRS}
 PUBLIC ${PROJECT_BINARY_DIR}
PUBLIC ${CMAKE_SOURCE_DIR}/Linking/include
PRIVATE /usr/include
PRIVATE ${FREETYPE_INCLUDE_DIRS} 
 )



target_link_libraries(${PROJECT_NAME}  PRIVATE glfw  OpenAL::OpenAL glm::glm freetype sndfile
PRIVATE ${SNDFILE_LIBRARIES})

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/BrickConfig.h" DESTINATION include)

include(InstallRequiredSystemLibraries)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Licence.txt")
set(CPACK_PACKAGE_VERSION_MAJOR "${TUTORIAL_cVERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${TUTORIAL_VERSION_MINOR}")
include(CPack)

