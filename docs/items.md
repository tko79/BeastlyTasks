# Overview

| <sub>item    | <sub>description                                        | <sub>parameters and format in config                                                   |
|--------------|---------------------------------------------------------|----------------------------------------------------------------------------------------|
| <sub>name    | <sub>user name                                          | <sub>`"$name"`                                                                         |
| <sub>counter | <sub>event counter with threshold and value description | <sub>`$uid;"$description;$value;$threshold;$belabo;$descgood;$descthreshold;$descbad"` |
| <sub>timer   | <sub>timer to count time spent for a task               | <sub>`$uid;"$description;$value"`                                                      |
| <sub>cal     | <sub>calender entries                                   | <sub>`$uid;"$description;$label;$date"`                                                |
| <sub>task    | <sub>misc tasks                                         | <sub>`$uid;"$description;$label;$priority;$status;$createdate;$duedate;$donedate"`     |
| <sub>daily   | <sub>daily tasks                                        | <sub>`$uid;"$description;$label;$status"`                                              |
| <sub>weekly  | <sub>weekly tasks                                       | <sub>`$uid;"$description;$label;$status;$biweekly"`                                    |
| <sub>monthly | <sub>monthly tasks                                      | <sub>`$uid;"$description;$label;$status"`                                              |
| <sub>yearly  | <sub>yearly tasks                                       | <sub>`$uid;"$description;$label;$status;$duedate"`                                     |

***

# Items

### name

- description: user name
- parameters and format in config: `"$name"`

| <sub>parameter | <sub>description | <sub>format |
|----------------|------------------|-------------|
| <sub>name      | <sub>user name   | <sub>string |

### counter

- description: event counter with threshold and value description
- parameters and format in config: `$uid;"$description;$value;$threshold;$belabo;$descgood;$descthreshold;$descbad"`

| <sub>parameter     | <sub>description             | <sub>format                |
|--------------------|------------------------------|----------------------------|
| <sub>uid           | <sub>unique id (10 char max) | <sub>string                |
| <sub>description   | <sub>description             | <sub>string                |
| <sub>value         | <sub>current value           | <sub>number                |
| <sub>threshold     | <sub>threshold value         | <sub>number                |
| <sub>belabo        | <sub>below or above is good  | <sub>string:{below\|above} |
| <sub>descgood      | <sub>description good        | <sub>string                |
| <sub>descthreshold | <sub>description threshold   | <sub>string                |
| <sub>descbad       | <sub>description bad         | <sub>string                |

### timer

- description: timer to count time spent for a task
- parameters and format in config: `$uid;"$description;$value"`

| <sub>parameter   | <sub>description             | <sub>format          |
|------------------|------------------------------|----------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string          |
| <sub>description | <sub>description             | <sub>string          |
| <sub>value       | <sub>current value           | <sub>time:(hh:mm:ss) |

### cal

- description: calender entries
- parameters and format in config: `$uid;"$description;$label;$date"`

| <sub>parameter   | <sub>description             | <sub>format            |
|------------------|------------------------------|------------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string            |
| <sub>description | <sub>description             | <sub>string            |
| <sub>label       | <sub>one or more labels/tags | <sub>string            |
| <sub>date        | <sub>date of entry           | <sub>date:(dd.mm.yyyy) |

### task

- description: misc tasks
- parameters and format in config: `$uid;"$description;$label;$priority;$status;$donedate;$duedate"`

| <sub>parameter   | <sub>description             | <sub>format              |
|------------------|------------------------------|--------------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string              |
| <sub>description | <sub>description             | <sub>string              |
| <sub>label       | <sub>one or more labels/tags | <sub>string              |
| <sub>priority    | <sub>prio of the task        | <sub>number:{0-5}        |
| <sub>status      | <sub>status of task          | <sub>string:{open\|done} |
| <sub>createdate  | <sub>create date of task     | <sub>date:(cw/yy)        |
| <sub>duedate     | <sub>due date of task        | <sub>date:(cw/yy)        |
| <sub>donedate    | <sub>done date of task       | <sub>date:(cw/yy)        |

### daily

- description: daily tasks
- parameters and format in config: `$uid;"$description;$label;$status;$donedate"`

| <sub>parameter   | <sub>description             | <sub>format              |
|------------------|------------------------------|--------------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string              |
| <sub>description | <sub>description             | <sub>string              |
| <sub>label       | <sub>one or more labels/tags | <sub>string              |
| <sub>status      | <sub>status of task          | <sub>string:{open\|done} |

### weekly

- description: weekly tasks
- parameters and format in config: `$uid;"$description;$label;$status;$donedate;$biweekly"`

| <sub>parameter   | <sub>description             | <sub>format              |
|------------------|------------------------------|--------------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string              |
| <sub>description | <sub>description             | <sub>string              |
| <sub>label       | <sub>one or more labels/tags | <sub>string              |
| <sub>status      | <sub>status of task          | <sub>string:{open\|done} |
| <sub>biweekly    | <sub>biweekly task?          | <sub>string:{yes\|}      |

### monthly

- description: monthly tasks
- parameters and format in config: `$uid;"$description;$label;$status;$donedate"`

| <sub>parameter   | <sub>description             | <sub>format              |
|------------------|------------------------------|--------------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string              |
| <sub>description | <sub>description             | <sub>string              |
| <sub>label       | <sub>one or more labels/tags | <sub>string              |
| <sub>status      | <sub>status of task          | <sub>string:{open\|done} |

### yearly

- description: yearly tasks
- parameters and format in config: `$uid;"$description;$label;$status;$donedate;$duedate"`

| <sub>parameter   | <sub>description             | <sub>format              |
|------------------|------------------------------|--------------------------|
| <sub>uid         | <sub>unique id (10 char max) | <sub>string              |
| <sub>description | <sub>description             | <sub>string              |
| <sub>label       | <sub>one or more labels/tags | <sub>string              |
| <sub>status      | <sub>status of task          | <sub>string:{open\|done} |
| <sub>duedate     | <sub>due date of task        | <sub>date:(cw/yy)        |
