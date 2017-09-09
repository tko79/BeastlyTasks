# Parameters

## name

| <sub>parameter | <sub>rd/wr | <sub>internal function       | <sub>params array |
|----------------|------------|------------------------------|-------------------|
| <sub>get-name  | <sub>read  | <sub>get_config_name         |                   |
| <sub>set-name  | <sub>write | <sub>set_config_name         | <sub>name         |

## misc

| <sub>parameter              | <sub>rd/wr | <sub>internal function      | <sub>params array                                 |
|-----------------------------|------------|-----------------------------|---------------------------------------------------|
| <sub>time-per-task-currtime | <sub>read  | <sub>time_per_task_currtime | <sub>until ntasks                                 |
| <sub>sum-10h-timers         | <sub>read  | <sub>sum_10h_timers         | <sub>timer1 timer2                                |
| <sub>swl                    | <sub>read  | <sub>show_whats_left        | <sub>format start until start-items current-items |

# counters

| <sub>parameter         | <sub>rd/wr | <sub>internal function    | <sub>params array                                                          |
|------------------------|----------------------------------------|----------------------------------------------------------------------------|
| <sub>list-counters     | <sub>read  | <sub>list_config_counters |                                                                            |
| <sub>add-counter       | <sub>write | <sub>add_config_counter   | <sub>uid description value threshold belabo descgood descthreshold descbad |
| <sub>get-counter       | <sub>read  | <sub>get_counter          | <sub>uid                                                                   |
| <sub>set-counter       | <sub>write | <sub>set_counter_param    | <sub>uid param newval                                                      |
| <sub>del-counter       | <sub>write | <sub>del_config_counter   | <sub>uid                                                                   |
| <sub>increment-counter | <sub>write | <sub>increment_counter    | <sub>uid                                                                   |
| <sub>decrement-counter | <sub>write | <sub>decrement_counter    | <sub>uid                                                                   |
| <sub>reset-counter     | <sub>write | <sub>reset_counter        | <sub>uid                                                                   |
