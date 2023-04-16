#!/bin/bash
if echo "$0" | grep -E -v "bash-debug|systemd" > /dev/null; then  cd "${0%/*}"  ;fi  # cd this file folder

PositionalArgs=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --transform-to-parent-git)     Options_TransformToParentGit="yes"; shift;;
        --transform-from-parent-git)   Options_TransformFromParentGit="yes"; shift;;
        --transform-to-without-git)    Options_TransformToWithoutGit="yes"; shift;;
        --transform-from-without-git)  Options_TransformFromWithoutGit="yes"; shift;;
        -*) echo "Unknown option $1"; exit 1;;
        *) PositionalArgs+=("$1"); shift;;
    esac
done
set -- "${PositionalArgs[@]}"  #// set $1, $2, ...
unset PositionalArgs

function  Main() {
    if [ "${Options_TransformToParentGit}" != "" ]; then
        TransformToParentGit
    elif [ "${Options_TransformFromParentGit}" != "" ]; then
        TransformFromParentGit
    elif [ "${Options_TransformToWithoutGit}" != "" ]; then
        TransformToWithoutGit
    elif [ "${Options_TransformFromWithoutGit}" != "" ]; then
        TransformFromWithoutGit
    else
        Error
    fi
}

function  TransformToParentGit() {
    AssertExist     "${HOME}/locommit"
    AssertNotExist  "${HOME}/_testing"
    AssertNotExist  "${HOME}/locommit_old"
    cd              "${HOME}"

    #// Copy to "~/locommit_old"
    cp -ap    "${HOME}/locommit"  "${HOME}/locommit_old"

    #// Make "_testing"
    mkdir -p  "${HOME}/_testing"
    mv        "${HOME}/locommit"  "${HOME}/_testing/locommit"
    rm -rf    "${HOME}/_testing/locommit/.git"

    cd        "${HOME}/_testing"
    git init  #// or git init in Ubuntu 20.04
    git add "."  #// This command must not show the warning about git submodule.
    git config --local user.email "you@example.com"  #// You can set any name because the setting will be deleted when the test is finished.
    git config --local user.name "Your Name"
    git commit -m "First commit for test."
}

function  TransformFromParentGit() {
    AssertNotExist  "${HOME}/locommit"
    cd      "${HOME}"

    #// Resume ".git"
    rm -rf  "${HOME}/_testing/.git"
    cp -ap  "${HOME}/locommit_old/.git"  "${HOME}/_testing/.git"

    #// Move to "~/locommit"
    mv  "${HOME}/_testing/locommit"  "${HOME}/locommit"
    rm -rf  "${HOME}/_testing"
    rm -rf  "${HOME}/locommit_old"
}

function  TransformToWithoutGit() {
    echo  "Not implemented yet"
}

function  TransformFromWithoutGit() {
    echo  "Not implemented yet"
}

function  AssertExist() {
    local  path="$1"
    local  leftOfWildcard="${path%\**}"
    if [ "${leftOfWildcard}" == "${path}" ]; then  #// No wildcard

        if [ ! -e "${path}" ]; then
            Error  "ERROR: Not found \"${path}\""
        fi
    else
        local  rightOfWildcard="${path##*\*}"
        if [ ! -e "${leftOfWildcard}"*"${rightOfWildcard}" ]; then
            Error  "ERROR: Not found \"${path}\""
        fi
    fi
}

function  AssertNotExist() {
    local  path="$1"

    if [ -e "${path}" ]; then
        Error  "ERROR: Found \"${path}\""
    fi
}

function  Error() {
    local  errorMessage="$1"
    local  exitCode="$2"
    if [ "${errorMessage}" == "" ]; then
        errorMessage="ERROR"
    fi
    if [ "${exitCode}" == "" ]; then  exitCode=2  ;fi

    echo  "${errorMessage}" >&2
    exit  "${exitCode}"
}

Main
