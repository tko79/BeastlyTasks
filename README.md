# BeastlyTasks

Organize your tasks and daily work!

BeastlyTasks helps you to organize your daily to yearly work, from tickling
your turtle every day to your annual tax declaration.

![conky](/docs/images/conky_bt.jpg)

***

# Getting Started

Change into the cloned BeastlyTasks repository. BeastlyTasks is executed by
simply running it from the console.

    cd ~/BeastlyTasks/
    sh ./beastlytasks.sh

Using parameters is also possible. For example `--get-name` and `--set-name`
can be used to read and write your user name:

    ./beastlytasks.sh --set-name 'My Name !'
    ./beastlytasks.sh --get-name
    My Name !

Please also make use of the environment variable `BTPATH`
(`export BTPATH=<absolute-path-to-BeastlyTasks>`) to define the path to
beastlytasks.sh. With this option BeastlyTasks can be executed from anywhere
and not only from the project path.

***

# License

BeastlyTasks is licensed under the GNU General Public License, version 3. See
[COPYING](https://github.com/tko79/BeastlyTasks/blob/master/COPYING) for
details.
