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
  --del-counter UID                     delete counter UID
  --increment-counter UID               increment counter UID
  --decrement-counter UID               decrement counter UID
  --reset-counter UID                   reset counter UID

timers:
  --list-timers FORMAT                  list all timers in FORMAT:list|table
  --add-timer UID DESCRIPTION VALUE     add a new timer with UID, DESCRIPTION,
                                        VALUE
  --get-timer UID                       get value of timer UID
  --set-timer UID PARAM NEWVAL          set NEWVAL of PARAM:description|value
                                        for timer UID
  --del-timer UID                       delete timer UID

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
