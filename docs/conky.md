# Overview

Conky can be used as one of various user interfaces. For this the data to be
displayed will be stored in temporary files which will be read continuously by
conky.

***

# Configuration

Here is a nice example:

![conky](/images/conky_bt.jpg)

To configure this example (or something similar) the following lines have to be
added in the conkyrc:

    ${font Mono:size=10:style=bold}BeastlyTasks___${font}
    tasks ${tail /tmp/conky_percitems 1}% ${color 4444dd}${execbar tail /tmp/conky_percitems}${color}
    time  ${tail /tmp/conky_perctime 1}% ${color 4444dd}${execbar tail /tmp/conky_perctime}${color}
    ${color red}${tail /tmp/conky_stats 2}${color}

***

# Files

| <sub>file                 | <sub>function          | <sub>data                                  |
|---------------------------|------------------------|--------------------------------------------|
| <sub>/tmp/conky_stats     | <sub>show_whats_left() | <sub>statistics about tasks done and to do |
| <sub>/tmp/conky_percitems | <sub>show_whats_left() | <sub>finished items in percent             |
| <sub>/tmp/conky_perctime  | <sub>show_whats_left() | <sub>expired time in percent               |
