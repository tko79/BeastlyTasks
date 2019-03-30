#!/bin/bash

# label_functions - Functions to handle labels.
#                   This file is part of BeastlyTasks.
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

# function get_label_param
#          wrapper to get label parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested label parameter
# return   echo: label parameter
#          return 1: in case of error (get_config_label failed)
function get_label_param() {
    local configfile=$1
    local label_id=$2
    local label_param=$3

    local label_from_config=""

    label_from_config=$(get_config_label $configfile $label_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	label_from_config=${label_from_config#label=$label_id;} | sed -e 's#\"##g'
	case "$label_param" in
	    "description") echo $label_from_config | awk -F';' '{ print $1 }' ;;
	    "color")       echo $label_from_config | awk -F';' '{ print $2 }' ;;
	esac
    fi
}

# function set_label_param
#          wrapper to set label parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: label parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_label failed)
function set_label_param() {
    local configfile=$1
    local label_id=$2
    local label_param=$3
    local label_newval=$4

    local label_from_config=""

    label_from_config=$(get_config_label $configfile $label_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	label_from_config=${label_from_config#label=$label_id;} | sed -e 's#\"##g'

	local label_description=$(echo $label_from_config | awk -F';' '{ print $1 }')
	local label_color=$(echo       $label_from_config | awk -F';' '{ print $2 }')

	case "$label_param" in
	    "description") label_description=$label_newval ;;
	    "color")       label_color=$label_newval ;;
	esac

	return $(set_config_label $configfile $label_id "$label_description" $label_color)
    fi
}

# function get_label
#          read label value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted label text
#          return 1: in case of error (get_config_label failed)
function get_label() {
    local configfile=$1
    local label_id=$2
    local format=$3

    local label_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    label_from_config=$(get_config_label $configfile $label_id)
    if [ $? == 1 ]; then
	return 1
    else
	local label_description=$(echo $label_from_config | awk -F';' '{ print $1 }')
	local label_color=$(echo       $label_from_config | awk -F';' '{ print $2 }')

	if [ "$format" == "table" ]; then
            if [ ${#label_description} -gt $desc_width ]; then
		label_description=${label_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    printf "%s [%s]\n   -> color: %s" "$label_id" "$label_description" "$label_color"
	else
	    local dlb=$(echo $label_description | wc -c)
	    local dlc=$(echo $label_description | wc -m)
	    desc_width=$(($LIST_DESC_WIDTH+$dlb-$dlc))
	    printf "%-"${ID_LENGTH}"s %-"$desc_width"s %s" $label_id "$label_description" $label_color
	fi
    fi
}

# function list_labels
#          list all available label entries as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of label
#          return 1: in case of error (format parameter is not table or list)
function list_labels() {
    local configfile=$1
    local format=$2

    local label_from_config=""
    local width="0"

    label_from_config=$(list_config_labels $configfile)
    if [ "$format" == "list" ]; then
	printf "$label_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local label_table=""
	local label_id=""

	label_table=$COL_WHITE$(printf "%-"${ID_LENGTH}"s %-"${LIST_DESC_WIDTH}"s %s" "id" "description" "label\n")
	table_width=$(($ID_LENGTH+$LIST_DESC_WIDTH+8))
	while [ $width -lt $table_width ]; do
            label_table=$label_table"-"
            width=$(($width+1))
	done
	label_table=$label_table$COL_DEFAULT"\n"

	for label_id in $label_from_config; do
	    label_table=$label_table$(get_label $configfile $label_id 'table')"\n"
	done
	printf "$label_table"
	return 0
    fi
    return 1
}
