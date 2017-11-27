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

# function create_task_image
#          create a task image with parameters for name, start date, end date
#          and done marker.
# param    $1: task name
#          $2: start date (calender week)
#          $3: end date (calender week)
#          $4: done marker
# return   <none>
function create_task_image() {
    name=$1
    start=$2
    end=$3
    done=$4

    local template_red=$btpath"/docs/images/task_template_red.png"
    local template_done=$btpath"/docs/images/task_template_done.png"
    local outfile="/tmp/out.png"

    convert $template_red -gravity Center -pointsize 20 -fill white \
	-draw "text 0,-13 '"$name"'" \
	-draw "text -60,20 '"$start"'" \
	-draw "text 60,20 '"$end"'" \
	$outfile

    if [ $done -eq 1 ]; then
	composite -gravity center $template_done $outfile $outfile
    fi
}
