#!/bin/bash
#JPATH=/Users/apple/Documents/PDtools/TEST/mqDriver
export PATH=/opt/mqm/java/jre64/jre/bin:$PATH
#export PATH=/opt/mqm/java/jre64/jre/bin:$PATH
#JPATH=/home/mqm/mqDriver
MQHOST=localhost
MQPORT=1414
JPATH=/Users/apple/Documents/PDtools/TEST/mqDriver
MQQMGR=QM1
#MQCHL=DEV.APP.SVRCONN 
MQCHL=DEV.TLS.SVRCONN 
MQQ=DEV.QUEUE.1
#KSPATH=/opt/mqm/java/jre64/jre/lib/security
KSPATH=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/jre/lib/security
CLASSPATH=$JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:.:$CLASSPATH

JMSTRC=" -Dcom.ibm.mq.cfg.useIBMCipherMappings=false "
#JMSTRC=" -Dcom.ibm.msg.client.commonservices.trace.status=ON -Dcom.ibm.mq.integrateJMSTrace=true -Dcom.ibm.mq.cfg.useIBMCipherMappings=false"

SSLPARM="-Djavax.net.ssl.trustStoreType=cms -Djavax.net.ssl.trustStore=/var/mqm/qmgrs/QM2/ssl/mqkey.kdb "
#JREKS=" -Djavax.net.debug=ssl -Djavax.net.ssl.keyStore=/opt/mqm/java/jre64/jre/lib/security/javaks -Djavax.net.ssl.keyStorePassword=changeit "
JREKS=" -Djavax.net.debug=ssl:handshake -Djavax.net.ssl.keyStore=${KSPATH}/rsaks -Djavax.net.ssl.keyStorePassword=changeit "
JRETS=" -Djavax.net.ssl.trustStore=${KSPATH}/cacerts  -Djavax.net.ssl.trustStorePassword=changeit"
#SSLCIPH="SSL_RSA_WITH_AES_128_CBC_SHA256"
SSLCIPH="TLS_RSA_WITH_AES_128_CBC_SHA256"

echo CLASSPATH=$CLASSPATH
#javac JmsPutGet.java
#javac -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet.java

#java  -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient-9.1.2.0.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet
#java  -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient-9.1.2.0.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet localhost 1414 DEV.APP.SVRCONN QM1 DEV.QUEUE.1
#java  -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ
#java  -Dcom.ibm.mq.cfg.useIBMCipherMappings=false -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ
#java  -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ none
#java  -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ "*TLS12"

#java  $JREKS $JRETS -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ "*TLS12"

echo "java  $JMSTRC $JREKS $JRETS JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ $SSLCIPH "

java  $JMSTRC $JREKS $JRETS JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ $SSLCIPH
#java  $JREKS $JRETS -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ "SSL_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256"
#java $SSLPARM -cp $JPATH/com.ibm.mqjms.jar:$JPATH/com.ibm.mq.allclient.jar:$JPATH/javax.jms-api-2.0.1.jar:. JmsPutGet $MQHOST $MQPORT $MQCHL $MQQMGR $MQQ "*TLS12"

