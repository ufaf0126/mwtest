#!/bin/bash
#JDK_PATH=/usr/java14/bin
JDK_PATH=/usr/bin
#export PATH=$JDK_PATH:$PATH
#MQDriver=/usr/mqm/java/lib
MQDriver=/Users/samlin/Documents/PDtools/TEST/mqDriver

#MQSERVER="DEV.APP.SVRCONN/TCP/localhost(1414)"

export LIBPATH=$MQDriver
export LD_LIBRARY_PATH=$MQDriver
#export CLASSPATH=.:$MQDriver/com.ibm.mq.jar:$MQDriver/com.ibm.mqjms.jar:$MQDriver/com.ibm.mq.jms.Nojndi.jar
export CLASSPATH=.:$MQDriver/com.ibm.mq.jar:$MQDriver/com.ibm.mqjms.jar:$MQDriver/com.ibm.mq.allclient.jar

echo "CLASSPATH = $CLASSPATH"

QMGR=QM2
QR=MQMT.FT.FILETX.QR
QL=DEV.APP.SVRCONN
#QL=SYSTEM.DEFAULT.LOCAL.QUEUE
#QL=MQMT.FT.FILETX.QL

# $JDK_PATH/javac MQSample.java

#echo MQ Put Test: $JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QR hi
#$JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QR hi
#echo MQ Get Test: $JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QL
#$JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QL

echo MQ Put Test:$JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QL hi
$JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QL hi
echo MQ Get Test: $JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QL
$JDK_PATH/java -Djava.library.path=$MQDriver MQSample $QMGR $QL
