
print AdminControl.getHost()
Cell=AdminControl.getCell()
Node=AdminControl.getNode()
#Server=AdminConfig.list('ApplicationServer')
SOBJ=AdminControl.queryNames('type=Server,cell='+Cell+',node='+Node+',j2eeType=J2EEServer,*')
Server=AdminControl.getAttribute(SOBJ,'name')
print 'Cell= '+Cell+' Node= '+Node+' Server= '+Server

print 'JDBCProvider : '+AdminConfig.list('JDBCProvider')

AdminTask.createJDBCProvider('[-scope Cell='+Cell+' -databaseType DB2 -providerType "DB2 Universal JDBC Driver Provider" -implementationType "Connection pool data source" -name "xDB2 Universal JDBC Driver Provider" -description "One-phase commit DB2 JCC provider" -classpath [${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc.jar ${UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc_license_cu.jar ${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc_license_cisuz.jar ] -nativePath [${DB2UNIVERSAL_JDBC_DRIVER_NATIVEPATH} ] ]') 

print 'JDBCProvider : '+AdminConfig.list('JDBCProvider')
AdminConfig.save()


