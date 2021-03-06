#!/bin/sh

# This script preps the jquery-require-sample for distribution.

# Make the dist directory
rm -rf dist
mkdir dist
mkdir dist/jquery-require-sample
cd dist/jquery-require-sample

# Copy the sample files.
cp -r ../../webapp ./webapp

# Do a build of requirejs, using the minimum feature set and place it in scripts dir
cd ../../../../build/require
./build.sh
cp build/nomodifypluginspagecontext-require.js ../../docs/jquery-require-sample/dist/jquery-require-sample/webapp/scripts/require.js
rm -rf build/
cd ../../docs/jquery-require-sample/dist/jquery-require-sample

# Copy over the build system for requirejs and basic require files, used by the build.
mkdir requirejs
mkdir requirejs/build
cp -r ../../../../build/jslib requirejs/build/jslib
cp -r ../../../../build/lib requirejs/build/lib
cp ../../../../build/example.build.js requirejs/build/example.build.js
# Windows thing not working yet.
# cp ../../../../build/build.bat requirejs/build/build.bat
cp ../../../../build/build.js requirejs/build/build.js
cp ../../../../build/build.sh requirejs/build/build.sh

cp ../../../../require.js requirejs/
cp -r ../../../../require requirejs/require
cp ../../../../LICENSE requirejs/LICENSE

# Change path to require in the build script.
cat webapp/scripts/app.build.js | sed 's/requireUrl\:[^\,]*/requireUrl: "..\/..\/requirejs\/require.js"/' > webapp/scripts/app.build.js2
rm webapp/scripts/app.build.js
mv webapp/scripts/app.build.js2 webapp/scripts/app.build.js

# Start the build.
cd webapp/scripts
../../requirejs/build/build.sh app.build.js
cd ../../..

# Mac weirdness
find . -name .DS_Store -exec rm {} \;

# Package it.
zip -r jquery-require-sample.zip jquery-require-sample/*
