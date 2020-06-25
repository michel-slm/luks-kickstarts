#!/bin/bash

DEST=ks.cfg

print_usage () {
  echo Usage: $0 ksfile
  exit 1
}

if [[ $# -ne 1 ]] || [[ ! -f $1 ]];
then
  print_usage
fi

pushd $(dirname $0) >/dev/null
ksflatten -c $1 -o $DEST
ksvalidator $DEST
popd >/dev/null
