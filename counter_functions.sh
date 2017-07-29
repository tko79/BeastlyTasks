#!/bin/bash

# counter_functions - Functions to handle counter events.
#                     This file is part of BeastlyTasks.
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

# function get_counter_param
#          wrapper to get counter parameter (value, description, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested counter parameter
# return   echo: counter parameter
#          return 1: in case of error (get_config_counter failed)
function get_counter_param() {
    local configfile=$1
    local counter_id=$2
    local counter_param=$3

    local counter_from_config=""

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	counter_from_config=${counter_from_config#counter=$counter_id;} | sed -e 's/\"//g'
	case "$counter_param" in
	    "description") echo $counter_from_config | awk -F';' '{ print $1 }' ;;
	    "value")       echo $counter_from_config | awk -F';' '{ print $2 }' ;;
	    "threshold")   echo $counter_from_config | awk -F';' '{ print $3 }' ;;
	    "belabo")      echo $counter_from_config | awk -F';' '{ print $4 }' ;;
	    "txtgood")     echo $counter_from_config | awk -F';' '{ print $5 }' ;;
	    "txtequal")    echo $counter_from_config | awk -F';' '{ print $6 }' ;;
	    "txtbad")      echo $counter_from_config | awk -F';' '{ print $7 }' ;;
	esac
    fi
}

# function set_counter_param
#          wrapper to set counter parameter (value, description, ...)
# param    $1: config filename
#          $2: unique id
#          $3: counter parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_counter failed)
function set_counter_param() {
    local configfile=$1
    local counter_id=$2
    local counter_param=$3
    local counter_newval=$4

    local counter_from_config=""
    local retval=0

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	counter_from_config=${counter_from_config#counter=$counter_id;} | sed -e 's/\"//g'

	local counter_description=$(echo    $counter_from_config | awk -F';' '{ print $1 }')
	local counter_value=$(echo          $counter_from_config | awk -F';' '{ print $2 }')
	local counter_threshold=$(echo      $counter_from_config | awk -F';' '{ print $3 }')
	local counter_below_above=$(echo    $counter_from_config | awk -F';' '{ print $4 }')
	local counter_desc_good=$(echo      $counter_from_config | awk -F';' '{ print $5 }')
	local counter_desc_threshold=$(echo $counter_from_config | awk -F';' '{ print $6 }')
	local counter_desc_bad=$(echo       $counter_from_config | awk -F';' '{ print $7 }')

	case "$counter_param" in
	    "description") counter_description=$counter_newval ;;
	    "value")       counter_value=$counter_newval ;;
	    "threshold")   counter_threshold=$counter_newval ;;
	    "belabo")      counter_below_above=$counter_newval ;;
	    "txtgood")     counter_desc_good=$counter_newval ;;
	    "txtequal")    counter_desc_threshold=$counter_newval ;;
	    "txtbad")      counter_desc_bad=$counter_newval ;;
	esac

	retval=$(set_config_counter $configfile $counter_id "$counter_description" $counter_value $counter_threshold "$counter_below_above" "$counter_desc_good" "$counter_desc_threshold" "$counter_desc_bad")
	return $retval
    fi
}
