#!/bin/bash
#
#

TEMP_FILE=/tmp/_health_check.txt
FULL_WAS_NAME="NO"
ps -ef > ${TEMP_FILE}
HOSTNAME=`hostname`
LANG=en_US

# By default flags are checked, check flag enable on demand.
CHECK_DB2="NO"
CHECK_WAS="NO"
CHECK_IHS="NO"
CHECK_WMQ="NO"
CHECK_WMB="NO"
CHECK_WMBC="NO"
CHECK_LDAP="NO"
CHECK_MQIPT="NO"
CHECK_SNA="NO"
CHECK_MAXQ="NO"
CHECK_REPL="NO"
CHECK_DBSYN="NO"
CHECK_ITMDB="NO"
CHECK_ITMMQ="NO"
CHECK_ITMUX="NO"
CHECK_ITMUL="NO"
CHECK_ITMUM="NO"
CHECK_ITMYN="NO"
CHECK_PATROL="NO"
CHECK_AMOS="NO"
CHECK_TIM="NO"
CHECK_HACMP="NO"
CHECK_DES="NO"
CHECK_NMON="NO"

TIMESTAMP=`date +%Y-%m-%d" "%H:%M:%S`
echo
echo "Current time: ${TIMESTAMP}  Machine: ${HOSTNAME}  Login ID: ${LOGIN}"



case ${HOSTNAME} in
# PROD  
"AP")  
  CHECK_IHS="YES"
  ALL_IHS_INSTANCES="/usr/IBM/HTTPServer/bin/httpd"
  CHECK_WAS="YES"
  ALL_WAS_INSTANCES="APCell01/APCellManager01/dmgr APCell01/APNode01/nodeagent APCell01/APNode01/srv01 "  
  #CHECK_NMON="YES"
  #ALL_NMON_INSTANCES="topas_nmon"
  ;;    
"MQ")
  #CHECK_SNA="YES"
  #ALL_SNA_INSTANCES="snadaemon64"
  CHECK_WMQ="YES"
  ALL_WMQ_INSTANCES="QM1 QM3"  
  ;;    
   

esac

