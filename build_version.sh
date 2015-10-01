#!/bin/sh

# Record the version of the source that we are compiling.
# We keep a record of the git revision in this file.  It is then built
# as a regular source file as part of the compilation process.
# One can run "strings executable_filename | grep _build_" to find
# the version of the source that we used to build the executable file.

date=$(date +%F)
git_sha=$(git describe HEAD 2>/dev/null)
echo '#include "build_version.h"' > util/build_version.cc
echo 'const char* rocksdb_build_git_sha = "rocksdb_build_git_sha:'$git_sha'";' >> util/build_version.cc
echo 'const char* rocksdb_build_git_date = "rocksdb_build_git_date:'$date'";' >> util/build_version.cc
echo "const char* rocksdb_build_compile_date = __DATE__;" >> util/build_version.cc
