# Overview

Conky can be used as one of various user interfaces. For this the data to be
displayed will be stored in temporary files which will be read continuously by
conky.

Here is a nice conky example:

![conky](/docs/images/conky_bt.jpg)

# Files

| <sub>file                 | <sub>function          | <sub>data                                  |
|---------------------------|------------------------|--------------------------------------------|
| <sub>/tmp/conky_stats     | <sub>show_whats_left() | <sub>statistics about tasks done and to do |
| <sub>/tmp/conky_percitems | <sub>show_whats_left() | <sub>finished items in percent             |
| <sub>/tmp/conky_perctime  | <sub>show_whats_left() | <sub>expired time in percent               |