# Check DB2 instance
if [ "${CHECK_DB2}" = "YES" ] ; then
echo
for THIS_INSTANCE in ${ALL_DB2_INSTANCES}
do
  THIS_PROCESS=`cat ${TEMP_FILE} | grep "db2sysc 2" | grep ${THIS_INSTANCE} | awk '{print $2}'`
  if [ "${THIS_PROCESS}x" = "x" ] ; then
  printf "%13s%13s%3s%8s\n" DB2-instance: ${THIS_INSTANCE} is STOPPED
  else
    UP_TIME1=`cat ${TEMP_FILE} | grep "db2sysc 0" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
    UP_TIME2=`cat ${TEMP_FILE} | grep "db2sysc 0" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
    UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
    if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
      UP_TIME="${UP_TIME1}-${UP_TIME2}"
    else
      UP_TIME="${UP_TIME1}"
    fi
    STARTED_BY=`cat ${TEMP_FILE} | grep "db2sysc 0" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
    printf "%13s%13s%3s%3s%4s%9s%8s%9s%5s%8s\n" DB2-instance: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
  fi
done
fi

# Check WAS java process
if [ "${CHECK_WAS}" = "YES" ] ; then
echo
for THIS_WAS_INSTANCE in ${ALL_WAS_INSTANCES}
do
  THIS_WAS_CELL=`echo ${THIS_WAS_INSTANCE} | awk 'BEGIN { FS = "/" } ; { print $1 }'`
  THIS_WAS_NODE=`echo ${THIS_WAS_INSTANCE} | awk 'BEGIN { FS = "/" } ; { print $2 }'`
  THIS_WAS_SERVER=`echo ${THIS_WAS_INSTANCE} | awk 'BEGIN { FS = "/" } ; { print $3 }'`
  THIS_INSTANCE="${THIS_WAS_SERVER}"
  THIS_PROCESS=`cat ${TEMP_FILE} | grep "java.security.auth.login.config" | grep "${THIS_WAS_NODE}" | grep "${THIS_WAS_SERVER}"  | awk '{print $2}'`
  if [ "${THIS_PROCESS}x" = "x" ] ; then
    if [ "${FULL_WAS_NAME}" = "YES" ] ; then
      printf "%3s%9s%27s%3s%8s\n" WAS Process: "${THIS_WAS_CELL}/${THIS_WAS_NODE}/${THIS_WAS_SERVER}" is STOPPED
    else
      printf "%3s%9s%25s%3s%8s\n" WAS Process: "${THIS_WAS_SERVER}" is STOPPED
    fi
  else
    UP_TIME1=`cat ${TEMP_FILE} | grep "java.security.auth.login.config" | grep ${THIS_PROCESS} | grep "${THIS_WAS_SERVER}" | awk '{print $5}'`
    UP_TIME2=`cat ${TEMP_FILE} | grep "java.security.auth.login.config" | grep ${THIS_PROCESS} | grep "${THIS_WAS_SERVER}" |awk '{print $6}'`
    UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
    if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
      UP_TIME="${UP_TIME1}-${UP_TIME2}"
    else
      UP_TIME="${UP_TIME1}"
    fi
    STARTED_BY=`cat ${TEMP_FILE} | grep "java.security.auth.login.config" | grep ${THIS_PROCESS} | grep "${THIS_WAS_SERVER}" | awk '{print $1}'`
    if [ "${FULL_WAS_NAME}" = "YES" ] ; then
      printf "%3s%9s%27s%3s%3s\n" WAS Process: "${THIS_WAS_CELL}/${THIS_WAS_NODE}/${THIS_WAS_SERVER}" is UP
      printf "%12s%8s%8s%9s%5s%8s\n" By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    else
      printf "%3s%9s%14s%3s%3s%4s%9s%8s%9s%5s%8s\n" WAS process: ${THIS_WAS_SERVER} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  fi

done
fi

# Check SNA service
if [ "${CHECK_SNA}" = "YES" ] ; then
  echo
  ALL_SNA_INSTANCES="snadaemon64"
  for THIS_INSTANCE in ${ALL_SNA_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%3s%7s%5s%11s%3s%8s\n" SNA daemon for: ${HOSTNAME} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} |  grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%3s%7s%5s%11s%3s%3s%4s%9s%8s%9s%5s%8s\n" SNA daemon for: ${HOSTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check WMQ queue manager
if [ "${CHECK_WMQ}" = "YES" ] ; then
echo
for THIS_INSTANCE in ${ALL_WMQ_INSTANCES}
do
  THIS_PROCESS=`cat ${TEMP_FILE} | grep "amqzxma0" | grep ${THIS_INSTANCE} | awk '{print $2}'`
  if [ "${THIS_PROCESS}x" = "x" ] ; then
    printf "%5s%21s%3s%8s\n" QMgr: ${THIS_INSTANCE} is STOPPED
  else
    UP_TIME1=`cat ${TEMP_FILE} | grep "amqzxma0" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
    UP_TIME2=`cat ${TEMP_FILE} | grep "amqzxma0" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
    UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
    if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
      UP_TIME="${UP_TIME1}-${UP_TIME2}"
    else
      UP_TIME="${UP_TIME1}"
    fi
    STARTED_BY=`cat ${TEMP_FILE} | grep "amqzxma0" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
    printf "%5s%21s%3s%3s%4s%9s%8s%9s%5s%8s\n" QMgr: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
  fi
done
fi

