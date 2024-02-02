#!/bin/bash

SOURCES=$(rpmbuild --eval="%{_sourcedir}")

# source dir is first arg, or defaults to current working directory
DIRECTORY=${1:-`pwd`}
BASENAME=$(basename $DIRECTORY)

# try to detect a .spec file in source dir
cd $DIRECTORY
NAMEDSPECS=(*$BASENAME.spec)

# extract name, version, source archive from .spec file
NAME=$BASENAME
VERSION=$(rpmspec -q --qf "%{version}" $NAMEDSPECS | tail -1)
ARCHIVE=$(rpmspec --srpm -q --qf "%{source}" $NAMEDSPECS)

# write the archive
mkdir -p $SOURCES
cd ..
tar \
  --exclude-vcs --exclude-vcs-ignore \
  --transform "s/${BASENAME}/${NAME}-${VERSION}/" \
  -cvaf $SOURCES/$ARCHIVE ${BASENAME}
