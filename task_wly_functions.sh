#!/bin/bash

# task_wly_functions - Functions to handle weekly tasks.
#                      This file is part of BeastlyTasks.
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

source $btpath/generic_functions.sh

# function get_task_wly_param
#          wrapper to get task_wly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested task_wly parameter
# return   echo: task_wly parameter
#          return 1: in case of error (get_config_item failed)
function get_task_wly_param() {
    local configfile=$1
    local task_wly_id=$2
    local task_wly_param=$3

    local task_wly_from_config=""

    task_wly_from_config=$(get_config_item $configfile "task_wly" $task_wly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_wly_from_config=${task_wly_from_config#task_wly=$task_wly_id;} | sed -e 's#\"##g'
	case "$task_wly_param" in
	    "description") $(get_element_from_config "$task_wly_from_config" 1) ;;
	    "label")       $(get_element_from_config "$task_wly_from_config" 2) ;;
	    "status")      $(get_element_from_config "$task_wly_from_config" 3) ;;
	    "biweekly")    $(get_element_from_config "$task_wly_from_config" 4) ;;
	esac
    fi
}

# function set_task_wly_param
#          wrapper to set task_wly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: task_wly parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_item failed)
function set_task_wly_param() {
    local configfile=$1
    local task_wly_id=$2
    local task_wly_param=$3
    local task_wly_newval=$4

    local task_wly_from_config=""

    task_wly_from_config=$(get_config_item $configfile "task_wly" $task_wly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_wly_from_config=${task_wly_from_config#task_wly=$task_wly_id;} | sed -e 's#\"##g'

	local task_wly_description=$(get_element_from_config "$task_wly_from_config" 1)
	local task_wly_label=$(get_element_from_config       "$task_wly_from_config" 2)
	local task_wly_status=$(get_element_from_config      "$task_wly_from_config" 3)
	local task_wly_biweekly=$(get_element_from_config    "$task_wly_from_config" 4)

	case "$task_wly_param" in
	    "description") task_wly_description=$task_wly_newval ;;
	    "label")       task_wly_label=$task_wly_newval ;;
	    "status")      task_wly_status=$task_wly_newval ;;
	    "biweekly")    task_wly_biweekly=$task_wly_newval ;;
	esac

	return $(set_config_task_wly $configfile $task_wly_id "$task_wly_description" $task_wly_label $task_wly_status $task_wly_biweekly)
    fi
}

# function get_task_wly
#          read task_wly value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted task_wly text
#          return 1: in case of error (get_config_item failed)
function get_task_wly() {
    local configfile=$1
    local task_wly_id=$2
    local format=$3

    local task_wly_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    task_wly_from_config=$(get_config_item $configfile "task_wly" $task_wly_id)
    if [ $? == 1 ]; then
	return 1
    else
	local task_wly_description=$(get_element_from_config "$task_wly_from_config" 1)
	local task_wly_label=$(get_element_from_config       "$task_wly_from_config" 2)
	local task_wly_status=$(get_element_from_config      "$task_wly_from_config" 3)
	local task_wly_biweekly=$(get_element_from_config    "$task_wly_from_config" 4)

	if [ "$format" == "table" ]; then
            if [ ${#task_wly_description} -gt $desc_width ]; then
		task_wly_description=${task_wly_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    printf "%s [%s]\n   -> label: %s\n   -> status: %s\n   -> biweekly: %s\n" "$task_wly_id" "$task_wly_description" "$task_wly_label" "$task_wly_status" "$task_wly_biweekly"
	else
	    desc_width=$(__calc_column_width "$task_wly_description" $LIST_DESC_WIDTH)
	    id_width=$(__calc_column_width "$task_wly_id" $ID_LENGTH)
	    printf "%-"$id_width"s %-"$desc_width"s %-7s %-6s %3s" "$task_wly_id" "$task_wly_description" $task_wly_label $task_wly_status $task_wly_biweekly
	fi
    fi
}

# function list_tasks_wly
#          list all available tasks_wly as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of tasks_wly
#          return 1: in case of error (format parameter is not table or list)
function list_tasks_wly() {
    local configfile=$1
    local format=$2

    local tasks_wly_from_config=""
    local width="0"

    tasks_wly_from_config=$(list_config_items $configfile "task_wly")
    if [ "$format" == "list" ]; then
	printf "$tasks_wly_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local tasks_wly_table=""
	local tasks_wly_id=""

	tasks_wly_table=$COL_WHITE$(printf "%-"${ID_LENGTH}"s %-"${LIST_DESC_WIDTH}"s %-7s %-6s %8s" "id" "description" "label"  "status" "biweekly\n")
	table_width=$(($ID_LENGTH+$LIST_DESC_WIDTH+25))
	while [ $width -lt $table_width ]; do
            tasks_wly_table=$tasks_wly_table"-"
            width=$(($width+1))
	done
	tasks_wly_table=$tasks_wly_table$COL_DEFAULT"\n"

	for tasks_wly_id in $tasks_wly_from_config; do
	    tasks_wly_table=$tasks_wly_table$(get_task_wly $configfile $tasks_wly_id 'table')"\n"
	done
	printf "$tasks_wly_table"
	return 0
    fi
    return 1
}
