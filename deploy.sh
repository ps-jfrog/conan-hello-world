#!/bin/sh

callBase()
{
    TIMESTAMP=$(date +%F_%T | tr ':' '-') 
    BUILDNAME="conan_hello_build"
    PROJECTKEY="cg-lab"
    DIRNAME="BaseWebGoat"
    VIRTUAL_REPO="cg-lab-conan-virtual"
    LOCAL_REPO="cg-lab-conan-default-local"
    SERVER="psazuse"

    echo "Base Script executed from: ${PWD} at $TIMESTAMP"

    #CLEAN UP
    #conan remove "openssl/1.1.1c" -c
    #conan remove "openssl/1.1.1c" -r=$VIRTUAL_REPO -c
    conan remove "conan_hello_build*/*" -r=$VIRTUAL_REPO -c
    conan remove "conan_hello_build*/*" -c
    conan cache clean

    #conan create openssl --build="openssl/1.1.1c"
    #conan upload "openssl/1.1.1c" -r=VIRTUAL_REPO -c


    conan create . --format=json --build="conan_hello_build/2.5" -r=$VIRTUAL_REPO > create_output.json
    conan upload "conan_hello_build/2.5" -r=$VIRTUAL_REPO -c

    # Create the buildInfo file.
    conan art:build-info create create_output.json $BUILDNAME $TIMESTAMP $LOCAL_REPO --server $SERVER --with-dependencies > somelib_build.json
    conan art:build-info upload somelib_build.json --server $SERVER --project $PROJECTKEY

}


echo "Script was called with $@"
if [[ "$1" == "base" ]]; then
    callBase
elif [[ "$1" == "dockerized" ]]; then
    callDockerized
else
    echo "Nothing here"
fi