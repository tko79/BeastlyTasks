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
| <sub>help                   | <sub>show license and help text                                                                                             |

| <sub>parameter              | <sub>rd/wr | <sub>internal function      | <sub>params array                                 |
|-----------------------------|------------|-----------------------------|---------------------------------------------------|
| <sub>time-per-task-currtime | <sub>read  | <sub>time_per_task_currtime | <sub>until ntasks                                 |
| <sub>sum-10h-timers         | <sub>read  | <sub>sum_10h_timers         | <sub>timer1 timer2                                |
| <sub>swl                    | <sub>read  | <sub>show_whats_left        | <sub>format start until start-items current-items |
| <sub>cti                    | <sub>write | <sub>create_task_image      | <sub>name start end impo                          |
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

## tasks

| <sub>parameter  | <sub>description                                                                                                              |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------|
| <sub>list-tasks | <sub>list all tasks in {format:list\|table}                                                                                   |
| <sub>add-task   | <sub>add a new task with {uid}, {description}, {label}, {priority:0-5}, {status:open\|done}, {create-}, {due-} and {donedate} |
| <sub>get-task   | <sub>get value of task {uid}                                                                                                  |
| <sub>set-task   | <sub>set {newval} of {param} for task {uid}                                                                                   |
| <sub>del-task   | <sub>delete task {uid}                                                                                                        |

| <sub>parameter  | <sub>rd/wr | <sub>internal function | <sub>params array                                                         |
|-----------------|------------|------------------------|---------------------------------------------------------------------------|
| <sub>list-tasks | <sub>read  | <sub>list_tasks        | <sub>format                                                               |
| <sub>add-task   | <sub>write | <sub>add_config_task   | <sub>uid description, label, priority, status, create-, due- and donedate |
| <sub>get-task   | <sub>read  | <sub>get_task          | <sub>uid                                                                  |
| <sub>set-task   | <sub>write | <sub>set_task_param    | <sub>uid param newval                                                     |
| <sub>del-task   | <sub>write | <sub>del_config_task   | <sub>uid                                                                  |
