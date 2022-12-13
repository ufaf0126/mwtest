
print AdminControl.getHost()
Cell=AdminControl.getCell()
Node=AdminControl.getNode()
#Server=AdminConfig.list('ApplicationServer')
SOBJ=AdminControl.queryNames('type=Server,cell='+Cell+',node='+Node+',j2eeType=J2EEServer,*')
Server=AdminControl.getAttribute(SOBJ,'name')
print 'Cell= '+Cell+' Node= '+Node+' Server= '+Server

print AdminTask.showJVMProperties('[-nodeName '+Node+' -serverName '+Server+']')
AdminTask.setJVMProperties('[-nodeName '+Node+' -serverName ' +Server+' -maximumHeapSize 768 -verboseModeGarbageCollection true]') 
print AdminTask.showJVMProperties('[-nodeName '+Node+' -serverName '+Server+']')
AdminConfig.save()
