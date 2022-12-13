# cat << EOF > test4py.py 

#print Help.help()
#print AdminControl.help()
#print AdminConfig.help()

Cell=AdminControl.getCell()
Node=AdminControl.getNode()
#Server=AdminConfig.list('ApplicationServer')
OBJ=AdminConfig.list('ApplicationServer')
Server=AdminConfig.showAttribute(OBJ,'name')

#print AdminControl.queryNames('type=Server,cell='+Cell+',node='+Node+',j2eeType=J2EEServer,*')

print '\n Cell=%s Node=%s Server=%s \n'%(Cell,Node,Server)

#print 'AdminConfig.list(Server) :\n' +AdminConfig.list('Server')
#print 'AdminConfig.list(WebServer) :\n' +AdminConfig.list('WebServer')
#print 'AdminConfig.list(ApplicationServer) :\n'+AdminConfig.list('ApplicationServer')
#print AdminConfig.types()
#print AdminConfig.list('ManagementScope')



#print AdminConfig.showall(Server)
#print AdminConfig.showall('qcf1(cells/DefaultCell01|resources.xml#MQQueueConnectionFactory_1629268386276)')
#LIST=AdminConfig.list('MQQueueConnectionFactory').splitlines()

print AdminConfig.list('VariableSubstitutionEntry', AdminConfig.getid( '/Cell:DefaultCell01/Node:DefaultNode01/Server:server1/'))

OPATH='/Cell:%s/'%(Cell)
#OPATH='/Cell:%s/Node:%s/'%(Cell,Node)
#OPATH='/Cell:%s/Node:%s/Server:%s/'%(Cell,Node,Server)
LIST=AdminConfig.list('VariableSubstitutionEntry', AdminConfig.getid(OPATH)).splitlines()
#print 'LIST=\n'+LIST
print '\n  \n'
for ID in LIST:
    print '\n ID='+ID
    #print AdminConfig.showall(ID)+' \n'
    #print AdminConfig.showAttribute(ID,'symbolicName')+' \n'
    OCOL=AdminConfig.showAttribute(ID,'symbolicName')
    if (OCOL == 'LOG_ROOT'):
        OCOLV=AdminConfig.showAttribute(ID,'value')
        print ' \n %s = %s'%(OCOL,OCOLV)

print '\n END : \n'

#print AdminConfig.list('DataSource','/Cell:DefaultCell01/')
#print AdminConfig.list('Server')

#print AdminControl.testConnection('[cells/DefaultCell01|resources.xml#DataSource_1607411122093]')

#print AdminTask.listServers('[-serverType APPLICATION_SERVER ]')
#print AdminConfig.list('DataSource', AdminConfig.getid( '/Cell:DefaultCell01/'))

