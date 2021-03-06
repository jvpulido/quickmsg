#
# A CMake Module for using C# .NET.
#
# The following variables are set:
#   (none)
#
# This file is based on the work of GDCM:
#   http://gdcm.svn.sf.net/viewvc/gdcm/trunk/CMake/UseDotNETFrameworkSDK.cmake
# Copyright (c) 2006-2010 Mathieu Malaterre <mathieu.malaterre@gmail.com>
#

message( STATUS "Using .NET compiler version ${CSHARP_DOTNET_VERSION}" )

# Define the location of the .NET libraries
set( CSHARP_LIBRARY_PATH "${CMAKE_CURRENT_BINARY_DIR}" CACHE PATH "")