# cat << EOF > chg4var.py 

Cell=AdminControl.getCell()
Node=AdminControl.getNode()
#Server=AdminConfig.list('ApplicationServer')
OBJ=AdminConfig.list('ApplicationServer')
Server=AdminConfig.showAttribute(OBJ,'name')

print '\n Cell=%s Node=%s Server=%s \n'%(Cell,Node,Server)

#print AdminConfig.list('VariableSubstitutionEntry', AdminConfig.getid('/Cell:DefaultCell01/Node:DefaultNode01/Server:server1/'))

OPATH='/Cell:%s/'%(Cell)
#OPATH='/Cell:%s/Node:%s/'%(Cell,Node)
#OPATH='/Cell:%s/Node:%s/Server:%s/'%(Cell,Node,Server)
LIST=AdminConfig.list('VariableSubstitutionEntry', AdminConfig.getid(OPATH)).splitlines()
#print 'LIST=\n'+LIST
print '\n  \n'
for ID in LIST:
    #print '\n ID='+ID
    #print AdminConfig.showall(ID)+' \n'
    #print AdminConfig.showAttribute(ID,'symbolicName')+' \n'
    OCOL=AdminConfig.showAttribute(ID,'symbolicName')
    if (OCOL == 'LOG_ROOT'):
        OCOLV=AdminConfig.showAttribute(ID,'value')
        #print '\n \' ID \' ='+ID
        print ' \n %s = %s'%(OCOL,OCOLV)
        #OCOLV='/waslog'
        OCOLV='${USER_INSTALL_ROOT}/logs'
        print '\n AdminConfig.modify(\'%s\', \'[[symbolicName %s] [value \"%s\"]]\')'%(ID,OCOL,OCOLV)
        OCHG='[[symbolicName '+OCOL+'] [description "The filesystem path to the directory which will contain server log files."] [value \"'+OCOLV+'\"]]'
        print '\n Change : AdminConfig.modify(%s,%s)'%(ID,OCHG)
        AdminConfig.modify(ID,OCHG)
        

    if (OCOL == 'DB2_JCC_DRIVER_PATH' or OCOL == 'DB2_JDBC_DRIVER_PATH' or OCOL == 'DB2UNIVERSAL_JDBC_DRIVER_PATH'):
        OCOLV=AdminConfig.showAttribute(ID,'value')
        #print ID+' show :'+AdminConfig.showall(ID)+' \n'
        print ' \n %s = %s'%(OCOL,OCOLV)
        OCOLV='/opt/IBM/WebSphere/AppServer/db2driver'
        print '\n AdminConfig.modify(\'%s\', \'[[symbolicName %s] [value \"%s\"]]\')'%(ID,OCOL,OCOLV)    
        OCHG='[[symbolicName '+OCOL+'] [value '+OCOLV+']]'
        print '\n Change : AdminConfig.modify(\'%s\',\'%s\')'%(ID,OCHG)
        AdminConfig.modify(ID,OCHG)
        

print '\n END : \n'

AdminConfig.save()