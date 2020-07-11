name:
  --get-name                            get user name
  --set-name NAME                       set user name NAME

misc:
  --time-per-task-currtime UNTIL NTASKS calculate time per task of #NTASKS
                                        UNTIL date
  --sum-10h-timers TIMER1 TIMER2        sumup 10h-timers TIMER1 and TIMER2
  --swl FORMAT START UNTIL STARTITEMS   show what's left in FORMAT:normal|csv|
        CURRENTITEMS                    conky using: START date:d:hh:mm, UNTIL
                                        date:d:hh:mm, #START-ITEMS and
                                        #CURRENT-ITEMS
  --cti NAME START END (IMPO)           create task image with NAME, START week,
                                        END week and (optional) (IMPO:impo) flag
  --show-cal OPTION                     show calendar with OPTION:next|<year>
                                        (next 90 days or complete year)
  --show-all                            show a complete list of all items

counters:
  --list-counters FORMAT                list all counters in FORMAT:list|table
  --add-counter UID DESCRIPTION VALUE   add a new counter with UID, DESCRIPTION,
                THRESHOLD BELABO        VALUE, good BELABO:below|above threshold
                DESCGOOD DESCTHRESHOLD  and descriptions for values below, equal
                DESCBAD                 and above threshold DESCGOOD,
                                        DESCTHRESHOLD, DESCBAD
  --get-counter UID                     get value of counter UID
  --set-counter UID PARAM NEWVAL        set NEWVAL of PARAM:description|value|
                                        threshold|belabo|txtgood|txtequal|txtbad
                                        for counter UID
  --set-and-show-counter UID PARAM      set NEWVAL of PARAM:description|value|
                         NEWVAL         threshold|belabo|txtgood|txtequal|txtbad
                                        and show table of counters
                                        for counter UID
  --del-counter UID                     delete counter UID
  --inc-counter UID (VALUE)             increment counter UID by 1 (or optional,
                                        by VALUE)
  --inc-and-show-counter UID (VALUE)    increment counter UID by 1 (or optional,
                                        by VALUE) and show table of counters
  --dec-counter UID (VALUE)             decrement counter UID by 1 (or optional,
                                        by VALUE)
  --dec-and-show-counter UID (VALUE)    decrement counter UID by 1 (or optional,
                                        by VALUE) and show table of counters
  --reset-counter UID                   reset counter UID
  --reset-and-show-counter UID          reset counter UID and show table of
                                        counters

timers:
  --list-timers FORMAT                  list all timers in FORMAT:list|table
  --add-timer UID DESCRIPTION VALUE     add a new timer with UID, DESCRIPTION,
                                        VALUE
  --get-timer UID                       get value of timer UID
  --set-timer UID PARAM NEWVAL          set NEWVAL of PARAM:description|value
                                        for timer UID
  --del-timer UID                       delete timer UID

calendar:
  --list-cal FORMAT                     list all cal in FORMAT:list|table
  --add-cal UID DESCRIPTION LABEL DATE  add a new cal with UID, DESCRIPTION,
                                        LABEL and DATE
  --get-cal UID                         get value of cal UID
  --set-cal UID PARAM NEWVAL            set NEWVAL of PARAM:description|label|
                                        date for cal UID
  --del-cal UID                         delete cal UID

tasks:
  --list-tasks FORMAT                   list all tasks in FORMAT:list|table
  --add-task UID DESCRIPTION LABEL      add a new task with UID, DESCRIPTION,
             PRIORITY STATUS CREATEDATE LABEL, PRIORITY:0-5, STATUS:open|done,
             DUEDATE DONEDATE           CREATEDATE, DUEDATE and DONEDATE
  --get-task UID                        get value of task UID
  --set-task UID PARAM NEWVAL           set NEWVAL of PARAM:description|label|
                                        priority|status|createdate|duedate|
                                        donedate for task UID
  --del-task UID                        delete task UID

daily tasks:
  --list-tasks-dly FORMAT               list all daily tasks in FORMAT:list|
                                        table
  --add-task-dly UID DESCRIPTION LABEL  add a new daily task with UID,
                 STATUS                 DESCRIPTION, LABEL and STATUS:open|done
  --get-task-dly UID                    get value of daily task UID
  --set-task-dly UID PARAM NEWVAL       set NEWVAL of PARAM:description|label|
                                        status for daily task UID
  --del-task-dly UID                    delete daily task UID

weekly tasks:
  --list-tasks-wly FORMAT               list all weekly tasks in FORMAT:list|
                                        table
  --add-task-wly UID DESCRIPTION LABEL  add a new weekly task with UID,
                 STATUS BIWEEKLY        DESCRIPTION, LABEL, STATUS:open|done and
                                        BIWEEKLY:yes|
  --get-task-wly UID                    get value of weekly task UID
  --set-task-wly UID PARAM NEWVAL       set NEWVAL of PARAM:description|label|
                                        status|biweekly for weekly task UID
  --del-task-wly UID                    delete weekly task UID

monthly tasks:
  --list-tasks-mly FORMAT               list all monthly tasks in FORMAT:list|
                                        table
  --add-task-mly UID DESCRIPTION LABEL  add a new monthly task with UID,
                 STATUS                 DESCRIPTION, LABEL and STATUS:open|done
  --get-task-mly UID                    get value of monthly task UID
  --set-task-mly UID PARAM NEWVAL       set NEWVAL of PARAM:description|label|
                                        status for monthly task UID
  --del-task-mly UID                    delete monthly task UID

yearly tasks:
  --list-tasks-yly FORMAT               list all yearly tasks in FORMAT:list|
                                        table
  --add-task-yly UID DESCRIPTION LABEL  add a new yearly task with UID,
                 STATUS DUEDATE         DESCRIPTION, LABEL, STATUS:open|done and
                                        DUEDATE
  --get-task-yly UID                    get value of yearly task UID
  --set-task-yly UID PARAM NEWVAL       set NEWVAL of PARAM:description|label|
                                        status|duedate for yearly task UID
  --del-task-yly UID                    delete yearly task UID

labels:
  --list-labels FORMAT                  list all labels in FORMAT:list|table
  --add-label UID DESCRIPTION COLOR     add a new label with UID, DESCRIPTION
                                        and COLOR
  --get-label UID                       get value of label UID
  --set-label UID PARAM NEWVAL          set NEWVAL of PARAM:description|color
                                        for label UID
  --del-label UID                       delete label UID
