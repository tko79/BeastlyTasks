# Parameters

## name

| <sub>parameter | <sub>description          |
|----------------|---------------------------|
| <sub>get-name  | <sub>get user name        |
| <sub>set-name  | <sub>set user name {name} |

| <sub>parameter | <sub>rd/wr | <sub>internal function       | <sub>params array |
|----------------|------------|------------------------------|-------------------|
| <sub>get-name  | <sub>read  | <sub>get_config_name         |                   |
| <sub>set-name  | <sub>write | <sub>set_config_name         | <sub>name         |

## misc

| <sub>parameter              | <sub>description                                                                                                            |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| <sub>time-per-task-currtime | <sub>calculate time per task of #{ntasks} {until} date                                                                      |
| <sub>sum-10h-timers         | <sub>sumup 10h-timers {timer1} and {timer2}                                                                                 |
| <sub>swl                    | <sub>show what's left in {format:normal\|csv\|conky} using: {start} date, {until} date, #{start-items} and #{current-items} |
| <sub>cti                    | <sub>create a task image with {name}, {start} week, {end} week and (optional) {impo:impo} flag                              |
| <sub>show-cal               | <sub>show calendar (next 90 days ({next}) or a complete year ({<year>}))                                                    |
| <sub>help                   | <sub>show license and help text                                                                                             |

| <sub>parameter              | <sub>rd/wr | <sub>internal function      | <sub>params array                                 |
|-----------------------------|------------|-----------------------------|---------------------------------------------------|
| <sub>time-per-task-currtime | <sub>read  | <sub>time_per_task_currtime | <sub>until ntasks                                 |
| <sub>sum-10h-timers         | <sub>read  | <sub>sum_10h_timers         | <sub>timer1 timer2                                |
| <sub>swl                    | <sub>read  | <sub>show_whats_left        | <sub>format start until start-items current-items |
| <sub>cti                    | <sub>write | <sub>create_task_image      | <sub>name start end impo                          |
| <sub>show-cal               | <sub>read  | <sub>show_cal               | <sub>option                                       |
| <sub>show-all               | <sub>read  | <sub>show_all               |                                                   |
| <sub>help                   | <sub>read  | <sub>show_help              |                                                   |

## counters

| <sub>parameter         | <sub>description                                                                                                                                             |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| <sub>list-counters     | <sub>list all counters in {format:list\|table}                                                                                                               |
| <sub>add-counter       | <sub>add a new counter with {uid}, {description}, {value}, good {belabo:below\|above} threshold and descriptions for values below, equal and above threshold |
| <sub>get-counter       | <sub>get value of counter {uid}                                                                                                                              |
| <sub>set-counter       | <sub>set {newval} of {param} for counter {uid}                                                                                                               |
| <sub>del-counter       | <sub>delete counter {uid}                                                                                                                                    |
| <sub>increment-counter | <sub>increment counter {uid}                                                                                                                                 |
| <sub>decrement-counter | <sub>decrement counter {uid}                                                                                                                                 |
| <sub>reset-counter     | <sub>reset counter {uid}                                                                                                                                     |

| <sub>parameter         | <sub>rd/wr | <sub>internal function    | <sub>params array                                                          |
|------------------------|------------|---------------------------|----------------------------------------------------------------------------|
| <sub>list-counters     | <sub>read  | <sub>list_counters        | <sub>format                                                                |
| <sub>add-counter       | <sub>write | <sub>add_config_counter   | <sub>uid description value threshold belabo descgood descthreshold descbad |
| <sub>get-counter       | <sub>read  | <sub>get_counter          | <sub>uid                                                                   |
| <sub>set-counter       | <sub>write | <sub>set_counter_param    | <sub>uid param newval                                                      |
| <sub>del-counter       | <sub>write | <sub>del_config_counter   | <sub>uid                                                                   |
| <sub>increment-counter | <sub>write | <sub>increment_counter    | <sub>uid                                                                   |
| <sub>decrement-counter | <sub>write | <sub>decrement_counter    | <sub>uid                                                                   |
| <sub>reset-counter     | <sub>write | <sub>reset_counter        | <sub>uid                                                                   |

## timers

