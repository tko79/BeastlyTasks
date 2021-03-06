#!/bin/bash

# BeastlyTasks - Organize your tasks and daily work!
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

license=$(cat <<EOF
BeastlyTasks  Copyright (C) 2017  Torsten Koschorrek

This program comes with ABSOLUTELY NO WARRANTY. This is free software, and you
are welcome to redistribute it under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
EOF
)

# color defines
COL_WHITE="\e[1;37m"     # bold white
COL_RED="\e[1;31m"       # bold red
COL_YELLOW="\e[1;33m"    # bold yellow
COL_GREEN="\e[1;32m"     # bold green
COL_WHITE_U="\e[4;1;37m" # bold white
COL_DEFAULT="\e[0m"      # system default

# defaults
LIST_DESC_WIDTH=35
CAL_SHOW_NEXT_START=-8
CAL_SHOW_NEXT_COUNT=40
ID_LENGTH=16

# basic configuration
params_cnt=$#
params_array=("$@")
user=$(whoami)
configfile="/home/"$user"/.beastlytasks"

# root path of beastlytasks
if [ "$BTPATH" == "" ]; then
    btpath="."
else
    btpath=$BTPATH
fi

# include additional sources
source $btpath/config_functions.sh
source $btpath/timer_functions.sh
source $btpath/counter_functions.sh
source $btpath/cal_functions.sh
source $btpath/task_functions.sh
source $btpath/task_dly_functions.sh
source $btpath/task_wly_functions.sh
source $btpath/task_mly_functions.sh
source $btpath/task_yly_functions.sh
source $btpath/label_functions.sh

# function show_help
#          show license and help text
# param    <none>
# return   <none>
show_help() {
    echo -e "$license"
    echo -e ""
    echo -e "Organize your tasks and daily work!"
    echo -e "BeastlyTasks helps you to organize your daily to yearly work, from tickling your"
    echo -e "turtle every day to your annual tax declaration."
    echo -e ""
    echo -e "Parameters:"
    echo -e ""
    printf "$(cat ${btpath}/docs/help.md)\n"
    echo -e ""
    echo -e "Further documentation can be found in the docs/ directory or on the project"
    echo -e "page at https://github.com/tko79/BeastlyTasks !"
    echo -e ""
}

# function show_all
#          show all items
# param    <none>
# return   <none>
show_all() {
    echo -e $COL_WHITE_U"overview"$COL_DEFAULT
    echo ""
    echo -ne $COL_WHITE"counters:      "$COL_DEFAULT
    printf "$(list_counters $configfile list)\n"
    echo -ne $COL_WHITE"timers:        "$COL_DEFAULT
    printf "$(list_timers $configfile list)\n"
    echo -ne $COL_WHITE"calendar:      "$COL_DEFAULT
    printf "$(list_cal $configfile list)\n"
    echo -ne $COL_WHITE"tasks:         "$COL_DEFAULT
    printf "$(list_tasks $configfile list)\n"
    echo -ne $COL_WHITE"daily tasks:   "$COL_DEFAULT
    printf "$(list_tasks_dly $configfile list)\n"
    echo -ne $COL_WHITE"weekly tasks:  "$COL_DEFAULT
    printf "$(list_tasks_wly $configfile list)\n"
    echo -ne $COL_WHITE"monthly tasks: "$COL_DEFAULT
    printf "$(list_tasks_mly $configfile list)\n"
    echo -ne $COL_WHITE"yearly tasks:  "$COL_DEFAULT
    printf "$(list_tasks_yly $configfile list)\n"
    echo ""

    echo -e $COL_WHITE_U"counters"$COL_DEFAULT
    echo ""
    printf "$(list_counters $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"timers"$COL_DEFAULT
    echo ""
    printf "$(list_timers $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"calendar"$COL_DEFAULT
    echo ""
    printf "$(list_cal $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"tasks"$COL_DEFAULT
    echo ""
    printf "$(list_tasks $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"daily tasks"$COL_DEFAULT
    echo ""
    printf "$(list_tasks_dly $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"weekly tasks"$COL_DEFAULT
    echo ""
    printf "$(list_tasks_wly $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"monthly tasks"$COL_DEFAULT
    echo ""
    printf "$(list_tasks_mly $configfile table)\n"
    echo ""

    echo -e $COL_WHITE_U"yearly tasks"$COL_DEFAULT
    echo ""
    printf "$(list_tasks_yly $configfile table)\n"
}

# function show_command_errormsg
#          show error msg in case of unknown command and exit
# param    $1: command
# return   <none>
show_command_errormsg() {
    local command=$1

    echo "Error: command '"$command"' not known!"
    echo "Please run beastlytasks.sh --help for details about parameter settings!"

    exit 1
}

