#!/bin/bash

# generic_functions - Generic functions for all items.
#                     This file is part of BeastlyTasks.
# Copyright (C) 2019  Torsten Koschorrek
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

# function __calc_column_width
#          Calculate the column width. Depending on 1- and 2-byte characters
#          (umlauts, ...) the actual width of a column differs from the number
#          of characters (e.g. testö: 5 characters with 6 byte).
# param    $1: column content
#          $2: expected column width
# return   column width in characters
function __calc_column_width() {
    local content=$1
    local expected_width=$2
    local length_bytes=$(echo $content | wc -c)
    local length_chars=$(echo $content | wc -m)

    echo $(($expected_width+$length_bytes-$length_chars))
}
