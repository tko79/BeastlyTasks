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
| <sub>help                   | <sub>show license and help text                                                                                             |

| <sub>parameter              | <sub>rd/wr | <sub>internal function      | <sub>params array                                 |
|-----------------------------|------------|-----------------------------|---------------------------------------------------|
| <sub>time-per-task-currtime | <sub>read  | <sub>time_per_task_currtime | <sub>until ntasks                                 |
| <sub>sum-10h-timers         | <sub>read  | <sub>sum_10h_timers         | <sub>timer1 timer2                                |
| <sub>swl                    | <sub>read  | <sub>show_whats_left        | <sub>format start until start-items current-items |
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
| <sub>list-counters     | <sub>read  | <sub>list_config_counters | <sub>format                                                                |
| <sub>add-counter       | <sub>write | <sub>add_config_counter   | <sub>uid description value threshold belabo descgood descthreshold descbad |
| <sub>get-counter       | <sub>read  | <sub>get_counter          | <sub>uid                                                                   |
| <sub>set-counter       | <sub>write | <sub>set_counter_param    | <sub>uid param newval                                                      |
| <sub>del-counter       | <sub>write | <sub>del_config_counter   | <sub>uid                                                                   |
| <sub>increment-counter | <sub>write | <sub>increment_counter    | <sub>uid                                                                   |
| <sub>decrement-counter | <sub>write | <sub>decrement_counter    | <sub>uid                                                                   |
| <sub>reset-counter     | <sub>write | <sub>reset_counter        | <sub>uid                                                                   |
