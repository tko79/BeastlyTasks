name:
  --get-name                            get user name
  --set-name NAME                       set user name NAME

misc:
  --time-per-task-currtime UNTIL NTASKS calculate time per task of #NTASKS
                                        UNTIL date
  --sum-10h-timers TIMER1 TIMER2        sumup 10h-timers TIMER1 and TIMER2
  --swl FORMAT START UNTIL STARTITEMS   show what's left in FORMAT:normal|csv|
        CURRENTITEMS                    conky using: START date, UNTIL date,
                                        #START-ITEMS and #CURRENT-ITEMS

counters:
  --list-counters FORMAT                list all counters in FORMAT:list|table
  --add-counter UID DESCRIPTION VALUE   add a new counter with UID, DESCRIPTION,
                THRESHOLD BELABO        VALUE, good BELABO:below|above threshold
                DESCGOOD DESCTHRESHOLD  and descriptions for values below, equal
                DESCBAD                 and above threshold DESCGOOD,
                                        DESCTHRESHOLD, DESCBAD
  --get-counter UID                     get value of counter UID
  --set-counter UID PARAM NEWVAL        set NEWVAL of PARAM for counter UID
  --del-counter UID                     delete counter UID
  --increment-counter UID               increment counter UID
  --decrement-counter UID               decrement counter UID
  --reset-counter UID                   reset counter UID
