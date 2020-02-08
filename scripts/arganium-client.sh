#!/usr/bin/env bash
#
# This script executes the Zandronum program with a
# given level wad, game wad, and target system to connect to.

# Check if user needs help
if [ "$1" == '-h' ]; then
	echo "Usage:  arganium-client.sh [options]"
	echo "Options:"
	echo " -h:  this message"
	echo " No options:  interactive mode (default)"
	echo " [gamewad] [levelwad] [targethost]: automated mode"
	exit
fi

# If variables supplied, set appropriately
if [ "$#" -eq 3 ]; then
	GAMEWAD=$1
	LEVELWAD=$2
	TARGETHOST=$3

# If no variables supplied, interactive mode
elif [ "$#" -eq 0 ]; then
	echo 'Input path to game WAD: '
	read GAMEWAD

	echo 'Input path to level WAD: '
	read LEVELWAD

	echo 'Input target host: '
	read TARGETHOST

# Anything unexpected, exit
else
	echo 'Incorrect number of arguments specified.'
	exit
fi

# Execute
$(which zandronum) -iwad ${GAMEWAD} -file $(pwd)/../assets/arganium.pk3 ${LEVELWAD} +connect ${TARGETHOST}
