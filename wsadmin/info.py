# cat << EOF > test4py.py 

#print Help.help()
# print AdminControl.help()
# print AdminConfig.help()
# print AdminTask.help()
# print AdminConfig.list('ProcessExecution')
# print AdminControl.queryNames('*')

#SOBJ=AdminControl.queryNames('type=Server,cell='+Cell+',node='+Node+',*')
#AdminControl.queryNames('cell='+Cell+',node='+Node+',*')
#print AdminControl.queryNames('type=JDBCProvider,cell='+Cell+',node='+Node+',*')
print AdminControl.queryNames('type=JDBCProvider,cell='+Cell+',node='+Node+',name=DB2 Using IBM JCC Driver,*')
print AdminControl.queryNames('type=DataSource,cell='+Cell+',node='+Node+',name=test,*')
#print AdminControl.queryNames('type=DataSource,cell='+Cell+',node='+Node+',*')

OBJ=AdminControl.queryNames('type=DataSource,cell='+Cell+',node='+Node+',name=test,*')
print AdminControl.getAttributes(OBJ)

#ID= AdminConfig.list('Cell')
#print AdminConfig.list('JDBCProvider',ID)

#SID=AdminConfig.list('ApplicationServer')
#print AdminControl.getAttributes(SID)
#print AdminControl.getAttribute(SID, 'name')
#AdminControl.queryNames('type=ApplicationServer,cell='+Cell+',node='+Node+',*')

print AdminControl.getHost()
Cell=AdminControl.getCell()
Node=AdminControl.getNode()
#Server=AdminConfig.list('ApplicationServer')
SOBJ=AdminControl.queryNames('type=Server,cell='+Cell+',node='+Node+',j2eeType=J2EEServer,*')
Server=AdminControl.getAttribute(SOBJ,'name')

print 'list env :\n'
print '\n AdminControl.getCell() : '+Cell
print '\n AdminControl.getNode() : '+Node
print '\n Server : '+Server
#print 'AdminConfig.list(Server) :\n' +AdminConfig.list('Server')
print 'AdminConfig.list(WebServer) :\n' +AdminConfig.list('WebServer')
print 'AdminConfig.list(ApplicationServer) :\n'+AdminConfig.list('ApplicationServer')
print '##############################################################################'


print '\n  adminConfig.list(ManagementScope) : \n'
print AdminConfig.list('ManagementScope')

print '\n JDBCProvider :\n'
print AdminConfig.list('JDBCProvider')

print '\n DataSource :\n'
print AdminConfig.list('DataSource')

#print AdminConfig.list('Application')
#print '\n App :\n'
print '\n AdminApp.list() :\n'
print AdminApp.list()


print '##############################################################################'
print '\n list MQ :\n'
print '\n list QCF :\n'
print AdminConfig.list('MQQueueConnectionFactory')
print '\n list Q :\n'
print AdminConfig.list('MQQueue')

print '##############################################################################'
print '\n AdminConfig.getid() : \n'
#print AdminConfig.getid('/Cell:DefaultCell01')
print AdminConfig.getid('/Cell:'+Cell)

#print AdminConfig.showall(Server)
#print AdminConfig.showall('qcf1(cells/DefaultCell01|resources.xml#MQQueueConnectionFactory_1629268386276)')

#LIST=AdminConfig.list('MQQueueConnectionFactory').splitlines()
#print 'LIST=\n'+LIST
#print '\n  \n'
#for ID in LIST:
#    print 'ID='+ID
#    print AdminConfig.showall(ID)

print '\n END : \n'

#print AdminConfig.list('DataSource','/Cell:DefaultCell01/')
#print AdminConfig.list('Server')

#print AdminControl.testConnection('[cells/DefaultCell01|resources.xml#DataSource_1607411122093]')

#print AdminTask.listServers('[-serverType APPLICATION_SERVER ]')
#print AdminConfig.list('DataSource', AdminConfig.getid( '/Cell:DefaultCell01/'))

