#!/bin/bash

# cal_functions - Functions to handle calender events.
#                 This file is part of BeastlyTasks.
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

function show_cal() {
    local year="2018"
    local cnt_days=""
    local day=""
    local cal=""
    local week=""

    # do we have a leapyear or a normal year?
    if [ $(date -d "01/01/"${year}"+365days" +"%j") -eq 355 ]; then
	let cnt_days=366
    else
	let cnt_days=365
    fi

    let day=0
    let week=0

    while [ $day -lt $cnt_days ]; do
	if [ $(date -d "01/01/"${year}"+"$day"days" +"%V") -gt $week ]; then
	    week=$(($week+1))
	    cal=$cal"\n"$COL_WHITE$(printf "cw%02d/%d:" $week $year)$COL_DEFAULT"\n"
	fi

	cal=$cal$(date -d "01/01/"$year"+"$day"days" +"%d.%m.%Y")"\n"
	day=$(($day+1))
    done

    printf "%s" $cal
}

# function get_cal_param
#          wrapper to get cal parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: requested cal parameter
# return   echo: cal parameter
#          return 1: in case of error (get_config_cal failed)
function get_cal_param() {
    local configfile=$1
    local cal_id=$2
    local cal_param=$3

    local cal_from_config=""

    cal_from_config=$(get_config_cal $configfile $cal_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	cal_from_config=${cal_from_config#cal=$cal_id;} | sed -e 's#\"##g'
	case "$cal_param" in
	    "description") echo $cal_from_config | awk -F';' '{ print $1 }' ;;
	    "label")       echo $cal_from_config | awk -F';' '{ print $2 }' ;;
	    "date")        echo $cal_from_config | awk -F';' '{ print $3 }' ;;
	esac
    fi
}

# function set_cal_param
#          wrapper to set cal parameter (description, status, ...)
# param    $1: config filename
#          $2: unique id
#          $3: cal parameter
#          $4: new value for parameter
# return   return 1: in case of error (get_config_cal failed)
#          return 2: in case of error (wrong create-/due-/donedate format)
function set_cal_param() {
    local configfile=$1
    local cal_id=$2
    local cal_param=$3
    local cal_newval=$4

    local cal_from_config=""

    cal_from_config=$(get_config_cal $configfile $cal_id)
    if [ $? == 1 ]; then
	echo ""
	return 1
    else
	cal_from_config=${cal_from_config#cal=$cal_id;} | sed -e 's#\"##g'

	local cal_description=$(echo $cal_from_config | awk -F';' '{ print $1 }')
	local cal_label=$(echo       $cal_from_config | awk -F';' '{ print $2 }')
	local cal_date=$(echo        $cal_from_config | awk -F';' '{ print $3 }')

	case "$cal_param" in
	    "date")
		if [[ ! $cal_newval == [0-9][0-9]"."[0-9][0-9]".20"[0-9][0-9] ]]; then
		    return 2
		fi
	    ;;
	esac

	case "$cal_param" in
	    "description") cal_description=$cal_newval ;;
	    "label")       cal_label=$cal_newval ;;
	    "date")        cal_date=$cal_newval ;;
	esac

	return $(set_config_cal $configfile $cal_id "$cal_description" $cal_label $cal_date)
    fi
}

# function get_cal
#          read cal value
# param    $1: config filename
#          $2: unique id
#          $3: format {single|table}
# return   printf: formatted cal text
#          return 1: in case of error (get_config_cal failed)
function get_cal() {
    local configfile=$1
    local cal_id=$2
    local format=$3

    local cal_from_config=""
    local desc_width=$(($LIST_DESC_WIDTH-3))

    cal_from_config=$(get_config_cal $configfile $cal_id)
    if [ $? == 1 ]; then
	return 1
    else
	local cal_description=$(echo $cal_from_config | awk -F';' '{ print $1 }')
	local cal_label=$(echo       $cal_from_config | awk -F';' '{ print $2 }')
	local cal_date=$(echo        $cal_from_config | awk -F';' '{ print $3 }')

	if [ "$format" == "table" ]; then
            if [ ${#cal_description} -gt $desc_width ]; then
		cal_description=${cal_description:0:$desc_width}"..."
            fi
	fi

	if [ "$format" == "single" ]; then
	    printf "%s [%s]\n   -> label: %s\n   -> date: %s" "$cal_id" "$cal_description" "$cal_label" "$cal_date"
	else
	    local dlb=$(echo $cal_description | wc -c)
	    local dlc=$(echo $cal_description | wc -m)
	    desc_width=$(($LIST_DESC_WIDTH+$dlb-$dlc))
	    printf "%-10s %-"$desc_width"s %-7s %-10s" $cal_id "$cal_description" $cal_label $cal_date
	fi
    fi
}

# function list_cal
#          list all available cal entries as a list or a table
# param    $1: config filename
#          $2: format {list|table}
# return   printf: formatted list or table of cal
#          return 1: in case of error (format parameter is not table or list)
function list_cal() {
    local configfile=$1
    local format=$2

    local cal_from_config=""
    local width="0"

    cal_from_config=$(list_config_cal $configfile)
    if [ "$format" == "list" ]; then
	printf "$cal_from_config"
	return 0
    fi
    if [ "$format" == "table" ]; then
	local cal_table=""
	local cal_id=""

	cal_table=$COL_WHITE$(printf "%-10s %-"${LIST_DESC_WIDTH}"s %-7s %-4s" "id" "description" "label" "date\n")
	cal_table=$cal_table"------------------------------"
	while [ $width -lt $LIST_DESC_WIDTH ]; do
            cal_table=$cal_table"-"
            width=$(($width+1))
	done
	cal_table=$cal_table$COL_DEFAULT"\n"

	for cal_id in $cal_from_config; do
	    cal_table=$cal_table$(get_cal $configfile $cal_id 'table')"\n"
	done
	printf "$cal_table"
	return 0
    fi
    return 1
}
