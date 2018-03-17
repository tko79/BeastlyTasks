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

# function __sort_config
#          sort the entries in the config file and add sections
# param    $1: config filename
# return   <none>
__sort_config() {
    local configfile=$1
    local tmpfile="/tmp/bt"

    echo "[generic]"                    > $tmpfile
    grep 'name=\"' $configfile         >> $tmpfile
    echo ""                            >> $tmpfile
    echo "[label]"                     >> $tmpfile
    grep 'label=' $configfile | sort   >> $tmpfile
    echo ""                            >> $tmpfile
    echo "[counter]"                   >> $tmpfile
    grep 'counter=' $configfile | sort >> $tmpfile
    echo ""                            >> $tmpfile
    echo "[timer]"                     >> $tmpfile
    grep 'timer=' $configfile | sort   >> $tmpfile
    echo ""                            >> $tmpfile
    echo "[cal]"                       >> $tmpfile
    grep 'cal=' $configfile | sort     >> $tmpfile
    echo ""                            >> $tmpfile
    echo "[tasks]"                     >> $tmpfile
    grep 'task=' $configfile | sort    >> $tmpfile

    mv -f $tmpfile $configfile
}

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
	echo ${name#name=} | sed -e 's#\"##g'
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
	sed -i "s#name=\"${name_from_config}\"#name=\"${name}\"#g" $configfile
    fi

    __sort_config $configfile
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
#          return 2: in case of error (counter id too long)
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

    if [ ${#counter_id} -gt 10 ]; then
       return 2
    fi

    counter_from_config=$(get_config_counter $configfile $counter_id)
    if [ $? == 1 ]; then
	echo "counter=$counter_id;\"$counter_description;$counter_value;$counter_threshold;$counter_below_above;$counter_desc_good;$counter_desc_threshold;$counter_desc_bad\"" >> $configfile
    else
	return 1
    fi

    __sort_config $configfile
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
	echo ${counter_from_config#counter=$counter_id;} | sed -e 's#\"##g'
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
	sed -i "s#counter=$counter_id;\"${counter_from_config}\"#counter=$counter_id;\"$counter_description;$counter_value;$counter_threshold;$counter_below_above;$counter_desc_good;$counter_desc_threshold;$counter_desc_bad\"#g" $configfile
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
#          return 2: in case of error (timer id too long)
function add_config_timer() {
    local configfile=$1
    local timer_id=$2
    local timer_description=$3
    local timer_value=$4
    local timer_from_config=""

    if [ ${#timer_id} -gt $ID_LENGTH ]; then
	return 2
    fi

    timer_from_config=$(get_config_timer $configfile $timer_id)
    if [ $? == 1 ]; then
	echo "timer=$timer_id;\"$timer_description;$timer_value\"" >> $configfile
    else
	return 1
    fi

    __sort_config $configfile
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
	echo ${timer_from_config#timer=$timer_id;} | sed -e 's#\"##g'
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
	sed -i "s#timer=$timer_id;\"${timer_from_config}\"#timer=$timer_id;\"$timer_description;$timer_value\"#g" $configfile
    fi
}

# function list_config_cal
#          get cal from config
# param    $1: config filename
# return   echo cal from config
function list_config_cal() {
    local configfile=$1
    local cal_from_config=""

    cal_from_config=$(grep "cal=" $configfile | awk -F';' '{ print $1 }' | awk -F'=' '{ print $2 }')
    echo $cal_from_config
}

# function add_config_cal
#          add cal to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: date (format dd.mm.yyyy)
# return   return 1: in case of error (cal id already existing)
#          return 2: in case of error (wrong date format)
#          return 3: in case of error (cal id too long)
function add_config_cal() {
    local configfile=$1
    local cal_id=$2
    local cal_description=$3
    local cal_label=$4
    local cal_date=$5
    local cal_from_config=""

    if [[ ! $cal_date == [0-9][0-9]"."[0-9][0-9]".20"[0-9][0-9] ]]; then
	echo ""
	return 2
    fi

    if [ ${#cal_id} -gt $ID_LENGTH ]; then
	return 3
    fi

    cal_from_config=$(get_config_cal $configfile $cal_id)
    if [ $? == 1 ]; then
	echo "cal=$cal_id;\"$cal_description;$cal_label;$cal_date\"" >> $configfile
    else
	return 1
    fi

    __sort_config $configfile
}

# function del_config_cal
#          delete cal from config
# param    $1: config filename
#          $2: unique id
# return   <none>
function del_config_cal() {
    local configfile=$1
    local cal_id=$2

    sed -i "/cal=$cal_id;/d" $configfile
}

# function get_config_cal
#          get cal from config
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (cal id not found)
function get_config_cal() {
    local configfile=$1
    local cal_id=$2
    local cal_from_config=""

    cal_from_config=$(grep "cal=$cal_id;" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${cal_from_config#cal=$cal_id;} | sed -e 's#\"##g'
    fi
}

# function set_config_cal
#          set cal to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: date (format dd.mm.yyyy)
# return   return 1: in case of error (cal id not found)
function set_config_cal() {
    local configfile=$1
    local cal_id=$2
    local cal_description=$3
    local cal_label=$4
    local cal_date=$5
    local cal_from_config=""

    cal_from_config=$(get_config_cal $configfile $cal_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	sed -i "s#cal=$cal_id;\"${cal_from_config}\"#cal=$cal_id;\"$cal_description;$cal_label;$cal_date\"#g" $configfile
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
#          $5: priority {0-5}
#          $6: status {open|done}
#          $7: create date (format cw/yy)
#          $8: due date (format cw/yy)
#          $9: done date (format cw/yy)
# return   return 1: in case of error (task id already existing)
#          return 2: in case of error (task status not open or done)
#          return 3: in case of error (wrong create-/due-/donedate format)
#          return 4: in case of error (task id too long)
function add_config_task() {
    local configfile=$1
    local task_id=$2
    local task_description=$3
    local task_label=$4
    local task_priority=$5
    local task_status=$6
    local task_createdate=$7
    local task_duedate=$8
    local task_donedate=$9
    local task_from_config=""

    if [ ! "$task_status" == "open" ] && [ ! "$task_status" == "done" ]; then
	echo ""
	return 2
    fi
    if [[ ! $task_createdate == [0-9][0-9]"/"[0-9][0-9] ]]; then
	echo ""
	return 3
    fi
    if [[ ! $task_duedate == [0-9][0-9]"/"[0-9][0-9] ]]; then
	echo ""
	return 3
    fi
    if [[ ! $task_donedate == [0-9][0-9]"/"[0-9][0-9] ]]; then
	echo ""
	return 3
    fi

    if [ ${#task_id} -gt $ID_LENGTH ]; then
	return 4
    fi

    task_from_config=$(get_config_task $configfile $task_id)
    if [ $? == 1 ]; then
	echo "task=$task_id;\"$task_description;$task_label;$task_priority;$task_status;$task_createdate;$task_duedate;$task_donedate\"" >> $configfile
    else
	return 1
    fi

    __sort_config $configfile
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
	echo ${task_from_config#task=$task_id;} | sed -e 's#\"##g'
    fi
}

# function set_config_task
#          set task to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: priority {0-5}
#          $6: status {open|done}
#          $7: create date (format cw/yy)
#          $8: due date (format cw/yy)
#          $9: done date (format cw/yy)
# return   return 1: in case of error (task id not found)
#          return 2: in case of error (task status not open or done)
function set_config_task() {
    local configfile=$1
    local task_id=$2
    local task_description=$3
    local task_label=$4
    local task_priority=$5
    local task_status=$6
    local task_createdate=$7
    local task_duedate=$8
    local task_donedate=$9
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
	sed -i "s#task=$task_id;\"${task_from_config}\"#task=$task_id;\"$task_description;$task_label;$task_priority;$task_status;$task_createdate;$task_duedate;$task_donedate\"#g" $configfile
    fi
}

# function list_config_tasks_dly
#          get tasks_dly from config
# param    $1: config filename
# return   echo tasks_dly from config
function list_config_tasks_dly() {
    local configfile=$1
    local tasks_dly_from_config=""

    tasks_dly_from_config=$(grep "task=" $configfile | awk -F';' '{ print $1 }' | awk -F'=' '{ print $2 }')
    echo $tasks_dly_from_config
}

# function add_config_task_dly
#          add task_dly to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: status {open|done}
# return   return 1: in case of error (task_dly id already existing)
#          return 2: in case of error (task_dly status not open or done)
#          return 3: in case of error (task_dly id too long)
function add_config_task_dly() {
    local configfile=$1
    local task_dly_id=$2
    local task_dly_description=$3
    local task_dly_label=$4
    local task_dly_status=$5
    local task_dly_from_config=""

    if [ ! "$task_dly_status" == "open" ] && [ ! "$task_dly_status" == "done" ]; then
	echo ""
	return 2
    fi

    if [ ${#task_dly_id} -gt $ID_LENGTH ]; then
	return 3
    fi

    task_dly_from_config=$(get_config_task_dly $configfile $task_dly_id)
    if [ $? == 1 ]; then
	echo "task_dly=$task_dly_id;\"$task_dly_description;$task_dly_label;$task_dly_status\"" >> $configfile
    else
	return 1
    fi

    __sort_config $configfile
}

# function del_config_task_dly
#          delete task_dly from config
# param    $1: config filename
#          $2: unique id
# return   <none>
function del_config_task_dly() {
    local configfile=$1
    local task_dly_id=$2

    sed -i "/task_dly=$task_dly_id;/d" $configfile
}

# function get_config_task_dly
#          get task_dly from config
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (task_dly id not found)
function get_config_task_dly() {
    local configfile=$1
    local task_dly_id=$2
    local task_dly_from_config=""

    task_dly_from_config=$(grep "task_dly=$task_dly_id;" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${task_dly_from_config#task_dly=$task_dly_id;} | sed -e 's#\"##g'
    fi
}

# function set_config_task_dly
#          set task_dly to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: label
#          $5: status {open|done}
# return   return 1: in case of error (task_dly id not found)
#          return 2: in case of error (task_dly status not open or done)
function set_config_task_dly() {
    local configfile=$1
    local task_dly_id=$2
    local task_dly_description=$3
    local task_dly_label=$4
    local task_dly_status=$5
    local task_dly_from_config=""

    if [ ! "$task_dly_status" == "open" ] && [ ! "$task_dly_status" == "done" ]; then
	echo ""
	return 2
    fi

    task_dly_from_config=$(get_config_task_dly $configfile $task_dly_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	sed -i "s#task_dly=$task_dly_id;\"${task_dly_from_config}\"#task_dly=$task_dly_id;\"$task_dly_description;$task_dly_label;$task_dly_status\"#g" $configfile
    fi
}

# function list_config_labels
#          get labels from config
# param    $1: config filename
# return   echo labels from config
function list_config_labels() {
    local configfile=$1
    local labels_from_config=""

    labels_from_config=$(grep "label=" $configfile | awk -F';' '{ print $1 }' | awk -F'=' '{ print $2 }')
    echo $labels_from_config
}

# function add_config_label
#          add label to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: color
# return   return 1: in case of error (label id already existing)
#          return 2: in case of error (label id too long)
function add_config_label() {
    local configfile=$1
    local label_id=$2
    local label_description=$3
    local label_color=$4

    if [ ${#label_id} -gt $ID_LENGTH ]; then
       return 2
    fi

    label_from_config=$(get_config_label $configfile $label_id)
    if [ $? == 1 ]; then
	echo "label=$label_id;\"$label_description;$label_color\"" >> $configfile
    else
	return 1
    fi

    __sort_config $configfile
}

# function del_config_label
#          delete label from config
# param    $1: config filename
#          $2: unique id
# return   <none>
function del_config_label() {
    local configfile=$1
    local label_id=$2

    sed -i "/label=$label_id;/d" $configfile
}

# function get_config_label
#          get label from config
# param    $1: config filename
#          $2: unique id
# return   return 1: in case of error (label id not found)
function get_config_label() {
    local configfile=$1
    local label_id=$2
    local label_from_config=""

    label_from_config=$(grep "label=$label_id;" $configfile)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	echo ${label_from_config#label=$label_id;} | sed -e 's#\"##g'
    fi
}

# function set_config_label
#          set label to config
# param    $1: config filename
#          $2: unique id
#          $3: description
#          $4: color
# return   return 1: in case of error (label id not found)
#          return 2: in case of error (label status not open or done)
function set_config_label() {
    local configfile=$1
    local label_id=$2
    local label_description=$3
    local label_color=$4

    label_from_config=$(get_config_label $configfile $label_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	sed -i "s#label=$label_id;\"${label_from_config}\"#label=$label_id;\"$label_description;$label_color\"#g" $configfile
    fi
}
