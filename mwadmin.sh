#!/bin/bash
#
#

SYSTEM="Middleware"
ENVIRONMENT="PROD"

MWADMIN_HOME="./"
#MWADMIN_HOME="/src/mwadmin"
LOGFILENAME="${MWADMIN_HOME}/mwadmin_menu.log"
to_adv_opmenu="0"


show_main_menu() {
  clear
  cat << EOF
  +====================================================================+
       Hostname: $(hostname)       ${SYSTEM}: ${ENVIRONMENT}
       Today is $(date +%Y-%m-%d)       Login Name : ${LOGNAME}
  +====================================================================+

       0. check MW
       
       1. (Start WAS)
       2. (Stop WAS)

       3. (Start IHS)
       4. (Stop IHS)

       5. (Start MQ)
       6. (Stop MQ)
        ......
        q.QUIT

        Enter your choice (0-6, q) :

EOF
}


main() {
# The entry for sub functions.
  while true
  do
    cd ${MWADMIN_HOME}
    show_main_menu
    read choice
    clear
      case $choice in
      0)  ./mw_hc.sh;;
      1) echo "Starting WAS servers at "`date` | tee -a ${LOGFILENAME};${MWADMIN_HOME}/str_was.sh ;;
      2) echo "Stop WAS servers at "`date` | tee -a ${LOGFILENAME};${MWADMIN_HOME}/str_was.sh ;;
      3) echo "Starting IHS servers at "`date` | tee -a ${LOGFILENAME};${MWADMIN_HOME}/str_ihs.sh ;;
      4) echo "Stop IHS servers at "`date` | tee -a ${LOGFILENAME};${MWADMIN_HOME}/end_ihs.sh ;;
      5) echo "Starting IHS servers at "`date` | tee -a ${LOGFILENAME};${MWADMIN_HOME}/str_mq.sh ;;
      6) echo "Stop IHS servers at "`date` | tee -a ${LOGFILENAME};${MWADMIN_HOME}/end_mq.sh ;;
      
      c) more ${MWADMIN_HOME}/mwadmin_menu.log ;;
      
      q)
        echo ''
        echo 'Thanks !! bye bye ^-^ !!!'
        echo ''
        #logout
        exit;logout
        ;;      
      *)
        clear;clear
        echo ''
        echo 'PRESS ENTER TO CONTINUE ... !!!'
        read choice
        ;;
      esac
      echo ''
      echo 'Press enter to continue' && read null
  done
}

main