# Check WMB
if [ "${CHECK_WMB}" = "YES" ] ; then
echo
for THIS_INSTANCE in ${ALL_WMB_INSTANCES}
do
  THIS_PROCESS=`cat ${TEMP_FILE} | grep "bipbroker" | grep ${THIS_INSTANCE} | awk '{print $2}'`
  if [ "${THIS_PROCESS}x" = "x" ] ; then
    printf "%5s%21s%3s%8s\n" WMB: ${THIS_INSTANCE} is STOPPED
  else
    UP_TIME1=`cat ${TEMP_FILE} | grep "bipbroker" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
    UP_TIME2=`cat ${TEMP_FILE} | grep "bipbroker" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
    UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
    if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
      UP_TIME="${UP_TIME1}-${UP_TIME2}"
    else
      UP_TIME="${UP_TIME1}"
    fi
    STARTED_BY=`cat ${TEMP_FILE} | grep "bipbroker" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
    printf "%5s%21s%3s%3s%4s%9s%8s%9s%5s%8s\n" WMB: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
  fi
done
fi

if [ "${CHECK_WMBC}" = "YES" ] ; then
echo
for THIS_INSTANCE in ${ALL_WMBC_INSTANCES}
do
  THIS_PROCESS=`cat ${TEMP_FILE} | grep "bipconfigmgr" | grep ${THIS_INSTANCE} | awk '{print $2}'`
  if [ "${THIS_PROCESS}x" = "x" ] ; then
    printf "%5s%21s%3s%8s\n" Cmgr: ${THIS_INSTANCE} is STOPPED
  else
    UP_TIME1=`cat ${TEMP_FILE} | grep "bipconfigmgr" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
    UP_TIME2=`cat ${TEMP_FILE} | grep "bipconfigmgr" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
    UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
    if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
      UP_TIME="${UP_TIME1}-${UP_TIME2}"
    else
      UP_TIME="${UP_TIME1}"
    fi
    STARTED_BY=`cat ${TEMP_FILE} | grep "bipconfigmgr" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
    printf "%5s%21s%3s%3s%4s%9s%8s%9s%5s%8s\n" Cmgr: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
  fi
done
fi

