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
#          return 1: in case of error (no name entry found)
function get_config_name() {
    local configfile=$1
    local name=""

    name=$(grep "name=" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${name#name=} | sed -e 's/\"//g'
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
    local name_from_config=""

    name_from_config=$(get_config_name $configfile)
    if [ $? == 1 ]; then
	echo "name=\""$name"\"" >> $configfile
    else
	sed -i "s/name=\"${name_from_config}\"/name=\"${name}\"/g" $configfile
    fi
}

# function list_config_counters
#          get counters from config
# param    $1: config filename
# return   echo counters from config
function list_config_counters() {
    local configfile=$1
    local counters_from_config=""

    counters_from_config=$(grep "counter=" $configfile | awk -F';' '{ print $1 }' | awk -F'=' '{ print $2 }')
    echo $counters_from_config
}

# function add_config_counter
#          add counter to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: start value
#          $5: threshold
#          $6: below or above is bad? (format: {below|above})
#          $7: text, when counter is good
#          $8: text, when counter equals threshold value
#          $9: text, when counter is bad
# return   return 1: in case of error (counter id already existing)
function add_config_counter() {
    local configfile=$1
    local counter_id=$2
    local counter_description=$3
    local counter_value=$4
    local counter_threshold=$5
    local counter_below_above=$6
    local counter_desc_good=$7
    local counter_desc_threshold=$8
    local counter_desc_bad=$9
    local counter_from_config=""

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	echo "counter=$counter_id;\"$counter_description;$counter_value;$counter_threshold;$counter_below_above;$counter_desc_good;$counter_desc_threshold;$counter_desc_bad\"" >> $configfile
    else
	return 1
    fi
}

# function del_config_counter
#          delete counter from config
# param    $1: config filename
#          $2: unique id
# return   <none>
function del_config_counter() {
    local configfile=$1
    local counter_id=$2

    sed -i "/counter=$counter_id;/d" $configfile
}

# function get_config_counter
#          get counter from config
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (counter id not found)
function get_config_counter() {
    local configfile=$1
    local counter_id=$2
    local counter_from_config=""

    counter_from_config=$(grep "counter=$counter_id;" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${counter_from_config#counter=$counter_id;} | sed -e 's/\"//g'
    fi
}

# function set_config_counter
#          set counter to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: value
#          $5: threshold
#          $6: below or above is bad? (format: {below|above})
#          $7: text, when counter is good
#          $8: text, when counter equals threshold value
#          $9: text, when counter is bad
# return   return 1: in case of error (counter id not found)
function set_config_counter() {
    local configfile=$1
    local counter_id=$2
    local counter_description=$3
    local counter_value=$4
    local counter_threshold=$5
    local counter_below_above=$6
    local counter_desc_good=$7
    local counter_desc_threshold=$8
    local counter_desc_bad=$9
    local counter_from_config=""

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	sed -i "s/counter=$counter_id;\"${counter_from_config}\"/counter=$counter_id;\"$counter_description;$counter_value;$counter_threshold;$counter_below_above;$counter_desc_good;$counter_desc_threshold;$counter_desc_bad\"/g" $configfile
    fi
}

# function list_config_timers
#          get timers from config
# param    $1: config filename
# return   echo timers from config
function list_config_timers() {
    local configfile=$1
    local timers_from_config=""

    timers_from_config=$(grep "timer=" $configfile | awk -F';' '{ print $1 }' | awk -F'=' '{ print $2 }')
    echo $timers_from_config
}

# function add_config_timer
#          add timer to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: start value
# return   return 1: in case of error (timer id already existing)
function add_config_timer() {
    local configfile=$1
    local timer_id=$2
    local timer_description=$3
    local timer_value=$4
    local timer_from_config=""

    timer_from_config=$(get_config_timer $configfile $timer_id)
    if [ $? == 1 ]; then
	echo "timer=$timer_id;\"$timer_description;$timer_value\"" >> $configfile
    else
	return 1
    fi
}

# function del_config_timer
#          delete timer from config
# param    $1: config filename
#          $2: unique id
# return   <none>
function del_config_timer() {
    local configfile=$1
    local timer_id=$2

    sed -i "/timer=$timer_id;/d" $configfile
}

# function get_config_timer
#          get timer from config
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (timer id not found)
function get_config_timer() {
    local configfile=$1
    local timer_id=$2
    local timer_from_config=""

    timer_from_config=$(grep "timer=$timer_id;" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${timer_from_config#timer=$timer_id;} | sed -e 's/\"//g'
    fi
}

# function set_config_timer
#          set timer to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: value
# return   return 1: in case of error (timer id not found)
function set_config_timer() {
    local configfile=$1
    local timer_id=$2
    local timer_description=$3
    local timer_value=$4
    local timer_from_config=""

    timer_from_config=$(get_config_timer $configfile $timer_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	sed -i "s/timer=$timer_id;\"${timer_from_config}\"/timer=$timer_id;\"$timer_description;$timer_value\"/g" $configfile
    fi
}

# function list_config_tasks
#          get tasks from config
# param    $1: config filename
# return   echo tasks from config
function list_config_tasks() {
    local configfile=$1
    local tasks_from_config=""

    tasks_from_config=$(grep "task=" $configfile | awk -F';' '{ print $1 }' | awk -F'=' '{ print $2 }')
    echo $tasks_from_config
}

# function add_config_task
#          add task to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: status {open|done}
#          $6: create date (format dd.mm.yyyy)
#          $7: due date (format dd.mm.yyyy)
#          $8: done date (format dd.mm.yyyy)
# return   return 1: in case of error (task id already existing)
#          return 2: in case of error (task status not open or done)
function add_config_task() {
    local configfile=$1
    local task_id=$2
    local task_description=$3
    local task_label=$4
    local task_status=$5
    local task_createdate=$6
    local task_duedate=$7
    local task_donedate=$8
    local task_from_config=""

    if [ ! "$task_status" == "open" ] && [ ! "$task_status" == "done" ]; then
	echo ""
	return 2
    fi

    task_from_config=$(get_config_task $configfile $task_id)
    if [ $? == 1 ]; then
	echo "task=$task_id;\"$task_description;$task_label;$task_status;$task_createdate;$task_duedate;$task_donedate\"" >> $configfile
    else
	return 1
    fi
}

# function del_config_task
#          delete task from config
# param    $1: config filename
#          $2: unique id
# return   <none>
function del_config_task() {
    local configfile=$1
    local task_id=$2

    sed -i "/task=$task_id;/d" $configfile
}

# function get_config_task
#          get task from config
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (task id not found)
function get_config_task() {
    local configfile=$1
    local task_id=$2
    local task_from_config=""

    task_from_config=$(grep "task=$task_id;" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${task_from_config#task=$task_id;} | sed -e 's/\"//g'
    fi
}

# function set_config_task
#          set task to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: status {open|done}
#          $6: create date (format dd.mm.yyyy)
#          $7: due date (format dd.mm.yyyy)
#          $8: done date (format dd.mm.yyyy)
# return   return 1: in case of error (task id not found)
#          return 2: in case of error (task status not open or done)
function set_config_task() {
    local configfile=$1
    local task_id=$2
    local task_description=$3
    local task_label=$4
    local task_status=$5
    local task_createdate=$6
    local task_duedate=$7
    local task_donedate=$8
    local task_from_config=""

    if [ ! "$task_status" == "open" ] && [ ! "$task_status" == "done" ]; then
	echo ""
	return 2
    fi

    task_from_config=$(get_config_task $configfile $task_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	sed -i "s/task=$task_id;\"${task_from_config}\"/task=$task_id;\"$task_description;$task_label;$task_status;$task_createdate;$task_duedate;$task_donedate\"/g" $configfile
    fi
}
