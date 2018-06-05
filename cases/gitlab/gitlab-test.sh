#!/bin/bash

set -ex

usage () {
  echo "$0 jmx usersNum loopNum"
  echo "e.g. $0 createnewuser 10 10"
  echo "possible values"
  (cd ./gitlabScripts/script; ls;)
  exit 1
}

if [[ $# -ne "3" ]]; then
  usage
fi

jmx=$1
usersNum=$2
loopNum=$3

log_path=logs/$jmx.jtl
report_path=report/$jmx

rm -rf $log_path $report_path
jmeter -n -GusersNum=$usersNum -GloopNum=$loopNum -t gitlabScripts/script/$jmx.jmx -r -l $log_path -e -o $report_path

