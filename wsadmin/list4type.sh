#!/bin/bash
#
#

SYSTEM="wsadmin"
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

      s0 "Server : " 
      j1 "JavaVirtualMachine : " 
      
      d1 "JDBCProvider : " 
      d2 "DataSource : " 
      d3 "ConnectionPool : "
      d4 "JAASAuthData : " 
      
      m1 "MQQueueConnectionFactory : "
      m2 "MQQueue : " 

      v1 "VariableSubstitutionEntry : "
      v2 "VirtualHost : "       
      v3 "HostAlias : " 
      v4 "Library : " 

      a1 "Application : " 
      p1 "Property : " 

      x1 "input : " 

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
      s0) echo "Server : " ; wsadmin.sh -f list4type.py Server n y ;;
      j1) echo "JavaVirtualMachine : " ; wsadmin.sh -f list4type.py JavaVirtualMachine n y ;;
      d1) echo "JDBCProvider : " ; wsadmin.sh -f list4type.py JDBCProvider n y ;;
      d2) echo "DataSource : " ; wsadmin.sh -f list4type.py DataSource n y ;;
      d3) echo "ConnectionPool : " ; wsadmin.sh -f list4type.py ConnectionPool n y ;;
      d4) echo "JAASAuthData : " ; wsadmin.sh -f list4type.py JAASAuthData n y ;;
      m1) echo "MQQueueConnectionFactory : " ; wsadmin.sh -f list4type.py MQQueueConnectionFactory n y ;;
      m2) echo "MQQueue : " ; wsadmin.sh -f list4type.py MQQueue n y ;;
      v1) echo "VariableSubstitutionEntry : " ; wsadmin.sh -f list4type.py VariableSubstitutionEntry n y ;;
      v2) echo "VirtualHost : " ; wsadmin.sh -f list4type.py VirtualHost n y ;;
      v3) echo "HostAlias : " ; wsadmin.sh -f list4type.py HostAlias n y ;;
      v4) echo "Library : " ; wsadmin.sh -f list4type.py Library n y ;;
      a1) echo "Application : " ; wsadmin.sh -f list4type.py Application n y ;;
      p1) echo "Property : " ; wsadmin.sh -f list4type.py Property n y ;;
      x1) echo "input : " ; read oType ; wsadmin.sh -f list4type.py $oType n y ;;
      
      
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
