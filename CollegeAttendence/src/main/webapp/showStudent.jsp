<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.Date,java.text.SimpleDateFormat,java.text.DecimalFormat,java.io.*,java.util.ArrayList "%>
    <%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Attendance Manager</title>
<link rel="stylesheet" href="style.css">
<style>
h1,th,td{
text-align:center;
color:#000066;
padding:5px;
}
</style>
</style>
</head>
<body>

<h1 align="center"><a href="StudentNavbar.jsp">Back</a></h1>
<div style="opacity:0.8;border:0px solid black;background-color:#ccccff;margin:60px 200px;padding:0px;">

<%
String startdate=request.getParameter("startdate");
String enddate=request.getParameter("enddate");
String studentid=(String)session.getAttribute("studentid"); 
session.setAttribute("startdate",startdate);
session.setAttribute("enddate",enddate);
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
ArrayList<String> subjects=new ArrayList<String>();
try {
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
		out.println("<table align='center'>");
		out.println("<caption><b>VJIT<br><br>Attendance Report<br>"+studentid+"<br>From : "+startdate+"To : "+enddate+"</b></caption>");
		out.println("<tr>");
		out.println("<td><b>SUBJECTS</b></td>");
        for(int i=0;i<arr.size();i++)
        {
        	out.println("<td><b>"+arr.get(i)+"</b></td>");
        }
        out.println("<td><b>TOTAL</b></td><td><b>PERCENTAGE</b></td>");
        out.println("</tr>");
        out.println("<tr><td><b>TOTAL PERIODS</b></td>");
        int summation=0;
        for(int i=0;i<totalPeriods.size();i++)
        {
        	out.println("<td><b>"+totalPeriods.get(i)+"</b></td>");
        	summation=summation+totalPeriods.get(i);
        }
        out.println("<td><b>"+summation+"</b></td><td><b>100</b></td>");
        out.println("</tr>");
    	out.println("<tr>");
        out.println("<td>");
		out.println(studentid);
		out.println("</td>");
		int sum1=0,sum2=0;
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
				out.println(present);
				out.println("</td>");
		}
		    out.println("<td>"+sum1+"</td>");
			double avg= ((double)sum1/(double)sum2)*100;
			DecimalFormat decimalformat=new DecimalFormat(".##");
			out.println("<td>"+decimalformat.format(avg)+"</td>");
			out.println("</tr>");
		
		 out.println("<tr><td colspan='4'><form method='post' action='ExcelGenerateForAll.jsp'>");
		    out.println("<input type='submit' value='GenerateExcel' style='background-color:#0000CC;color:white;margin: 8px 140px;padding:10px 20px;'></form></td></tr>");
		    out.println("</table></center></body>");
	   
		}}

catch (Exception e) { 
    e.printStackTrace(); 
}

%>
</body>
</html>