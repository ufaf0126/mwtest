
import com.ibm.mq.*; //Include the WebSphere MQ classes for Java package

public class MQSample {

    // code identifier
    public static final String sccsid   = "@(#) javabase/samples/MQSample.java, java, j600, j600-200-060630 1.10.1.1 05/05/25 15:18:01";

    // define the name of the QueueManager 
    private static final String qManager = "MQ00";
    // and define the name of the Queue
    private static final String qName = "SYSTEM.DEFAULT.LOCAL.QUEUE";
    
    // main method: simply call the runSample() method
    public static void main(String args[]) {
        //new MQSample().runSample();
        
        MQSample sample = new MQSample();
        System.out.println("Put Message usage: java MQSample $QMGR $Q $MSG");
        System.out.println("Get Message usage: java MQSample $QMGR $Q");
        MQQueueManager qmgr = sample.getQmgr(args[0]);
        if (args.length >= 3)
            sample.putMessage(qmgr,args[1],args[2]);
        else    
            sample.getMessage(qmgr,args[1]);
        sample.close(qmgr);
    }

    public MQQueueManager getQmgr(String qmgr_name) {
    	   MQQueueManager qmgr = null;
    	try {
            // Create a connection to the QueueManager
            System.out.println("Connecting to queue manager: "+qmgr_name);
            qmgr = new MQQueueManager(qmgr_name);            
        } catch (MQException ex) {
            System.out.println("A WebSphere MQ Error occured : Completion Code "
                    + ex.completionCode + " Reason Code " + ex.reasonCode);        
            ex.printStackTrace();        
        } 
    	   return qmgr;
    }
    
    public void close(MQQueueManager qmgr) {    	   
    	try {           
            qmgr.disconnect();
        } catch (MQException ex) {
            System.out.println("A WebSphere MQ Error occured : Completion Code "
                    + ex.completionCode + " Reason Code " + ex.reasonCode);        
            ex.printStackTrace();        
        }     	   
    }
    
    public void getMessage(MQQueueManager qmgr,String q_name) {
    	try {
    	   // Set up the options on the queue we wish to open 
            int openOptions = MQC.MQOO_INPUT_AS_Q_DEF;

            // Now specify the queue that we wish to open and the open options
            System.out.println("get queue: "+q_name);
            MQQueue queue = qmgr.accessQueue(q_name, openOptions);
            MQMessage rcvMessage = new MQMessage();
            
            // Specify default get message options 
            MQGetMessageOptions gmo = new MQGetMessageOptions();

            // Get the message off the queue.            
            queue.get(rcvMessage, gmo);

            // And display the message text...
            String msgText = rcvMessage.readUTF();
            System.out.println("The message is: " + msgText);

            // Close the queue
            System.out.println("Closing the queue");
            queue.close();
        } catch (MQException ex) {
            System.out.println("A WebSphere MQ Error occured : Completion Code "
                    + ex.completionCode + " Reason Code " + ex.reasonCode);
            ex.printStackTrace();        
        } catch (java.io.IOException ex) {
            System.out.println("An IOException occured whilst writing to the message buffer: "
                    + ex);
            ex.printStackTrace();        
        }    
    }	
    
    public void putMessage(MQQueueManager qmgr,String q_name,String txt) {
    	try {
    	   // Set up the options on the queue we wish to open 
            int openOptions = MQC.MQOO_OUTPUT;

            // Now specify the queue that we wish to open and the open options
            System.out.println("put queue: "+q_name);
            MQQueue queue = qmgr.accessQueue(q_name, openOptions);
            MQMessage msg = new MQMessage();            
            msg.writeUTF(txt);

            // Specify the default put message options
            MQPutMessageOptions pmo = new MQPutMessageOptions();

            // Put the message to the queue
            System.out.println("Putting a message...");
            queue.put(msg, pmo);

            // Close the queue
            System.out.println("Closing the queue");
            queue.close();
        } catch (MQException ex) {
            System.out.println("A WebSphere MQ Error occured : Completion Code "
                    + ex.completionCode + " Reason Code " + ex.reasonCode);
            ex.printStackTrace();        
        } catch (java.io.IOException ex) {
            System.out.println("An IOException occured whilst writing to the message buffer: "
                    + ex);
            ex.printStackTrace();        
        }    
    }	
	
    public void runSample() {

        try {
            // Create a connection to the QueueManager
            System.out.println("Connecting to queue manager: "+qManager);
            MQQueueManager qMgr = new MQQueueManager(qManager);

            // Set up the options on the queue we wish to open 
            int openOptions = MQC.MQOO_INPUT_AS_Q_DEF | MQC.MQOO_OUTPUT;

            // Now specify the queue that we wish to open and the open options
            System.out.println("Accessing queue: "+qName);
            MQQueue queue = qMgr.accessQueue(qName, openOptions);

            // Define a simple WebSphere MQ Message ... 
            MQMessage msg = new MQMessage();
            // ... and write some text in UTF8 format
            msg.writeUTF("Hello, World!");

            // Specify the default put message options
            MQPutMessageOptions pmo = new MQPutMessageOptions();

            // Put the message to the queue
            System.out.println("Sending a message...");
            queue.put(msg, pmo);

            // Now get the message back again. First define a WebSphere MQ message 
            // to receive the data 
            MQMessage rcvMessage = new MQMessage();
            
            // Specify default get message options 
            MQGetMessageOptions gmo = new MQGetMessageOptions();

            // Get the message off the queue.
            System.out.println("...and getting the message back again");
            queue.get(rcvMessage, gmo);

            // And display the message text...
            String msgText = rcvMessage.readUTF();
            System.out.println("The message is: " + msgText);

            // Close the queue
            System.out.println("Closing the queue");
            queue.close();

            // Disconnect from the QueueManager
            System.out.println("Disconnecting from the Queue Manager");
            qMgr.disconnect();
            System.out.println("Done!");
        }
        catch (MQException ex) {
            System.out.println("A WebSphere MQ Error occured : Completion Code "
                    + ex.completionCode + " Reason Code " + ex.reasonCode);
            ex.printStackTrace();        
        }
        catch (java.io.IOException ex) {
            System.out.println("An IOException occured whilst writing to the message buffer: "
                    + ex);
            ex.printStackTrace();        
        }
    }
} 