| <sub>parameter   | <sub>description                                           |
|------------------|------------------------------------------------------------|
| <sub>list-timers | <sub>list all timers in {format:list\|table}               |
| <sub>add-timer   | <sub>add a new timer with {uid}, {description} and {value} |
| <sub>get-timer   | <sub>get value of timer {uid}                              |
| <sub>set-timer   | <sub>set {newval} of {param} for timer {uid}               |
| <sub>del-timer   | <sub>delete timer {uid}                                    |

| <sub>parameter   | <sub>rd/wr | <sub>internal function | <sub>params array          |
|------------------|------------|------------------------|----------------------------|
| <sub>list-timers | <sub>read  | <sub>list_timers       | <sub>format                |
| <sub>add-timer   | <sub>write | <sub>add_config_timer  | <sub>uid description value |
| <sub>get-timer   | <sub>read  | <sub>get_timer         | <sub>uid                   |
| <sub>set-timer   | <sub>write | <sub>set_timer_param   | <sub>uid param newval      |
| <sub>del-timer   | <sub>write | <sub>del_config_timer  | <sub>uid                   |

## cal

| <sub>parameter | <sub>description                                                 |
|----------------|------------------------------------------------------------------|
| <sub>list-cal  | <sub>list all cal in {format:list\|table}                        |
| <sub>add-cal   | <sub>add a new cal with {uid}, {description}, {label} and {date} |
| <sub>get-cal   | <sub>get value of cal {uid}                                      |
| <sub>set-cal   | <sub>set {newval} of {param} for cal {uid}                       |
| <sub>del-cal   | <sub>delete cal {uid}                                            |

| <sub>parameter | <sub>rd/wr | <sub>internal function | <sub>params array               |
|----------------|------------|------------------------|---------------------------------|
| <sub>list-cal  | <sub>read  | <sub>list_cal          | <sub>format                     |
| <sub>add-cal   | <sub>write | <sub>add_config_cal    | <sub>uid description label date |
| <sub>get-cal   | <sub>read  | <sub>get_cal           | <sub>uid                        |
| <sub>set-cal   | <sub>write | <sub>set_cal_param     | <sub>uid param newval           |
| <sub>del-cal   | <sub>write | <sub>del_config_cal    | <sub>uid                        |

## tasks

| <sub>parameter  | <sub>description                                                                                                              |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------|
| <sub>list-tasks | <sub>list all tasks in {format:list\|table}                                                                                   |
| <sub>add-task   | <sub>add a new task with {uid}, {description}, {label}, {priority:0-5}, {status:open\|done}, {create-}, {due-} and {donedate} |
| <sub>get-task   | <sub>get value of task {uid}                                                                                                  |
| <sub>set-task   | <sub>set {newval} of {param} for task {uid}                                                                                   |
| <sub>del-task   | <sub>delete task {uid}                                                                                                        |

| <sub>parameter  | <sub>rd/wr | <sub>internal function | <sub>params array                                                      |
|-----------------|------------|------------------------|------------------------------------------------------------------------|
| <sub>list-tasks | <sub>read  | <sub>list_tasks        | <sub>format                                                            |
| <sub>add-task   | <sub>write | <sub>add_config_task   | <sub>uid description label priority status createdate duedate donedate |
| <sub>get-task   | <sub>read  | <sub>get_task          | <sub>uid                                                               |
| <sub>set-task   | <sub>write | <sub>set_task_param    | <sub>uid param newval                                                  |
| <sub>del-task   | <sub>write | <sub>del_config_task   | <sub>uid                                                               |

## daily tasks

| <sub>parameter      | <sub>description                                                                     |
|---------------------|--------------------------------------------------------------------------------------|
| <sub>list-tasks-dly | <sub>list all daily tasks in {format:list\|table}                                    |
| <sub>add-task-dly   | <sub>add a new daily task with {uid}, {description}, {label} and {status:open\|done} |
| <sub>get-task-dly   | <sub>get value of daily task {uid}                                                   |
| <sub>set-task-dly   | <sub>set {newval} of {param} for daily task {uid}                                    |
| <sub>del-task-dly   | <sub>delete task {uid}                                                               |