# function show_params_errormsg
#          show error msg in case of invalid number of arguments and exit
# param    $1: parameter description
# return   <none>
show_params_errormsg() {
    local paramdesc=$1

    echo "Error: Wrong number of arguments for "$paramdesc"!"
    echo "Please run beastlytasks.sh --help for details about parameter settings!"

    exit 1
}

# check script arguments
if [ $params_cnt -gt 0 ]; then
    params_curr=0
    for param in ${params_array[@]}; do
	case "$param" in
	    # name parameters
	    "--get-name")
		# get_config_name
		echo $(get_config_name $configfile)
		exit 0
		;;
	    "--set-name")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # set_config_name $name
		    set_config_name $configfile "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "set-name"
		fi
		;;

	    # misc parameters (calculate stats, ...)
	    "--time-per-task-currtime")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    # time_per_task_currtime $until $ntasks
		    echo $(time_per_task_currtime ${params_array[$params_curr+1]} ${params_array[$params_curr+2]})
		    exit 0
		else
		    show_params_errormsg "time-per-task-currtime"
		fi
		;;
	    "--sum-10h-timers")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    # sum_10h_timers $timer1 $timer2
		    echo $(sum_10h_timers ${params_array[$params_curr+1]} ${params_array[$params_curr+2]})
		    exit 0
		else
		    show_params_errormsg "sum-10h-timers"
		fi
		;;
	    "--swl")
		if [ "${params_array[$params_curr+5]}" != "" ]; then
		    # show_whats_left $format $starttime $until $startitems $items
		    printf "$(show_whats_left ${params_array[$params_curr+1]} ${params_array[$params_curr+2]} ${params_array[$params_curr+3]} ${params_array[$params_curr+4]} ${params_array[$params_curr+5]})"
		    exit 0
		else
		    show_params_errormsg "swl"
		fi
		;;
	    "--cti")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # create_task_image $name $start $end [$impo]
		    create_task_image "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}"
		    exit 0
		else
		    show_params_errormsg "cti"
		fi
		;;
	    "--show-cal")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # show calendar $start $count
		    printf "$(show_cal $configfile ${params_array[$params_curr+1]} ${params_array[$params_curr+2]} ${params_array[$params_curr+3]})"
		    exit 0
		elif [ "${params_array[$params_curr+1]}" != "" ]; then
		    # show calendar $CAL_SHOW_NEXT_START $CAL_SHOW_NEXT_COUNT
		    printf "$(show_cal $configfile ${params_array[$params_curr+1]} $CAL_SHOW_NEXT_START $CAL_SHOW_NEXT_COUNT)"
		    exit 0
		else
		    show_params_errormsg "show-cal"
		fi
		;;
	    "--show-all")
		# show all entries
		show_all
		exit 0
		;;
	    "--help")
		# show help text
		show_help
		exit 0
		;;

	    # item parameters: counters
	    "--list-counters")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_counters $format
		    printf "$(list_counters $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-counters"
		fi
		;;
	    "--add-counter")
		if [ "${params_array[$params_curr+8]}" != "" ]; then
		    # add_config_counter $uid $description $value $threshold $belabo $descgood $descthreshold $descbad
		    add_config_counter $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}" "${params_array[$params_curr+5]}" "${params_array[$params_curr+6]}" "${params_array[$params_curr+7]}" "${params_array[$params_curr+8]}"
		    exit 0
		else
		    show_params_errormsg "add-counter"
		fi
		;;
	    "--get-counter")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_counter $uid 'single'
		    printf "$(get_counter $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-counter"
		fi
		;;
	    "--set-counter")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_counter_param $uid $param $newval
		    set_counter_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-counter"
		fi
		;;
	    "--set-and-show-counter")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_counter_param $uid $param $newval
		    set_counter_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    printf "$(list_counters $configfile table)\n"
		    exit 0
		else
		    show_params_errormsg "set-counter"
		fi
		;;
	    "--del-counter")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "counter" $uid
		    del_config_item $configfile "counter" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-counter"
		fi
		;;
	    "--inc-counter")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    # inc_counter $uid $value
		    inc_counter $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}"
		    exit 0
		elif [ "${params_array[$params_curr+1]}" != "" ]; then
		    # inc_counter $uid 1
		    inc_counter $configfile "${params_array[$params_curr+1]}" 1
		    exit 0
		else
		    show_params_errormsg "inc-counter"
		fi
		;;
	    "--inc-and-show-counter")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    # inc_counter $uid $value
		    inc_counter $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}"
		    printf "$(list_counters $configfile table)\n"
		    exit 0
		elif [ "${params_array[$params_curr+1]}" != "" ]; then
		    # inc_counter $uid 1
		    inc_counter $configfile "${params_array[$params_curr+1]}" 1
		    printf "$(list_counters $configfile table)\n"
		    exit 0
		else
		    show_params_errormsg "inc-counter"
		fi
		;;
	    "--dec-counter")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    # dec_counter $uid $value
		    dec_counter $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}"
		    exit 0
		elif [ "${params_array[$params_curr+1]}" != "" ]; then
		    # dec_counter $uid 1
		    dec_counter $configfile "${params_array[$params_curr+1]}" 1
		    exit 0
		else
		    show_params_errormsg "dec-counter"
		fi
		;;
	    "--dec-and-show-counter")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    # dec_counter $uid $value
		    dec_counter $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}"
		    printf "$(list_counters $configfile table)\n"
		    exit 0
		elif [ "${params_array[$params_curr+1]}" != "" ]; then
		    # dec_counter $uid 1
		    dec_counter $configfile "${params_array[$params_curr+1]}" 1
		    printf "$(list_counters $configfile table)\n"
		    exit 0
		else
		    show_params_errormsg "dec-counter"
		fi
		;;
	    "--reset-counter")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # reset_counter $uid
		    reset_counter $configfile "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "reset-counter"
		fi
		;;
	    "--reset-and-show-counter")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # reset_counter $uid
		    reset_counter $configfile "${params_array[$params_curr+1]}"
		    printf "$(list_counters $configfile table)\n"
		    exit 0
		else
		    show_params_errormsg "reset-counter"
		fi
		;;

	    # item parameters: timers
	    "--list-timers")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_timers $format
		    printf "$(list_timers $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-timers"
		fi
		;;
	    "--add-timer")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # add_config_timer $uid $description $value
		    add_config_timer $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "add-timer"
		fi
		;;
	    "--get-timer")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_timer $uid 'single'
		    printf "$(get_timer $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-timer"
		fi
		;;
	    "--set-timer")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_timer_param $uid $param $newval
		    set_timer_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-timer"
		fi
		;;
	    "--del-timer")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "timer" $uid
		    del_config_item $configfile "timer" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-timer"
		fi
		;;

	    # item parameters: cal
	    "--list-cal")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_cal $format
		    printf "$(list_cal $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-cal"
		fi
		;;
	    "--add-cal")
		if [ "${params_array[$params_curr+4]}" != "" ]; then
		    # add_config_cal $uid $description $label $date
		    add_config_cal $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}"
		    exit 0
		else
		    show_params_errormsg "add-cal"
		fi
		;;
	    "--get-cal")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_cal $uid 'single'
		    printf "$(get_cal $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-cal"
		fi
		;;
	    "--set-cal")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_cal_param $uid $param $newval
		    set_cal_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-cal"
		fi
		;;
	    "--del-cal")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "cal" $uid
		    del_config_item $configfile "cal" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-cal"
		fi
		;;

	    # item parameters: tasks
	    "--list-tasks")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_tasks $format
		    printf "$(list_tasks $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-tasks"
		fi
		;;
	    "--add-task")
		if [ "${params_array[$params_curr+8]}" != "" ]; then
		    # add_config_task $uid $description $label $priority $status $createdate $duedate $donedate
		    add_config_task $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}" "${params_array[$params_curr+5]}" "${params_array[$params_curr+6]}" "${params_array[$params_curr+7]}" "${params_array[$params_curr+8]}"
		    exit 0
		else
		    show_params_errormsg "add-task"
		fi
		;;
	    "--get-task")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_task $uid 'single'
		    printf "$(get_task $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-task"
		fi
		;;
	    "--set-task")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_task_param $uid $param $newval
		    set_task_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-task"
		fi
		;;
	    "--del-task")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "task" $uid
		    del_config_item $configfile "task" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-task"
		fi
		;;

	    # item parameters: tasks_dly
	    "--list-tasks-dly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_tasks_dly $format
		    printf "$(list_tasks_dly $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-tasks-dly"
		fi
		;;
	    "--add-task-dly")
		if [ "${params_array[$params_curr+4]}" != "" ]; then
		    # add_config_task_dly $uid $description $label $status
		    add_config_task_dly $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}"
		    exit 0
		else
		    show_params_errormsg "add-task-dly"
		fi
		;;
	    "--get-task-dly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_task_dly $uid 'single'
		    printf "$(get_task_dly $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-task-dly"
		fi
		;;
	    "--set-task-dly")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_task_dly_param $uid $param $newval
		    set_task_dly_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-task-dly"
		fi
		;;
	    "--del-task-dly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "task_dly" $uid
		    del_config_item $configfile "task_dly" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-task-dly"
		fi
		;;

	    # item parameters: tasks_wly
	    "--list-tasks-wly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_tasks_wly $format
		    printf "$(list_tasks_wly $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-tasks-wly"
		fi
		;;
	    "--add-task-wly")
		if [ "${params_array[$params_curr+5]}" != "" ]; then
		    # add_config_task_wly $uid $description $label $status $biweekly
		    add_config_task_wly $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}" "${params_array[$params_curr+5]}"
		    exit 0
		else
		    show_params_errormsg "add-task-wly"
		fi
		;;
	    "--get-task-wly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_task_wly $uid 'single'
		    printf "$(get_task_wly $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-task-wly"
		fi
		;;
	    "--set-task-wly")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_task_wly_param $uid $param $newval
		    set_task_wly_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-task-wly"
		fi
		;;
	    "--del-task-wly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "task_wly" $uid
		    del_config_item $configfile "task_wly" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-task-wly"
		fi
		;;

	    # item parameters: tasks_mly
	    "--list-tasks-mly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_tasks_mly $format
		    printf "$(list_tasks_mly $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-tasks-mly"
		fi
		;;
	    "--add-task-mly")
		if [ "${params_array[$params_curr+4]}" != "" ]; then
		    # add_config_task_mly $uid $description $label $status
		    add_config_task_mly $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}"
		    exit 0
		else
		    show_params_errormsg "add-task-mly"
		fi
		;;
	    "--get-task-mly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_task_mly $uid 'single'
		    printf "$(get_task_mly $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-task-mly"
		fi
		;;
	    "--set-task-mly")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_task_mly_param $uid $param $newval
		    set_task_mly_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-task-mly"
		fi
		;;
	    "--del-task-mly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "task_mly" $uid
		    del_config_item $configfile "task_mly" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-task-mly"
		fi
		;;

	    # item parameters: tasks_yly
	    "--list-tasks-yly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_tasks_yly $format
		    printf "$(list_tasks_yly $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-tasks-yly"
		fi
		;;
	    "--add-task-yly")
		if [ "${params_array[$params_curr+5]}" != "" ]; then
		    # add_config_task_yly $uid $description $label $status $duedate
		    add_config_task_yly $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}" "${params_array[$params_curr+4]}" "${params_array[$params_curr+5]}"
		    exit 0
		else
		    show_params_errormsg "add-task-yly"
		fi
		;;
	    "--get-task-yly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_task_yly $uid 'single'
		    printf "$(get_task_yly $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-task-yly"
		fi
		;;
	    "--set-task-yly")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_task_yly_param $uid $param $newval
		    set_task_yly_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-task-yly"
		fi
		;;
	    "--del-task-yly")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "task_yly" $uid
		    del_config_item $configfile "task_yly" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-task-yly"
		fi
		;;

	    # item parameters: labels
	    "--list-labels")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # list_labels $format
		    printf "$(list_labels $configfile ${params_array[$params_curr+1]})\n"
		    exit 0
		else
		    show_params_errormsg "list-labels"
		fi
		;;
	    "--add-label")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # add_config_label $uid $description $color
		    add_config_label $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "add-label"
		fi
		;;
	    "--get-label")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # get_label $uid 'single'
		    printf "$(get_label $configfile ${params_array[$params_curr+1]} 'single')\n"
		    exit 0
		else
		    show_params_errormsg "get-label"
		fi
		;;
	    "--set-label")
		if [ "${params_array[$params_curr+3]}" != "" ]; then
		    # set_label_param $uid $param $newval
		    set_label_param $configfile "${params_array[$params_curr+1]}" "${params_array[$params_curr+2]}" "${params_array[$params_curr+3]}"
		    exit 0
		else
		    show_params_errormsg "set-label"
		fi
		;;
	    "--del-label")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    # del_config_item "label" $uid
		    del_config_item $configfile "label" "${params_array[$params_curr+1]}"
		    exit 0
		else
		    show_params_errormsg "del-label"
		fi
		;;
	    *)
		show_command_errormsg $param
		;;
	esac
	params_curr=$(( $params_curr+1 ))
    done
fi

echo -e "$license"
echo -e ""

# check and create config file
check_configfile $configfile
if [ $? == 1 ]; then
    echo -n "creating initial config file..."
    create_configfile $configfile $user
    echo " done."
fi

# check and fetch user name from config file or user input
echo -n "reading your name from config file..."
name=$(get_config_name $configfile)
if [ $? == 1 ]; then
    echo " failed."
    echo -ne "Please tell me your name: "
    read name
    if [ "$name" == "" ]; then
	echo "Hmm, no name? I'll call you "$user" then!"
	name=$user
    fi
    echo -n "writing your name to config file..."
    set_config_name $configfile "$name"
fi
echo " done."

echo "Hello "$name"! Welcome to BeastlyTasks!"
echo ""
