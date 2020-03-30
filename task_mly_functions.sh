#!/bin/bash

# task_mly_functions - Functions to handle monthly tasks.
#                      This file is part of BeastlyTasks.
# Copyright (C) 2020  Torsten Koschorrek
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

source $btpath/generic_functions.sh

# function get_task_mly_param
#          wrapper to get task_mly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested task_mly parameter
# return   echo: task_mly parameter
#          return 1: in case of error (get_config_item failed)
function get_task_mly_param() {
    local configfile=$1
    local task_mly_id=$2
    local task_mly_param=$3

    local task_mly_from_config=""

    task_mly_from_config=$(get_config_item $configfile "task_mly" $task_mly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_mly_from_config=${task_mly_from_config#task_mly=$task_mly_id;} | sed -e 's#\"##g'
	case "$task_mly_param" in
	    "description") $(get_element_from_config "$task_mly_from_config" 1) ;;
	    "label")       $(get_element_from_config "$task_mly_from_config" 2) ;;
	    "status")      $(get_element_from_config "$task_mly_from_config" 3) ;;
	esac
    fi
}

# function set_task_mly_param
#          wrapper to set task_mly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: task_mly parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_item failed)
function set_task_mly_param() {
    local configfile=$1
    local task_mly_id=$2
    local task_mly_param=$3
    local task_mly_newval=$4

    local task_mly_from_config=""

    task_mly_from_config=$(get_config_item $configfile "task_mly" $task_mly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_mly_from_config=${task_mly_from_config#task_mly=$task_mly_id;} | sed -e 's#\"##g'

	local task_mly_description=$(get_element_from_config "$task_mly_from_config" 1)
	local task_mly_label=$(get_element_from_config       "$task_mly_from_config" 2)
	local task_mly_status=$(get_element_from_config      "$task_mly_from_config" 3)

	case "$task_mly_param" in
	    "description") task_mly_description=$task_mly_newval ;;
	    "label")       task_mly_label=$task_mly_newval ;;
	    "status")      task_mly_status=$task_mly_newval ;;
	esac

	return $(set_config_task_mly $configfile $task_mly_id "$task_mly_description" $task_mly_label $task_mly_status)
    fi
}

# function get_task_mly
#          read task_mly value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted task_mly text
#          return 1: in case of error (get_config_item failed)
function get_task_mly() {
    local configfile=$1
    local task_mly_id=$2
    local format=$3

    local task_mly_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    task_mly_from_config=$(get_config_item $configfile "task_mly" $task_mly_id)
    if [ $? == 1 ]; then
	return 1
    else
	local task_mly_description=$(get_element_from_config "$task_mly_from_config" 1)
	local task_mly_label=$(get_element_from_config       "$task_mly_from_config" 2)
	local task_mly_status=$(get_element_from_config      "$task_mly_from_config" 3)

	local prio_text=""

	if [ "$format" == "table" ]; then
            if [ ${#task_mly_description} -gt $desc_width ]; then
		task_mly_description=${task_mly_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    printf "%s [%s]\n   -> label: %s\n   -> status: %s\n" "$task_mly_id" "$task_mly_description" "$task_mly_label" "$task_mly_status"
	else
	    desc_width=$(__calc_column_width "$task_mly_description" $LIST_DESC_WIDTH)
	    id_width=$(__calc_column_width "$task_mly_id" $ID_LENGTH)
	    printf "%-"$id_width"s %-"$desc_width"s %-7s %-6s" "$task_mly_id" "$task_mly_description" $task_mly_label $task_mly_status
	fi
    fi
}

# function list_tasks_mly
#          list all available tasks_mly as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of tasks_mly
#          return 1: in case of error (format parameter is not table or list)
function list_tasks_mly() {
    local configfile=$1
    local format=$2

    local tasks_mly_from_config=""
    local width="0"

    tasks_mly_from_config=$(list_config_items $configfile "task_mly")
    if [ "$format" == "list" ]; then
	printf "$tasks_mly_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local tasks_mly_table=""
	local tasks_mly_id=""

	tasks_mly_table=$COL_WHITE$(printf "%-"${ID_LENGTH}"s %-"${LIST_DESC_WIDTH}"s %-7s %-6s" "id" "description" "label" "status\n")
	table_width=$(($ID_LENGTH+$LIST_DESC_WIDTH+16))
	while [ $width -lt $table_width ]; do
            tasks_mly_table=$tasks_mly_table"-"
            width=$(($width+1))
	done
	tasks_mly_table=$tasks_mly_table$COL_DEFAULT"\n"

	for tasks_mly_id in $tasks_mly_from_config; do
	    tasks_mly_table=$tasks_mly_table$(get_task_mly $configfile $tasks_mly_id 'table')"\n"
	done
	printf "$tasks_mly_table"
	return 0
    fi
    return 1
}
