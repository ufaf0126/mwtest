
export PATH=/usr/java14/bin:$PATH
#DB2Driver=/home/db2inst1/sqllib/java
DB2Driver=/usr/IBM/WebSphere/AppServer/db2Driver
#DB2Driver=/home/wasadmin/sqllib/java
export CLASSPATH=.:$DB2Driver/db2fs.jar:$DB2Driver/db2java.zip:$DB2Driver/db2jcc.jar:$DB2Driver/db2jcc_javax.jar:$DB2Driver/db2jcc_license_cisuz.jar:$DB2Driver/db2jcc_license_cu.jar:$DB2Driver/db2policy.jar
#export LIBPATH=/usr/lib:/lib:/home/db2inst1/sqllib/lib
#export LIBPATH=/usr/lib:/lib:/home/wasadmin/sqllib/lib32

#AP_USER=db2inst1
AP_USER=SKHRBD
#AP_PW=12345678
#AP_PW=db2inst1
AP_PW=SKHRBD
#HOST=10.153.103.218
#HOST=10.153.103.212
HOST=10.1.200.1
#PORT=60000
PORT=448
#DB=DA-AP001-APb
#DB=sample
DB=DSNTEST

TYPE2_DB2CLASS=com.ibm.db2.jcc.DB2Driver
#TYPE2_DB2CLASS=COM.ibm.db2.jdbc.app.DB2Driver
TYPE2_URL=jdbc:db2:$DB
TYPE3_DB2CLASS=COM.ibm.db2.jdbc.net.DB2Driver
TYPE3_URL=jdbc:db2:$HOST:$PORT:$DB
TYPE4_DB2CLASS=com.ibm.db2.jcc.DB2Driver
TYPE4_URL=jdbc:db2://$HOST:$PORT/$DB

#echo JDBC test for type 2 : java db2DriverTest $TYPE2_DB2CLASS $TYPE2_URL $AP_USER $AP_PW
#java db2DriverTest $TYPE2_DB2CLASS $TYPE2_URL $AP_USER $AP_PW
#java db2DriverTest $TYPE3_DB2CLASS $TYPE3_URL $AP_USER $AP_PW
echo JDBC test for type 4 : java db2DriverTest $TYPE4_DB2CLASS $TYPE4_URL $AP_USER $AP_PW
java db2DriverTest $TYPE4_DB2CLASS $TYPE4_URL $AP_USER $AP_PW
