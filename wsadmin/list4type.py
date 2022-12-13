import os
import sys
oType = sys.argv[0]
sFlag1 = sys.argv[1]
sFlag2 = sys.argv[2]

Cell=AdminControl.getCell()
Node=AdminControl.getNode()
#Server=AdminConfig.list('ApplicationServer')
OBJ=AdminConfig.list('ApplicationServer')
Server=AdminConfig.showAttribute(OBJ,'name')

print '\n Cell=%s Node=%s Server=%s Type=%s %s %s '%(Cell,Node,Server,oType,sFlag1,sFlag2)

#print AdminConfig.list('VariableSubstitutionEntry', AdminConfig.getid('/Cell:DefaultCell01/Node:DefaultNode01/Server:server1/'))

OPATH='/Cell:%s/'%(Cell)
#OPATH='/Cell:%s/Node:%s/'%(Cell,Node)
#OPATH='/Cell:%s/Node:%s/Server:%s/'%(Cell,Node,Server)
#LIST=AdminConfig.list('VariableSubstitutionEntry', AdminConfig.getid(OPATH)).splitlines()
if (oType == 'HostAlias'):
    OPATH='/Cell:%s/VirtualHost:default_host/'%(Cell)
    print 'OPATH='+OPATH
    LIST=AdminConfig.list(oType, AdminConfig.getid(OPATH)).splitlines()
    #print 'LIST=\n'+AdminConfig.list(oType, AdminConfig.getid(OPATH))
else :    
    LIST=AdminConfig.list(oType).splitlines()
#print     

if (sFlag1 == 'y'):
    print 'LIST=\n'+AdminConfig.list(oType)
print '\n'

if (sFlag2 == 'y'):
 for ID in LIST:    
    print 'ID='+ID+'\n'+AdminConfig.show(ID)+' \n'
    #print 'ID='+ID+'\n'+AdminConfig.showall(ID)+' \n'
print '\n END : \n'

#AdminConfig.save()