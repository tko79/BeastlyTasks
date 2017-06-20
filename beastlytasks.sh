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

user=$(whoami)
configfile="/home/"$user"/.beastlytasks"

echo -e "$license"
echo -e ""

# check and create config file
if [ ! -e "$configfile" ]; then
    echo -n "creating initial config file..."
    touch $configfile
    chown $user: $configfile
    echo " done."
fi

# check and fetch user name from config file or user input
name=$(grep "name=" $configfile)
if [ $? == 1 ]; then
    echo -ne "Please tell me your name: "
    read name
    if [ "$name" == "" ]; then
	echo "Hmm, no name? I'll call you "$user" then!"
	name=$user
    fi
    echo -n "writing your name to config file..."
    echo "name="$name >> $configfile
    echo " done."
else
    echo -n "reading your name from config file..."
    name=$(echo $name | awk -F= '{ print $2 }')
    echo " done."
fi

echo "Hello "$name"! Welcome to BeastlyTasks!"
