#!/bin/bash

# config_functions - Functions to set/get configuration items.
#                    This file is part of BeastlyTasks.
# Copyright (C) 2017  Torsten Koschorrek
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# function check_configfile
#          check if a config file exists
# param    $1: config filename
# return   return 1: in case of file does not exist
function check_configfile() {
    local configfile=$1

    if [ ! -e "$configfile" ]; then
	return 1
    fi
}

# function create_configfile
#          creates an empty config file
# param    $1: config filename
#          $2: username
# return   <none>
function create_configfile() {
    local configfile=$1
    local user=$2

    touch $configfile
    chown $user: $configfile
}

# function get_config_name
#          read username from config
# param    $1: config filename
# return   echo: name
#          return 1: in case of error
function get_config_name() {
    local configfile=$1
    local name=""

    name=$(grep "name=" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo $(echo $name | awk -F= '{ print $2 }')
    fi
}

# function set_config_name
#          write username to config
# param    $1: config filename
#          $2: name
# return   <none>
function set_config_name() {
    local configfile=$1
    local name=$2

    echo "name="$name >> $configfile
}
