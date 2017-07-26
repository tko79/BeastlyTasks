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

params_cnt=$#
params_array=("$@")
user=$(whoami)
configfile="/home/"$user"/.beastlytasks"

source config_functions.sh
source timer_functions.sh

# check script arguments
if [ $params_cnt -gt 0 ]; then
    params_curr=0
    for param in ${params_array[@]}; do
	case "$param" in
	    "--get-name")
		name=$(get_config_name $configfile)
		echo $name
		exit 0
		;;
	    "--set-name")
		if [ "${params_array[$params_curr+1]}" != "" ]; then
		    set_config_name $configfile "${params_array[$params_curr+1]}"
		fi
		exit 0
		;;
	    "--time-per-task-currtime")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    echo $(time_per_task_currtime ${params_array[$params_curr+1]} ${params_array[$params_curr+2]})
		fi
		exit 0
		;;
	    "--sum-10h-timers")
		if [ "${params_array[$params_curr+2]}" != "" ]; then
		    echo $(sum_10h_timers ${params_array[$params_curr+1]} ${params_array[$params_curr+2]})
		fi
		exit 0
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
