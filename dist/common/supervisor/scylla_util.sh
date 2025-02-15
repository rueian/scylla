#!/bin/bash

scylladir="$(readlink -f $(dirname "$0")/..)"

is_nonroot() {
    [ -f "$scylladir"/SCYLLA-NONROOT-FILE ]
}

is_privileged() {
    [ ${EUID:-${UID}} = 0 ]
}

execsudo() {
    if is_nonroot; then
        exec sudo -u scylla -g scylla "$@"
    else
        exec "$@"
    fi
}
scriptsdir="$scylladir/scripts"
# scylla_sysconfdir.py is compatible both on python and bash
. "$scriptsdir"/scylla_sysconfdir.py
if is_nonroot; then
    etcdir="$scylladir/etc"
    bindir="$scylladir/bin"
    sysconfdir="$scylladir/$SYSCONFDIR"
else
    etcdir="/etc"
    bindir="/usr/bin"
    sysconfdir="$SYSCONFDIR"
fi