| <sub>parameter      | <sub>rd/wr | <sub>internal function   | <sub>params array                 |
|---------------------|------------|--------------------------|-----------------------------------|
| <sub>list-tasks-dly | <sub>read  | <sub>list_tasks_dly      | <sub>format                       |
| <sub>add-task-dly   | <sub>write | <sub>add_config_task_dly | <sub>uid description label status |
| <sub>get-task-dly   | <sub>read  | <sub>get_task_dly        | <sub>uid                          |
| <sub>set-task-dly   | <sub>write | <sub>set_task_dly_param  | <sub>uid param newval             |
| <sub>del-task-dly   | <sub>write | <sub>del_config_task_dly | <sub>uid                          |

## weekly tasks

| <sub>parameter      | <sub>description                                                                                       |
|---------------------|--------------------------------------------------------------------------------------------------------|
| <sub>list-tasks-wly | <sub>list all weeky tasks in {format:list\|table}                                                      |
| <sub>add-task-wly   | <sub>add a new weeky task with {uid}, {description}, {label}, {status:open\|done} and {biweekly:yes\|} |
| <sub>get-task-wly   | <sub>get value of weeky task {uid}                                                                     |
| <sub>set-task-wly   | <sub>set {newval} of {param} for weeky task {uid}                                                      |
| <sub>del-task-wly   | <sub>delete task {uid}                                                                                 |

| <sub>parameter      | <sub>rd/wr | <sub>internal function   | <sub>params array                          |
|---------------------|------------|--------------------------|--------------------------------------------|
| <sub>list-tasks-wly | <sub>read  | <sub>list_tasks_wly      | <sub>format                                |
| <sub>add-task-wly   | <sub>write | <sub>add_config_task_wly | <sub>uid description label status biweekly |
| <sub>get-task-wly   | <sub>read  | <sub>get_task_wly        | <sub>uid                                   |
| <sub>set-task-wly   | <sub>write | <sub>set_task_wly_param  | <sub>uid param newval                      |
| <sub>del-task-wly   | <sub>write | <sub>del_config_task_wly | <sub>uid                                   |

## monthly tasks

| <sub>parameter      | <sub>description                                                                       |
|---------------------|----------------------------------------------------------------------------------------|
| <sub>list-tasks-mly | <sub>list all monthly tasks in {format:list\|table}                                    |
| <sub>add-task-mly   | <sub>add a new monthly task with {uid}, {description}, {label} and {status:open\|done} |
| <sub>get-task-mly   | <sub>get value of monthly task {uid}                                                   |
| <sub>set-task-mly   | <sub>set {newval} of {param} for monthly task {uid}                                    |
| <sub>del-task-mly   | <sub>delete task {uid}                                                                 |

| <sub>parameter      | <sub>rd/wr | <sub>internal function   | <sub>params array                 |
|---------------------|------------|--------------------------|-----------------------------------|
| <sub>list-tasks-mly | <sub>read  | <sub>list_tasks_mly      | <sub>format                       |
| <sub>add-task-mly   | <sub>write | <sub>add_config_task_mly | <sub>uid description label status |
| <sub>get-task-mly   | <sub>read  | <sub>get_task_mly        | <sub>uid                          |
| <sub>set-task-mly   | <sub>write | <sub>set_task_mly_param  | <sub>uid param newval             |
| <sub>del-task-mly   | <sub>write | <sub>del_config_task_mly | <sub>uid                          |

## labels

| <sub>parameter   | <sub>description                                           |
|------------------|------------------------------------------------------------|
| <sub>list-labels | <sub>list all labels in {format:list\|table}               |
| <sub>add-label   | <sub>add a new label with {uid}, {description} and {color} |
| <sub>get-label   | <sub>get value of label {uid}                              |
| <sub>set-label   | <sub>set {newval} of {param} for label {uid}               |
| <sub>del-label   | <sub>delete label {uid}                                    |

| <sub>parameter   | <sub>rd/wr | <sub>internal function | <sub>params array          |
|------------------|------------|------------------------|----------------------------|
| <sub>list-labels | <sub>read  | <sub>list_labels       | <sub>format                |
| <sub>add-label   | <sub>write | <sub>add_config_label  | <sub>uid description color |
| <sub>get-label   | <sub>read  | <sub>get_label         | <sub>uid                   |
| <sub>set-label   | <sub>write | <sub>set_label_param   | <sub>uid param newval      |
| <sub>del-label   | <sub>write | <sub>del_config_label  | <sub>uid                   |
