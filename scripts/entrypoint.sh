#!/usr/bin/env bash

# Variables
APPDIR=${APPDIR:-"/app"}
CONFIG=${CONFIG:-''}
CONFIG_FILE=${CONFIG_FILE:-"/data/configs/config.yml"}
DOOMWADDIR=${DOOMWADDIR:-"/data/wads"}
MODE=${MODE:-'server'}

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
  echo "    CONFIG_FILE            specify a file for Gloom configuration (default: '/data/configs/config.yml')"
  echo "    DOOMWADDIR             directory containing WAD files for Zandronum (default: '/data/wads')"
  echo "    MODE                   specify a file for Gloom configuration (default: '/data/configs/config.yml')"
  echo "  Options:"
  echo "    -h | --help            display this usage information"
  echo "    --appdir               the base directory of the application (override environment variable if present)"
  echo "    --config               set the file contents for Gloom configuration (override environment variable if present)"
  echo "    --config_file          specify a file for Gloom configuration (override environment variable if present)"
  echo "    --mode                 set the runmode (override environment variable if present)"
  echo "  Modes:"
  echo "    setup                  run the configurator"
  echo "    server                 run the Gloom server (default if not specified)"
}

# Logic

## Argument parsing
while [[ ${#} > 0 ]]; do
  case $1 in
    --appdir )       APPDIR="$2"
                     shift
                     ;;
    --config )       CONFIG="$2"
                     shift
                     ;;
    --config_file )  CONFIG_FILE="$2"
                     shift
                     ;;
    --mode )         MODE="$2"
                     shift
                     ;;
    -h | --help )    usage
                     exit 0
                     ;;
  esac
  shift
done

## Decode base64 variables
decode_vars

## Check execution mode
case "${MODE}" in
  setup )  config_gloom
           ;;
  server ) launch_gloom
           ;;
  * )      usage
           exit 1
           ;;
esac
