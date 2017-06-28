#!/bin/bash

# timer_functions - Functions to set timers and calculate times.
#                   This file is part of BeastlyTasks.
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

# function __sum_sub_time
#          sum up or substract two time values
# param    $1: time1 (format hh:mm:ss)
#          $2: time2 (format hh:mm:ss)
#          $3: "sum" or "sub"
# return   printf: calculated time (format hh:mm:ss)
function __sum_sub_time() {
    local t1_hh=''
    local t1_mm=''
    local t1_ss=''
    local t2_hh=''
    local t2_mm=''
    local t2_ss=''
    local result_val=''

    IFS=":" read -r t1_hh t1_mm t1_ss <<< "$1"
    IFS=":" read -r t2_hh t2_mm t2_ss <<< "$2"

    if [ "$3" == "sum" ]; then
	result_val=$(( (${t1_hh#0}*60*60+${t1_mm#0}*60+${t1_ss#0})+(${t2_hh#0}*60*60+${t2_mm#0}*60+${t2_ss#0}) ))
    else
	result_val=$(( (${t1_hh#0}*60*60+${t1_mm#0}*60+${t1_ss#0})-(${t2_hh#0}*60*60+${t2_mm#0}*60+${t2_ss#0}) ))
    fi

    local r_hh=$(( $result_val/(60*60) ))
    local r_mm=$(( ($result_val-$r_hh*60*60)/60 ))
    local r_ss=$(( $result_val-$r_hh*60*60-$r_mm*60 ))

    printf "%02d:%02d:%02d\n" "$r_hh" "$r_mm" "$r_ss"
}

# function convert_countdown
#          convert countdown timer values to time and vice versa
# param    $1: time value (format hh:mm:ss)
#          $2: diff value (format hh:mm:ss), default 10 hours (10:00:00)
# return   echo: calculated time (format hh:mm:ss)
function convert_countdown() {
    local time_val=$1
    local diff_val=$2

    if [ "$diff_val" == "" ]; then
	diff_val="10:00:00"
    fi

    echo $(__sum_sub_time $diff_val $time_val "sub")
}

# function sum_time
#          sum up two time values
# param    $1: time1 (format hh:mm:ss)
#          $2: time2 (format hh:mm:ss)
# return   echo: calculated time (format hh:mm:ss)
function sum_time() {
    local time1_val=$1
    local time2_val=$2

    echo $(__sum_sub_time $time1_val $time2_val "sum")
}

# function time_left
#          calculate the time left (considering days)
# param    $1: now (format d:hh:mm)
#          $2: until (format d:hh:mm)
# return   printf: calculated time left (format mm)
function time_left() {
    local now_val=$1
    local until_val=$2

    local n_d=''
    local n_hh=''
    local n_mm=''
    local u_d=''
    local u_hh=''
    local u_mm=''

    IFS=":" read -r n_d n_hh n_mm <<< "$now_val"
    IFS=":" read -r u_d u_hh u_mm <<< "$until_val"

    local result_val=$(( (${u_d#0}*24*60+${u_hh#0}*60+${u_mm#0})-(${n_d#0}*24*60+${n_hh#0}*60+${n_mm#0}) ))

    printf "%d\n" "$result_val"
}

# function time_per_task
#          calculate available time per task
# param    $1: time (format mm)
#          $2: ntasks
# return   printf: calculated time per task (format mm)
function time_per_task() {
    local time_val=$1
    local ntasks_val=$2

    local result_val=$(( time_val/ntasks_val ))

    printf "%d\n" "$result_val"
}
