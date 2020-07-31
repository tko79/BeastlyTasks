#!/bin/bash

# task_functions - Functions to handle tasks.
#                  This file is part of BeastlyTasks.
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

# function create_task_image
#          create a task image with parameters for name, start date, end date
#          and impo marker.
# param    $1: task name
#          $2: start date (calender week)
#          $3: end date (calender week)
#          $4: impo marker {impo} (optional)
# return   <none>
function create_task_image() {
    name=$1
    start=$2
    end=$3
    impo=$4

    local template_red=$btpath"/images/task_template_red.png"
    local template_done=$btpath"/images/task_template_done.png"
    local template_impo=$btpath"/images/task_template_impo.png"
    local outfile="/tmp/out.png"

    convert $template_red -gravity Center -pointsize 20 -fill white \
	-draw "text 0,-13 '"$name"'" \
	-draw "text -60,20 '"$start"'" \
	-draw "text 60,20 '"$end"'" \
	$outfile

    if [ "$impo" == "impo" ]; then
	composite -gravity center $template_impo $outfile $outfile
    fi
    if [ "$end" != "open" ]; then
	composite -gravity center $template_done $outfile $outfile
    fi
}

# function get_task_param
#          wrapper to get task parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested task parameter
# return   echo: task parameter
#          return 1: in case of error (get_config_item failed)
function get_task_param() {
    local configfile=$1
    local task_id=$2
    local task_param=$3

    local task_from_config=""

    task_from_config=$(get_config_item $configfile "task" $task_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_from_config=${task_from_config#task=$task_id;} | sed -e 's#\"##g'
	case "$task_param" in
	    "description") $(get_element_from_config "$task_from_config" 1) ;;
	    "label")       $(get_element_from_config "$task_from_config" 2) ;;
	    "priority")    $(get_element_from_config "$task_from_config" 3) ;;
	    "status")      $(get_element_from_config "$task_from_config" 4) ;;
	    "createdate")  $(get_element_from_config "$task_from_config" 5) ;;
	    "duedate")     $(get_element_from_config "$task_from_config" 6) ;;
	    "donedate")    $(get_element_from_config "$task_from_config" 7) ;;
	esac
    fi
}

# function set_task_param
#          wrapper to set task parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: task parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_item failed)
#          return 2: in case of error (wrong create-/due-/donedate format)
function set_task_param() {
    local configfile=$1
    local task_id=$2
    local task_param=$3
    local task_newval=$4

    local task_from_config=""

    task_from_config=$(get_config_item $configfile "task" $task_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	task_from_config=${task_from_config#task=$task_id;} | sed -e 's#\"##g'

	local task_description=$(get_element_from_config "$task_from_config" 1)
	local task_label=$(get_element_from_config       "$task_from_config" 2)
	local task_priority=$(get_element_from_config    "$task_from_config" 3)
	local task_status=$(get_element_from_config      "$task_from_config" 4)
	local task_createdate=$(get_element_from_config  "$task_from_config" 5)
	local task_duedate=$(get_element_from_config     "$task_from_config" 6)
	local task_donedate=$(get_element_from_config    "$task_from_config" 7)

	case "$task_param" in
	    "createdate" | "duedate" | "donedate")
		if [[ ! $task_newval == [0-9][0-9]"/"[0-9][0-9] ]]; then
		    return 2
		fi
	    ;;
	esac

	case "$task_param" in
	    "description") task_description=$task_newval ;;
	    "label")       task_label=$task_newval ;;
	    "priority")    task_priority=$task_newval ;;
	    "status")      task_status=$task_newval ;;
	    "createdate")  task_createdate=$task_newval ;;
	    "duedate")     task_duedate=$task_newval ;;
	    "donedate")    task_donedate=$task_newval ;;
	esac

	return $(set_config_task $configfile $task_id "$task_description" $task_label $task_priority $task_status $task_createdate $task_duedate $task_donedate)
    fi
}

# function get_task
#          read task value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted task text
#          return 1: in case of error (get_config_item failed)
function get_task() {
    local configfile=$1
    local task_id=$2
    local format=$3

    local task_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    task_from_config=$(get_config_item $configfile "task" $task_id)
    if [ $? == 1 ]; then
	return 1
    else
	local task_description=$(get_element_from_config "$task_from_config" 1)
	local task_label=$(get_element_from_config       "$task_from_config" 2)
	local task_priority=$(get_element_from_config    "$task_from_config" 3)
	local task_status=$(get_element_from_config      "$task_from_config" 4)
	local task_createdate=$(get_element_from_config  "$task_from_config" 5)
	local task_duedate=$(get_element_from_config     "$task_from_config" 6)
	local task_donedate=$(get_element_from_config    "$task_from_config" 7)

	local prio_text=""

	if [ "$format" == "table" ]; then
            if [ ${#task_description} -gt $desc_width ]; then
		task_description=${task_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    case $task_priority in
		0) prio_text="0 - undefined" ;;
		1) prio_text="1 - nice to have" ;;
		2) prio_text="2 - normal" ;;
		3) prio_text="3 - important" ;;
		4) prio_text="4 - move ass" ;;
		5) prio_text="5 - blocking" ;;
	    esac
	    printf "%s [%s]\n   -> label: %s\n   -> priority: %s\n   -> status: %s\n   -> create-/due-/donedate: %s %s %s" "$task_id" "$task_description" "$task_label" "$prio_text" "$task_status" "$task_createdate" "$task_duedate" "$task_donedate"
	else
	    desc_width=$(__calc_column_width "$task_description" $LIST_DESC_WIDTH)
	    id_width=$(__calc_column_width "$task_id" $ID_LENGTH)
	    case $task_priority in
		0) prio_text="0" ;;
		1) prio_text="1 *" ;;
		2) prio_text="2 **" ;;
		3) prio_text="3 ***" ;;
		4) prio_text="4 ****" ;;
		5) prio_text="5 *****" ;;
	    esac
	    printf "%-"$id_width"s %-"$desc_width"s %-7s %-8s %-6s %-7s %-7s %-7s" "$task_id" "$task_description" $task_label "$prio_text" $task_status $task_createdate $task_duedate $task_donedate
	fi
    fi
}

# function list_tasks
#          list all available tasks as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of tasks
#          return 1: in case of error (format parameter is not table or list)
function list_tasks() {
    local configfile=$1
    local format=$2

    local tasks_from_config=""
    local width="0"

    tasks_from_config=$(list_config_items $configfile "task")
    if [ "$format" == "list" ]; then
	printf "$tasks_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local tasks_table=""
	local task_id=""

	tasks_table=$COL_WHITE$(printf "%-"${ID_LENGTH}"s %-"${LIST_DESC_WIDTH}"s %-7s %-8s %-6s %-7s %-7s %-6s" "id" "description" "label" "priority" "status" "created" "due" "done\n")
	table_width=$(($ID_LENGTH+$LIST_DESC_WIDTH+47))
	while [ $width -lt $table_width ]; do
            tasks_table=$tasks_table"-"
            width=$(($width+1))
	done
	tasks_table=$tasks_table$COL_DEFAULT"\n"

	for task_id in $tasks_from_config; do
	    tasks_table=$tasks_table$(get_task $configfile $task_id 'table')"\n"
	done
	printf "$tasks_table"
	return 0
    fi
    return 1
}
