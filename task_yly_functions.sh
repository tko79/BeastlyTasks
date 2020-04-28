#!/bin/bash

# task_yly_functions - Functions to handle yearly tasks.
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

# function get_task_yly_param
#          wrapper to get task_yly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested task_yly parameter
# return   echo: task_yly parameter
#          return 1: in case of error (get_config_item failed)
function get_task_yly_param() {
    local configfile=$1
    local task_yly_id=$2
    local task_yly_param=$3

    local task_yly_from_config=""

    task_yly_from_config=$(get_config_item $configfile "task_yly" $task_yly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_yly_from_config=${task_yly_from_config#task_yly=$task_yly_id;} | sed -e 's#\"##g'
	case "$task_yly_param" in
	    "description") $(get_element_from_config "$task_yly_from_config" 1) ;;
	    "label")       $(get_element_from_config "$task_yly_from_config" 2) ;;
	    "status")      $(get_element_from_config "$task_yly_from_config" 3) ;;
	    "duedate")     $(get_element_from_config "$task_yly_from_config" 4) ;;
	esac
    fi
}

# function set_task_yly_param
#          wrapper to set task_yly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: task_yly parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_item failed)
function set_task_yly_param() {
    local configfile=$1
    local task_yly_id=$2
    local task_yly_param=$3
    local task_yly_newval=$4

    local task_yly_from_config=""

    task_yly_from_config=$(get_config_item $configfile "task_yly" $task_yly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_yly_from_config=${task_yly_from_config#task_yly=$task_yly_id;} | sed -e 's#\"##g'

	local task_yly_description=$(get_element_from_config "$task_yly_from_config" 1)
	local task_yly_label=$(get_element_from_config       "$task_yly_from_config" 2)
	local task_yly_status=$(get_element_from_config      "$task_yly_from_config" 3)
	local task_yly_duedate=$(get_element_from_config     "$task_yly_from_config" 4)

	case "$task_yly_param" in
	    "description") task_yly_description=$task_yly_newval ;;
	    "label")       task_yly_label=$task_yly_newval ;;
	    "status")      task_yly_status=$task_yly_newval ;;
	    "duedate")     task_yly_duedate=$task_yly_newval ;;
	esac

	return $(set_config_task_yly $configfile $task_yly_id "$task_yly_description" $task_yly_label $task_yly_status $task_yly_duedate)
    fi
}

# function get_task_yly
#          read task_yly value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted task_yly text
#          return 1: in case of error (get_config_item failed)
function get_task_yly() {
    local configfile=$1
    local task_yly_id=$2
    local format=$3

    local task_yly_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    task_yly_from_config=$(get_config_item $configfile "task_yly" $task_yly_id)
    if [ $? == 1 ]; then
	return 1
    else
	local task_yly_description=$(get_element_from_config "$task_yly_from_config" 1)
	local task_yly_label=$(get_element_from_config       "$task_yly_from_config" 2)
	local task_yly_status=$(get_element_from_config      "$task_yly_from_config" 3)
	local task_yly_duedate=$(get_element_from_config     "$task_yly_from_config" 4)

	local prio_text=""

	if [ "$format" == "table" ]; then
            if [ ${#task_yly_description} -gt $desc_width ]; then
		task_yly_description=${task_yly_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    printf "%s [%s]\n   -> label: %s\n   -> status: %s\n   -> duedate: %s\n" "$task_yly_id" "$task_yly_description" "$task_yly_label" "$task_yly_status" "$task_yly_duedate"
	else
	    desc_width=$(__calc_column_width "$task_yly_description" $LIST_DESC_WIDTH)
	    id_width=$(__calc_column_width "$task_yly_id" $ID_LENGTH)
	    printf "%-"$id_width"s %-"$desc_width"s %-7s %-6s %5s" "$task_yly_id" "$task_yly_description" $task_yly_label $task_yly_status $task_yly_duedate
	fi
    fi
}

# function list_tasks_yly
#          list all available tasks_yly as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of tasks_yly
#          return 1: in case of error (format parameter is not table or list)
function list_tasks_yly() {
    local configfile=$1
    local format=$2

    local tasks_yly_from_config=""
    local width="0"

    tasks_yly_from_config=$(list_config_items $configfile "task_yly")
    if [ "$format" == "list" ]; then
	printf "$tasks_yly_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local tasks_yly_table=""
	local tasks_yly_id=""

	tasks_yly_table=$COL_WHITE$(printf "%-"${ID_LENGTH}"s %-"${LIST_DESC_WIDTH}"s %-7s %-6s %8s" "id" "description" "label"  "status" "duedate\n")
	table_width=$(($ID_LENGTH+$LIST_DESC_WIDTH+24))
	while [ $width -lt $table_width ]; do
            tasks_yly_table=$tasks_yly_table"-"
            width=$(($width+1))
	done
	tasks_yly_table=$tasks_yly_table$COL_DEFAULT"\n"

	for tasks_yly_id in $tasks_yly_from_config; do
	    tasks_yly_table=$tasks_yly_table$(get_task_yly $configfile $tasks_yly_id 'table')"\n"
	done
	printf "$tasks_yly_table"
	return 0
    fi
    return 1
}