# Check IBM HTTP Server
if [ "${CHECK_IHS}" = "YES" ] ; then
  echo
  
  for THIS_INSTANCE in ${ALL_IHS_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep ${THIS_INSTANCE} | grep -v "nobody" |grep -v "/usr/IBM/HTTPServer/conf/admin.conf" | awk '{print $2}'`
    PROCESS_COUNT=`cat ${TEMP_FILE} | grep ${THIS_INSTANCE} | wc | awk '{print $1}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%3s%5s%7s%14s%8s\n" IBM HTTP Server is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep -v "nobody" | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep -v "nobody" | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} |  grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep -v "nobody" | awk '{print $1}'`
      printf "%3s%5s%8s%6s%3s%1s%3s%3s%4s%9s%8s%9s%5s%8s\n" IBM HTTP "Server(" count: ${PROCESS_COUNT} ")" is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check ITM UNIX agent
if [ "${CHECK_ITMUX}" = "YES" ] ; then
  echo
  ALL_ITMUX_INSTANCES="kuxagent"
  for THIS_INSTANCE in ${ALL_ITMUX_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%6s%6s%5s%9s%3s%8s\n" ITM-UX agent for: ${HOSTNAME} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%6s%6s%5s%9s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-UX agent for: ${HOSTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check ITM UL agent
if [ "${CHECK_ITMUL}" = "YES" ] ; then
  echo
  ALL_ITMUL_INSTANCES="kulagent"
  for THIS_INSTANCE in ${ALL_ITMUL_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%6s%6s%5s%9s%3s%8s\n" ITM-UL agent for: ${HOSTNAME} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%6s%6s%5s%9s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-UL agent for: ${HOSTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check ITM UM agent
if [ "${CHECK_ITMUM}" = "YES" ] ; then
  echo
  ALL_ITMUM_INSTANCES="kuma"
  for THIS_INSTANCE in ${ALL_ITMUM_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%6s%6s%5s%9s%3s%8s\n" ITM-UM agent for: ${HOSTNAME} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%6s%6s%5s%9s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-UM agent for: ${HOSTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check ITM WAS agent
if [ "${CHECK_ITMYN}" = "YES" ] ; then
  ALL_ITMYN_INSTANCES="kynagent"
  for THIS_INSTANCE in ${ALL_ITMYN_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%6s%6s%5s%10s%3s%8s\n" ITM-YN agent for: WAS is STOPPED      
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%6s%6s%5s%10s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-YN agent for: WAS is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}     
    fi
  done
fi

# Check Patrol for MQ agent
#if [ "${CHECK_ITMMQ}" = "YES" ] ; then
#  ALL_ITMMQ_INSTANCES="mmaelsr"
#  for THIS_INSTANCE in ${ALL_ITMMQ_INSTANCES}
#  do
#    for THIS_MQ_INSTANCE in ${ALL_WMB_INSTANCES}
#    do
#      THIS_MQ_SHORTNAME=`echo ${THIS_MQ_INSTANCE} | awk '{print substr($1,0,8)}'`
#      THIS_PROCESS=`cat ${TEMP_FILE} | grep "opt/BMCS" | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $2}'`
#      if [ "${THIS_PROCESS}x" = "x" ] ; then
#        printf "%6s%6s%5s%9s%3s%8s\n" ITM-MQ agent for: ${THIS_MQ_SHORTNAME} is STOPPED
#      else
#        UP_TIME1=`cat ${TEMP_FILE} | grep "opt/BMCS" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $5}'`
#        UP_TIME2=`cat ${TEMP_FILE} | grep "opt/BMCS" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $6}'`
#        UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
#        if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
#          UP_TIME="${UP_TIME1}-${UP_TIME2}"
#        else
#          UP_TIME="${UP_TIME1}"
#        fi
#        STARTED_BY=`cat ${TEMP_FILE} | grep "opt/BMCS" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $1}'`
#        printf "%6s%6s%5s%9s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-MQ agent for: ${THIS_MQ_SHORTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
#      fi
#    done
#  done
#fi

# Check ITM WMQ agent
if [ "${CHECK_ITMMQ}" = "YES" ] ; then
  ALL_ITMMQ_INSTANCES="kmqagent"
  for THIS_INSTANCE in ${ALL_ITMMQ_INSTANCES}
  do
    for THIS_MQ_INSTANCE in ${ALL_WMQ_INSTANCES}
    do
      THIS_MQ_SHORTNAME=`echo ${THIS_MQ_INSTANCE} | awk '{print substr($1,0,8)}'`
      THIS_PROCESS=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $2}'`
      if [ "${THIS_PROCESS}x" = "x" ] ; then
        printf "%6s%6s%5s%9s%3s%8s\n" ITM-MQ agent for: ${THIS_MQ_SHORTNAME} is STOPPED
      else
        UP_TIME1=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $5}'`
        UP_TIME2=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $6}'`
        UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
        if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
          UP_TIME="${UP_TIME1}-${UP_TIME2}"
        else
          UP_TIME="${UP_TIME1}"
        fi
        STARTED_BY=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_MQ_INSTANCE} | awk '{print $1}'`
        printf "%6s%6s%5s%9s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-MQ agent for: ${THIS_MQ_SHORTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
      fi
    done
  done
fi

# Check ITM DB2 agent
if [ "${CHECK_ITMDB}" = "YES" ] ; then
  ALL_ITMDB_INSTANCES="kuddb2"
  for THIS_INSTANCE in ${ALL_ITMDB_INSTANCES}
  do
    for THIS_DB_INSTANCE in ${ALL_DB2_INSTANCES}
    do
      THIS_PROCESS=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_INSTANCE} | grep ${THIS_DB_INSTANCE} | awk '{print $2}'`
      if [ "${THIS_PROCESS}x" = "x" ] ; then
        printf "%6s%6s%5s%9s%3s%8s\n" ITM-DB agent for: ${THIS_DB_INSTANCE} is STOPPED
      else
        UP_TIME1=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_DB_INSTANCE} | awk '{print $5}'`
        UP_TIME2=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_DB_INSTANCE} | awk '{print $6}'`
        UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
        if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
          UP_TIME="${UP_TIME1}-${UP_TIME2}"
        else
          UP_TIME="${UP_TIME1}"
        fi
        STARTED_BY=`cat ${TEMP_FILE} | grep "itm/aix5" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | grep ${THIS_DB_INSTANCE} | awk '{print $1}'`
        printf "%6s%6s%5s%9s%3s%3s%4s%9s%8s%9s%5s%8s\n" ITM-DB agent for: ${THIS_DB_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
      fi
    done
  done
fi

# Check PATROL agent
if [ "${CHECK_PATROL}" = "YES" ] ; then
  echo
  ALL_PATROL_INSTANCES="PatrolAgent"
  for THIS_INSTANCE in ${ALL_PATROL_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%4s%6s%5s%11s%3s%8s\n" PATROL agent for: ${HOSTNAME} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} |  grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%4s%6s%5s%11s%3s%3s%4s%9s%8s%9s%5s%8s\n" PATROL agent for: ${HOSTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check AMOS
if [ "${CHECK_AMOS}" = "YES" ] ; then
  echo
  ALL_AMOS_INSTANCES="pdosd"
  for THIS_INSTANCE in ${ALL_AMOS_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
      printf "%4s%6s%5s%11s%3s%8s\n" AMOS agent for: ${HOSTNAME} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} |  grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%4s%6s%5s%11s%3s%3s%4s%9s%8s%9s%5s%8s\n" AMOS agent for: ${HOSTNAME} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check HACMP
if [ "${CHECK_HACMP}" = "YES" ] ; then
  echo
  for THIS_INSTANCE in ${ALL_HACMP_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep "harmad" | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
    printf "%6s%20s%3s%8s\n" HACMP: ${THIS_HACMP_INSTANCE} is STOPPED
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep "harmad" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep "harmad" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} | grep "harmad" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%6s%20s%3s%3s%4s%9s%8s%9s%5s%8s\n" HACMP: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
    fi
  done
fi

# Check DES
if [ "${CHECK_DES}" = "YES" ] ; then
  echo
  for THIS_INSTANCE in ${ALL_DES_INSTANCES}
  do
    THIS_PROCESS=`cat ${TEMP_FILE} | grep "java" | grep ${THIS_INSTANCE} | awk '{print $2}'`
    if [ "${THIS_PROCESS}x" = "x" ] ; then
    printf "%3s%8s%18s%9s%3s%8s\n" DES Server: ${THIS_DES_INSTANCE} is STOPPED    
    else
      UP_TIME1=`cat ${TEMP_FILE} | grep "java" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
      UP_TIME2=`cat ${TEMP_FILE} | grep "java" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
      UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
      if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
        UP_TIME="${UP_TIME1}-${UP_TIME2}"
      else
        UP_TIME="${UP_TIME1}"
      fi
      STARTED_BY=`cat ${TEMP_FILE} | grep "java" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
      printf "%3s%8s%15s%3s%3s%4s%9s%8s%9s%5s%8s\n" DES Server: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}           
    fi
  done
fi

# Check NMON
if [ "${CHECK_NMON}" = "YES" ] ; then
echo
for THIS_INSTANCE in ${ALL_NMON_INSTANCES}
do
  THIS_PROCESS=`cat ${TEMP_FILE} | grep "topas_nmon" |grep -v grep | grep ${THIS_INSTANCE} | awk '{print $2}'`
  if [ "${THIS_PROCESS}x" = "x" ] ; then
  printf "%12s%12s%3s%8s\n" NMON-instance: ${THIS_INSTANCE} is STOPPED
  else
    UP_TIME1=`cat ${TEMP_FILE} | grep "topas_nmon" |grep -v grep | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $5}'`
    UP_TIME2=`cat ${TEMP_FILE} | grep "topas_nmon" |grep -v grep | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $6}'`
    UP_TIME_LENGTH=`echo ${UP_TIME1} | awk '{print(length($1))}'`
    if [ ${UP_TIME_LENGTH} -eq 3 ] ; then
      UP_TIME="${UP_TIME1}-${UP_TIME2}"
    else
      UP_TIME="${UP_TIME1}"
    fi
    STARTED_BY=`cat ${TEMP_FILE} | grep "topas_nmon" | grep ${THIS_PROCESS} | grep ${THIS_INSTANCE} | awk '{print $1}'`
    printf "%12s%12s%3s%3s%4s%9s%8s%9s%5s%8s\n" NMON-instance: ${THIS_INSTANCE} is UP By: ${STARTED_BY} Uptime: ${UP_TIME} PID: ${THIS_PROCESS}
  fi
done
fi

echo
rm ${TEMP_FILE}
