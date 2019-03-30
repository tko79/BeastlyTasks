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
	counter_from_config=${counter_from_config#counter=$counter_id;} | sed -e 's#\"##g'
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

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	counter_from_config=${counter_from_config#counter=$counter_id;} | sed -e 's#\"##g'

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

	return $(set_config_counter $configfile $counter_id "$counter_description" $counter_value $counter_threshold "$counter_below_above" "$counter_desc_good" "$counter_desc_threshold" "$counter_desc_bad")
    fi
}

# function increment_counter
#          increment counter value
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (get_counter_param failed)
function increment_counter() {
    local configfile=$1
    local counter_id=$2

    local counter_val=0

    counter_val=$(get_counter_param $configfile $counter_id value)
    if [ $? == 1 ]; then
	return 1
    else
	counter_val=$(( $counter_val+1 ))
	$(set_counter_param $configfile $counter_id value $counter_val)
    fi
}

# function decrement_counter
#          decrement counter value
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (get_counter_param failed)
#          return 2: in case of negative value
function decrement_counter() {
    local configfile=$1
    local counter_id=$2

    local counter_val=0

    counter_val=$(get_counter_param $configfile $counter_id value)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	if [ $counter_val -eq 0 ]; then
	    return 2
	else
	    counter_val=$(( $counter_val-1 ))
	    $(set_counter_param $configfile $counter_id value $counter_val)
	fi
    fi
}

# function reset_counter
#          reset counter value to zero
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (get_config_counter failed)
function reset_counter() {
    local configfile=$1
    local counter_id=$2

    local counter_from_config=""

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	return 1
    else
	$(set_counter_param $configfile $counter_id value 0)
    fi
}

# function get_counter
#          read counter value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted counter text
#          return 1: in case of error (get_config_counter failed)
function get_counter() {
    local configfile=$1
    local counter_id=$2
    local format=$3

    local counter_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	return 1
    else
	local counter_description=$(echo    $counter_from_config | awk -F';' '{ print $1 }')
	local counter_value=$(echo          $counter_from_config | awk -F';' '{ print $2 }')
	local counter_threshold=$(echo      $counter_from_config | awk -F';' '{ print $3 }')
	local counter_below_above=$(echo    $counter_from_config | awk -F';' '{ print $4 }')
	local counter_desc_good=$(echo      $counter_from_config | awk -F';' '{ print $5 }')
	local counter_desc_threshold=$(echo $counter_from_config | awk -F';' '{ print $6 }')
	local counter_desc_bad=$(echo       $counter_from_config | awk -F';' '{ print $7 }')

	if [ "$format" == "table" ]; then
	    if [ ${#counter_description} -gt $desc_width ]; then
		counter_description=${counter_description:0:$desc_width}"..."
	    fi
	fi

	if [ $counter_value -lt $counter_threshold ]; then
	    if [ "$counter_below_above" == "below" ]; then
		counter_val_desc=$COL_GREEN$counter_desc_good$COL_DEFAULT
	    else
		counter_val_desc=$COL_RED$counter_desc_bad$COL_DEFAULT
	    fi
	fi
	if [ $counter_value -eq $counter_threshold ]; then
	    counter_val_desc=$COL_YELLOW$counter_desc_threshold$COL_DEFAULT
	fi
	if [ $counter_value -gt $counter_threshold ]; then
	    if [ "$counter_below_above" == "below" ]; then
		counter_val_desc=$COL_RED$counter_desc_bad$COL_DEFAULT
	    else
		counter_val_desc=$COL_GREEN$counter_desc_good$COL_DEFAULT
	    fi
	fi

	if [ "$format" == "single" ]; then
	    local moveass=$(($counter_threshold-$counter_value))
	    printf "%s [%s]\n   -> value=%d %s\n   -> good %s %d (%s to go)\n   -> good: %s\n   -> threshold: %s\n   -> bad: %s" $counter_id "$counter_description" $counter_value "$counter_val_desc" $counter_below_above $counter_threshold ${moveass#-} "$counter_desc_good" "$counter_desc_threshold" "$counter_desc_bad"
	else
	    local dlb=$(echo $counter_description | wc -c)
	    local dlc=$(echo $counter_description | wc -m)
	    desc_width=$(($LIST_DESC_WIDTH+$dlb-$dlc))
	    printf "%-"${ID_LENGTH}"s %-"$desc_width"s %4d %4d %s" "$counter_id" "$counter_description" $counter_value $counter_threshold "$counter_val_desc"
	fi
    fi
}

# function list_counters
#          list all available counters as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of counters
#          return 1: in case of error (format parameter is not table or list)
function list_counters() {
    local configfile=$1
    local format=$2

    local counters_from_config=""
    local width="0"

    counters_from_config=$(list_config_counters $configfile)
    if [ "$format" == "list" ]; then
	printf "$counters_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local counters_table=""
	local counter_id=""

	counters_table=$COL_WHITE$(printf "%-"${ID_LENGTH}"s %-"${LIST_DESC_WIDTH}"s %s %s %s" "id" "description" " val" " thr" "description\n")
	table_width=$(($ID_LENGTH+$LIST_DESC_WIDTH+39))
	while [ $width -lt $table_width ]; do
	    counters_table=$counters_table"-"
	    width=$(($width+1))
	done
	counters_table=$counters_table$COL_DEFAULT"\n"

	for counter_id in $counters_from_config; do
	    counters_table=$counters_table$(get_counter $configfile $counter_id 'table')"\n"
	done
	printf "$counters_table"
	return 0
    fi
    return 1
}
