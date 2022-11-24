//import lotus.domino.*;
//import java.sql.*;

//import com.ibm.db2.jcc.DB2Diagnosable;
//import com.ibm.db2.jcc.DB2Sqlca; 
import java.lang.*;
import java.sql.*;
import java.io.PrintWriter;
import java.net.*;


//public class JavaAgent extends AgentBase {
public class db2DriverTest {
	public static void checkHost(String sHost) {  
	       Timestamp start_ts = new java.sql.Timestamp(new java.util.Date().getTime()); 
	       System.out.println ("start time: " + start_ts); 
	       
	       InetAddress ip;
           String hostname;
           
        try {
            ip = InetAddress.getLocalHost();
            displayStuff("local host", ip);
            
            if (sHost !="") {
               ip = InetAddress.getByName(sHost);
			   displayStuff(sHost, ip);
			}   
			
            //hostname = ip.getHostName();
            //System.out.println("Your current IP address : " + ip);
            //System.out.println("Your current Hostname : " + hostname);
 
        } catch (UnknownHostException e) {
 
            e.printStackTrace();
        }
	                	
	       Timestamp end_ts = new java.sql.Timestamp(new java.util.Date().getTime());		
		   System.out.println ("end   time: " + end_ts);
		   //System.out.println ("different : " + end_ts.compareTo(start_ts));      
		   System.out.println("============================================");  	
	
	}
	
	public static void displayStuff(String whichHost, InetAddress inetAddress) {
		System.out.println("--------------------------");
		System.out.println("Which Host:" + whichHost);
		System.out.println("Canonical Host Name:" + inetAddress.getCanonicalHostName());
		System.out.println("Host Name:" + inetAddress.getHostName());
		System.out.println("Host Address:" + inetAddress.getHostAddress());
	}
	
	public static void main( String argv[]) {    	
           	//
           	String shost ="";
           	System.out.println("argv.length:"+argv.length);
           	if (argv.length == 5) {
           		shost = argv[4];
           		System.out.println("Check db server by ip/hostname:"+shost);
           		checkHost(shost);
           		//return;
           		           		
           	} else if (argv.length != 4) {
           		System.out.println("Usage : java db2DriverTest $driver $dbURL $ID $Password");
           		System.out.println("JDBC Type 4 for db2 UDB driver(db2jcc.jar):");
           		System.out.println("java db2DriverTest com.ibm.db2.jcc.DB2Driver jdbc:db2://localhost:50000/sample db2admin db2admin");
           		System.out.println("\nJDBC Type 2 for db2 UDB driver(db2jcc.jar):");
           		System.out.println("java db2DriverTest com.ibm.db2.jcc.DB2Driver jdbc:db2:sample db2admin db2admin");
           		System.out.println("\nJDBC Type 2 for db2 legacy driver(db2java.zip):");
           		System.out.println("java db2DriverTest COM.ibm.db2.jdbc.app.DB2Driver jdbc:db2:sample db2admin db2admin");
           		System.out.println("\nJDBC Type 3 for db2 legacy driver(db2java.zip):");
           		System.out.println("java db2DriverTest COM.ibm.db2.jdbc.net.DB2Driver jdbc:db2:localhost:6789:sample db2admin db2admin");
           		return;
            } else {
            	checkHost("");            
           	}	           	
           	Timestamp start_ts = new java.sql.Timestamp(new java.util.Date().getTime());           	
           	// 相關基本變數資料						
         	String dbdriver = argv[0];
         	String dburl = argv[1];		
         	String user =  argv[2];
       		String password = argv[3];
       		//String shost = argv[4];
       		
       		System.out.println ("System.getProperties(): " + System.getProperties());
       		
       		System.out.println ("current time: " + start_ts);
       		       		
                
		String sqlstmt = "sqlstmt";			
	//public void NotesMain() {		

		try {
			//Session session = getSession();
			//AgentContext agentContext = session.getAgentContext();
 
              System.out.println("======> load driver name : "+dbdriver);               
//			  Driver drv = (Driver)Class.forName(dbdriver).newInstance();
      	     Class.forName(dbdriver).newInstance();
               
              System.out.println("======> load driver");
               Connection con=DriverManager.getConnection(dburl,user,password);
               
               con.setAutoCommit(true);
               con.setTransactionIsolation(con.TRANSACTION_READ_UNCOMMITTED);
	  System.out.println(" con.getAutoCommit() :" + con.getAutoCommit());		
	  	  System.out.println(" con.getTransactionIsolation() :" + con.getTransactionIsolation());		              
              //==================================================
              // 顯示 jdbc 版本
              //==================================================
          System.out.println("======> Display connection Info: ");    
          DatabaseMetaData dma = con.getMetaData();
  	  System.out.println("\nConnected to " + dma.getURL());
	  System.out.println("Driver           " + dma.getDriverName());
	  System.out.println("Version          " + dma.getDriverVersion());
	  System.out.println("JDBC BuildNumber " + dma.getDriverMinorVersion());	  
          System.out.println("==> JDBC connection is OK");
 
sqlstmt = "select count(*) from syscat.tables";
//sqlstmt = " select SUBSTR(MOD_PKE7,16,7) csno,SUBSTR(MOD_PKE7,9,7) odrDate,  MOD_PKE7,MOD_SNAM, MOD_STTM,  MOD_EDD7, MOD_STD7, DFE_SNAM,MOD_DCHR, MOD_USDS, MOD_DSUT, MOD_FRQN, MOD_ROUT from RXIMMODR, OPDMDFEE  where SUBSTR(MOD_PKE7,1,8) = '10508462'  AND ((MOD_EDD7 >= '1050428' And MOD_STD7 <= '1050428' ) OR MOD_EDD7 = '') AND SUBSTR(MOD_PKE7,16,7) = DFE_CODN AND DFE_TYPE = 'SKH' AND MOD_DCHR IN ('1','2','3') ORDER BY  odrDate, MOD_STTM";
System.out.println("----> execute SQL Statement .....");
System.out.println("SQL Statement==> "+sqlstmt);
System.out.println("Start to Select Table ....");
System.out.println("============================================");
           
Statement stmt = con.createStatement();
System.out.println("stmt.getQueryTimeout() :"+stmt.getQueryTimeout());
ResultSet rs = stmt.executeQuery(sqlstmt);
ResultSetMetaData md = rs.getMetaData();
int columnNum = md.getColumnCount();

if (rs != null && rs.next()) {   
//rs.next(); 	
   System.out.println("=====> Select result : " + rs.getString(1)); 
} else System.out.println("====>No result !! ");
	
			
			// (Your code goes here) 
			rs.close();
			stmt.close();
                    
		System.out.println ("start time: " + start_ts);
		Timestamp end_ts = new java.sql.Timestamp(new java.util.Date().getTime());
		System.out.println ("end   time: " + end_ts);
		System.out.println ("different : " + end_ts.compareTo(start_ts));
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}

