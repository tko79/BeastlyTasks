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

# function convert_countdown
#          convert countdown timer values to time and vice versa
# param    $1: time value (format hh:mm:ss)
#          $2: diff value (format hh:mm:ss), default 10 hours (10:00:00)
# return   printf: calculated time (format hh:mm:ss)
function convert_countdown() {
    time_val=$1
    diff_val=$2

    if [ "$diff_val" == "" ]; then
	diff_val="10:00:00"
    fi

    IFS=":" read -r t_hh t_mm t_ss <<< "$time_val"
    IFS=":" read -r d_hh d_mm d_ss <<< "$diff_val"

    result_val=$(( ($d_hh*60*60+$d_mm*60+$d_ss)-($t_hh*60*60+$t_mm*60+$t_ss) ))
    r_hh=$(( $result_val/(60*60) ))
    r_mm=$(( ($result_val-$r_hh*60*60)/60 ))
    r_ss=$(( $result_val-$r_hh*60*60-$r_mm*60 ))

    printf "%02d:%02d:%02d\n" "$r_hh" "$r_mm" "$r_ss"
}
