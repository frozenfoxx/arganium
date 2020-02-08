#!/usr/bin/env bash

# Variables
APPDIR=${APPDIR:-'/app'}
CONFIG=${CONFIG:-''}
CONFIG_FILE=${CONFIG_FILE:-'/data/config.yml'}

# Functions

## Configure Gloom
config_gloom()
{
  cd ${APPDIR}/gloom
  ./setup
}

## Remove encoding on variables
decode_vars()
{
  if ! [[ -z ${CONFIG} ]]; then
    CONFIG=$(echo ${CONFIG:-''} | base64 -d)
  fi
}

## Launch Gloom webserver
launch_gloom()
{
  cd ${APPDIR}/gloom
  ./setup ${CONFIG_FILE}
  SECRET_KEY_BASE=$(rails secret) rails server -b 0.0.0.0
}

## Display usage information
usage()
{
  echo "Usage: [Environment Variables] entrypoint.sh [options]"
  echo "  Environment Variables:"
  echo "    APPDIR                 the base directory of the application (default: '/app')"
  echo "    CONFIG                 set file contents for Gloom configuration (NOTE: incompatible with CONFIG_FILE, must be base64 encoded)"
  echo "    CONFIG_FILE            specify a file for Gloom configuration (default: '/data/config.yml')"
  echo "  Options:"
  echo "    -h | --help            display this usage information"
  echo "    --appdir               the base directory of the application (override environment variable if present)"
  echo "    --config               set the file contents for Gloom configuration (override environment variable if present)"
  echo "    --config_file          specify a file for Gloom configuration (override environment variable if present)"
}

# Logic

## Argument parsing
while [[ ${#} > 0 ]]; do
  case $1 in
    --appdir )       APPDIR="$2"
                     ;;
    --config )       CONFIG="$2"
                     ;;
    --config_file )  CONFIG_FILE="$2"
                     ;;
    -h | --help )    usage
                     exit 0
  esac
  shift
done

decode_vars
launch_gloom
