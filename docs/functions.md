# beastlytasks.sh

- show_help()
- show_params_errormsg()
- main:check_script_params()
- main:check_and_create_config()
- main:check_and_fetch_username()



# config_functions.sh

## configfile

- check_configfile()
- create_configfile()

## name

- get_config_name()
- set_config_name()

## counters

- list_config_counters()
- add_config_counter()
- del_config_counter()
- get_config_counter()
- set_config_counter()

## timers

- list_config_timers()
- add_config_timer()
- del_config_timer()
- get_config_timer()
- set_config_timer()



# timer_functions.sh

## statistics, helpers

- __sum_sub_time()
- convert_countdown()
- sum_time()
- sum_10h_timers()
- time_left()
- time_left_currtime()
- time_per_task()
- time_per_task_currtime()
- show_whats_left()

## timers

- get_timer_param()
- set_timer_param()
- get_timer()
- list_timers()



# counter_functions.sh

- get_counter_param()
- set_counter_param()
- increment_counter()
- decrement_counter()
- reset_counter()
- get_counter()
- list_counters()



# task_functions.sh

- create_task_image()
