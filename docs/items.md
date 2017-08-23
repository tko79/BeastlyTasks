# Overview

| <sub>item    | <sub>description                                        | <sub>parameters and format in config                                                   |
|--------------|---------------------------------------------------------|----------------------------------------------------------------------------------------|
| <sub>name    | <sub>user name                                          | <sub>`"$name"`                                                                         |
| <sub>counter | <sub>event counter with threshold and value description | <sub>`$uid;"$description;$value;$threshold;$belabo;$descgood;$descthreshold;$descbad"` |
| <sub>timer   | <sub>timer to count time spent for a task               | <sub>`$uid;"$description;$value"`                                                      |
| <sub>cal     | <sub>calender entries                                   | <sub>`$uid;"$description;$label;$date"`                                                |
| <sub>task    | <sub>misc tasks                                         | <sub>`$uid;"$description;$label;$status;$duedate"`                                     |
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

| <sub>parameter     | <sub>description            | <sub>format                |
|--------------------|-----------------------------|----------------------------|
| <sub>uid           | <sub>unique id              | <sub>string                |
| <sub>description   | <sub>description            | <sub>string                |
| <sub>value         | <sub>current value          | <sub>number                |
| <sub>threshold     | <sub>threshold value        | <sub>number                |
| <sub>belabo        | <sub>below or above is good | <sub>string:{below\|above} |
| <sub>descgood      | <sub>description good       | <sub>string                |
| <sub>descthreshold | <sub>description threshold  | <sub>string                |
| <sub>descbad       | <sub>description bad        | <sub>string                |

### timer

- description: timer to count time spent for a task
- parameters and format in config: `$uid;"$description;$value"`

| <sub>parameter   | <sub>description   | <sub>format          |
|------------------|--------------------|----------------------|
| <sub>uid         | <sub>unique id     | <sub>string          |
| <sub>description | <sub>description   | <sub>string          |
| <sub>value       | <sub>current value | <sub>time:(hh:mm:ss) |
