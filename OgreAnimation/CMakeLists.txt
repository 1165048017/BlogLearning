cmake_minimum_required (VERSION 2.8)
project(LearnOgre)

# required for Ogre 1.11+
set(CMAKE_CXX_STANDARD 11)
##############

## [discover_ogre]
# specify which version and components you need
find_package(OGRE 1.12.4 REQUIRED COMPONENTS Bites RTShaderSystem)

# copy resource.cfg next to our binaries where OGRE looks for it
file(COPY ${OGRE_CONFIG_DIR}/resources.cfg DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${OGRE_CONFIG_DIR}/plugins.cfg DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

#link libzzip directory
link_directories(${DEPEND_DIR})

# add the source files as usual
add_executable(PlayAnim DirectControl.cpp)

#link libzzip library
target_link_libraries(PlayAnim OgreBites OgreRTShaderSystem)
