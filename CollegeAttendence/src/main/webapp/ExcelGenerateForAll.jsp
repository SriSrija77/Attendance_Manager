<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.io.*,java.util.Date,java.text.DecimalFormat,java.util.*"%>
     <%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page import="org.apache.poi.ss.usermodel.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%Date date=new Date();
String datestring=date.toString().replace(" ","");
String datestring1=datestring.replace(":","-");

String studentid=(String)session.getAttribute("studentid");
String startdate=(String)session.getAttribute("startdate");
String enddate=(String)session.getAttribute("enddate");
String dbDriver = "com.mysql.cj.jdbc.Driver"; 
String dbURL = "jdbc:mysql://localhost:3306/"; 
String dbName = "attendancereport"; 
String dbUsername = "root"; 
String dbPassword = ""; 
Class.forName(dbDriver);
Connection con = DriverManager.getConnection(dbURL + dbName, 
        dbUsername,  
        dbPassword);
double total=0;
double temp=0;
try {
	int row=0;
	String namefile=studentid+"_Release"+datestring1;
	String filename="G:/CollegeAttendence//"+namefile+".xls" ;
	HSSFWorkbook hwb=new HSSFWorkbook();
	HSSFSheet sheet =  hwb.createSheet("new sheet");

	PreparedStatement p=con.prepareStatement("select distinct Subject from attendence where StudentId=? and (Date BETWEEN ? and ?)");
	p.setString(1,studentid);
	p.setString(2,startdate);
	p.setString(3,enddate);
	ResultSet result=p.executeQuery();
	ArrayList<String> arr=new ArrayList<String>();
	ArrayList<Integer> totalPeriods=new ArrayList<Integer>();
	while(result.next())
	{
		arr.add(result.getString(1));
	}
	if(arr.size()==0)
	{
		out.println("<body><center><h1>No classes on this date</h1>"
				+"<a href='StudentDashboard.jsp'><b>click here to go back</b></a></center></body>");
	}else{
	for(int i=0;i<arr.size();i++)
	{
		PreparedStatement st3=con.prepareStatement("select count(*) as cnt from attendence where Subject=? and StudentId=? and (Date BETWEEN ? and ?)");
    	st3.setString(1,arr.get(i));
    	st3.setString(2,studentid);
    	st3.setString(3,startdate);
    	st3.setString(4,enddate);
		ResultSet rs=st3.executeQuery();
		rs.next();
		totalPeriods.add(rs.getInt("cnt"));
		st3.close();
	}
		//out.println("<table align='center'>");
		//out.println("<caption><b>VJIT<br><br>Attendance Report<br>"+studentid+"<br>From : "+startdate+"To : "+enddate+"</b></caption>");
		sheet.addMergedRegion(new CellRangeAddress(0,0,0,arr.size()+2));
	HSSFRow rowhead= sheet.createRow((short)row++);
	rowhead.createCell((short) 0).setCellValue("VJIT");
	Cell cell=sheet.getRow(0).getCell(0);
	CellStyle cellstyle=hwb.createCellStyle();
	cellstyle.setAlignment(HorizontalAlignment.CENTER);
	cell.setCellStyle(cellstyle);
	
	 sheet.addMergedRegion(new CellRangeAddress(1,1,0,arr.size()+2));
	HSSFRow rowhead1=   sheet.createRow((short)row++);
	rowhead1.createCell((short) 0).setCellValue("ATTENDANCE REPORT");
	Cell cell1=sheet.getRow(1).getCell(0);
	CellStyle cellstyle1=hwb.createCellStyle();
	cellstyle1.setAlignment(HorizontalAlignment.CENTER);
	cell1.setCellStyle(cellstyle1);
	
	 sheet.addMergedRegion(new CellRangeAddress(2,2,0,arr.size()+2));
	HSSFRow rowhead2=   sheet.createRow((short)row++);
	rowhead2.createCell((short) 0).setCellValue(studentid);
	Cell cell2=sheet.getRow(2).getCell(0);
	CellStyle cellstyle2=hwb.createCellStyle();
	cellstyle2.setAlignment(HorizontalAlignment.CENTER);
	cell2.setCellStyle(cellstyle2);
	
	
	sheet.addMergedRegion(new CellRangeAddress(3,3,0,arr.size()+2));
	HSSFRow rowhead3=   sheet.createRow((short)row++);
	rowhead3.createCell((short) 0).setCellValue("From : "+startdate+" To : "+enddate);
	Cell cell3=sheet.getRow(3).getCell(0);
	CellStyle cellstyle3=hwb.createCellStyle();
	cellstyle3.setAlignment(HorizontalAlignment.CENTER);
	cell3.setCellStyle(cellstyle3);
	
	HSSFRow rowhead4=   sheet.createRow((short)row++);
	int c=0;
	rowhead4.createCell((short) c++).setCellValue("SUBJECTS");
	
        for(int i=0;i<arr.size();i++)
        {
        	//out.println("<td><b>"+arr.get(i)+"</b></td>");
        	rowhead4.createCell((short) c++).setCellValue(arr.get(i));  
        }
        rowhead4.createCell((short) c++).setCellValue("TOTAL"); 
        rowhead4.createCell((short) c++).setCellValue("PERCENTAGE");  
       
        HSSFRow rowhead5=   sheet.createRow((short)row++);
        
       // out.println("<tr><td><b>TOTAL PERIODS</b></td>");
        int summation=0;
        int c1=0;
        rowhead5.createCell((short)c1++).setCellValue("TOTAL CLASSES"); 
        for(int i=0;i<totalPeriods.size();i++)
        {
        	rowhead5.createCell((short)c1++).setCellValue(totalPeriods.get(i));
        	//out.println("<td><b>"+totalPeriods.get(i)+"</b></td>");
        	summation=summation+totalPeriods.get(i);
        }
        rowhead5.createCell((short)c1++).setCellValue(summation);
        rowhead5.createCell((short)c1++).setCellValue("100");
        
        HSSFRow rowhead6=   sheet.createRow((short)row++);
       
        
    	//out.println("<tr>");
        //out.println("<td>");
		//out.println(studentid);
		//out.println("</td>");
		int sum1=0,sum2=0;
		int col=0;
		 rowhead6.createCell((short)col++).setCellValue(studentid);
		for(int i=0;i<arr.size();i++)
		{
			out.println("<td>");
			PreparedStatement stmt=con.prepareStatement("select count(*) as scnt from attendence where (Date BETWEEN ? and ?) and subject=? and StudentId=? and AttendenceStatus=?");
				
				stmt.setString(1,startdate);
				stmt.setString(2,enddate);
				stmt.setString(3,arr.get(i));
				stmt.setString(4,studentid);
				stmt.setString(5,"P");
				ResultSet rst=stmt.executeQuery();
				rst.next();
				int present=rst.getInt("scnt");
				sum1=sum1+present;
				
			 int conducted=totalPeriods.get(i);
			 sum2=sum2+conducted;
				stmt.close();
				 rowhead6.createCell((short)col++).setCellValue(present);
				
		}
		    rowhead6.createCell((short)col++).setCellValue(sum1);
			double avg= ((double)sum1/(double)sum2)*100;
			DecimalFormat decimalformat=new DecimalFormat(".##");
			rowhead6.createCell((short)col++).setCellValue(decimalformat.format(avg));
	   
		}
	FileOutputStream fileOut =  new FileOutputStream(filename);
    hwb.write(fileOut);
    fileOut.close();
    out.println("</table>");
 
   // out.println("<input type='button' name='Generate Excel'>");
    con.close();
    response.sendRedirect("StudentNavbar.jsp");	
}

catch (Exception e) { 
    e.printStackTrace(); 
}

%>
</body>
</html>