#!/bin/bash

# task_dly_functions - Functions to handle daily tasks.
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

# function get_task_dly_param
#          wrapper to get task_dly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested task_dly parameter
# return   echo: task_dly parameter
#          return 1: in case of error (get_config_task_dly failed)
function get_task_dly_param() {
    local configfile=$1
    local task_dly_id=$2
    local task_dly_param=$3

    local task_dly_from_config=""

    task_dly_from_config=$(get_config_task_dly $configfile $task_dly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_dly_from_config=${task_dly_from_config#task_dly=$task_dly_id;} | sed -e 's#\"##g'
	case "$task_dly_param" in
	    "description") echo $task_dly_from_config | awk -F';' '{ print $1 }' ;;
	    "label")       echo $task_dly_from_config | awk -F';' '{ print $2 }' ;;
	    "status")      echo $task_dly_from_config | awk -F';' '{ print $3 }' ;;
	esac
    fi
}

# function set_task_dly_param
#          wrapper to set task_dly parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: task_dly parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_task_dly failed)
function set_task_dly_param() {
    local configfile=$1
    local task_dly_id=$2
    local task_dly_param=$3
    local task_dly_newval=$4

    local task_dly_from_config=""

    task_dly_from_config=$(get_config_task_dly $configfile $task_dly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_dly_from_config=${task_dly_from_config#task_dly=$task_dly_id;} | sed -e 's#\"##g'

	local task_dly_description=$(echo $task_dly_from_config | awk -F';' '{ print $1 }')
	local task_dly_label=$(echo       $task_dly_from_config | awk -F';' '{ print $2 }')
	local task_dly_status=$(echo      $task_dly_from_config | awk -F';' '{ print $3 }')

	case "$task_dly_param" in
	    "description") task_dly_description=$task_dly_newval ;;
	    "label")       task_dly_label=$task_dly_newval ;;
	    "status")      task_dly_status=$task_dly_newval ;;
	esac

	return $(set_config_task_dly $configfile $task_dly_id "$task_dly_description" $task_dly_label $task_dly_status)
    fi
}

# function get_task_dly
#          read task_dly value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted task_dly text
#          return 1: in case of error (get_config_task_dly failed)
function get_task_dly() {
    local configfile=$1
    local task_dly_id=$2
    local format=$3

    local task_dly_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    task_dly_from_config=$(get_config_task_dly $configfile $task_dly_id)
    if [ $? == 1 ]; then
	return 1
    else
	local task_dly_description=$(echo $task_dly_from_config | awk -F';' '{ print $1 }')
	local task_dly_label=$(echo       $task_dly_from_config | awk -F';' '{ print $2 }')
	local task_dly_status=$(echo      $task_dly_from_config | awk -F';' '{ print $3 }')

	local prio_text=""

	if [ "$format" == "table" ]; then
            if [ ${#task_dly_description} -gt $desc_width ]; then
		task_dly_description=${task_dly_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    printf "%s [%s]\n   -> label: %s\n   -> status: %s\n" "$task_dly_id" "$task_dly_description" "$task_dly_label" "$task_dly_status"
	else
	    local dlb=$(echo $task_dly_description | wc -c)
	    local dlc=$(echo $task_dly_description | wc -m)
	    desc_width=$(($LIST_DESC_WIDTH+$dlb-$dlc))
	    printf "%-10s %-"$desc_width"s %-7s %-6s" $task_dly_id "$task_dly_description" $task_dly_label $task_dly_status
	fi
    fi
}

# function list_tasks_dly
#          list all available tasks_dly as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of tasks_dly
#          return 1: in case of error (format parameter is not table or list)
function list_tasks_dly() {
    local configfile=$1
    local format=$2

    local tasks_dly_from_config=""
    local width="0"

    tasks_dly_from_config=$(list_config_tasks_dly $configfile)
    if [ "$format" == "list" ]; then
	printf "$tasks_dly_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local tasks_dly_table=""
	local tasks_dly_id=""

	tasks_dly_table=$COL_WHITE$(printf "%-10s %-"${LIST_DESC_WIDTH}"s %-7s %-6s" "id" "description" "label" "status\n")
	tasks_dly_table=$tasks_dly_table"-----------------------------------------------------------"
	while [ $width -lt $LIST_DESC_WIDTH ]; do
            tasks_dly_table=$tasks_dly_table"-"
            width=$(($width+1))
	done
	tasks_dly_table=$tasks_dly_table$COL_DEFAULT"\n"

	for tasks_dly_id in $tasks_dly_from_config; do
	    tasks_dly_table=$tasks_dly_table$(get_tasks_dly $configfile $tasks_dly_id 'table')"\n"
	done
	printf "$tasks_dly_table"
	return 0
    fi
    return 1
}
