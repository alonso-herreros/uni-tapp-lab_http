#!/usr/bin/env bash

export HTTPD_ROOT="$(pwd)/httpd"
export LISTEN_PORT="9${UID: -3}"
export HOSTNAME=$HOSTNAME

