<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.Date,java.text.SimpleDateFormat,java.io.*,java.text.DecimalFormat,java.util.*"%>
    <%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="style.css">
<title>Attendance Manager</title>
<style>
h1,th,td{
text-align:center;
color:#000066;
padding:5px;
}
</style>
</head>
<body>
<h1 align="center"><a href="FacultyDashboard.jsp">Back</a></h1>
<%
String section=(String)session.getAttribute("section");
String branch=(String)session.getAttribute("branch");
String year=(String)session.getAttribute("year");

String startdate=request.getParameter("startdate");
session.setAttribute("startdate",startdate);
String enddate=request.getParameter("enddate");
session.setAttribute("enddate",enddate);
String subject=request.getParameter("subjects");
session.setAttribute("subject",subject);
String facultyid=(String)session.getAttribute("facultyid");
String dbDriver = "com.mysql.cj.jdbc.Driver"; 
String dbURL = "jdbc:mysql://localhost:3306/"; 
String dbName = "attendancereport"; 
String dbUsername = "root"; 
String dbPassword = ""; 
Class.forName(dbDriver); 
double total=0;
double temp=0;
ArrayList<String> arr=new ArrayList<String>();
try {
	
	Connection con = DriverManager.getConnection(dbURL + dbName, 
            dbUsername,  
            dbPassword);
	PreparedStatement st=con.prepareStatement("select count(*) as cnt from facultydailyactivity where Branch=? and year=? and section=? and (Date BETWEEN ? and ?) and subject=? and FacultyId=?");
	st.setString(1,branch);
	st.setString(2,year);
	st.setString(3,section);
	st.setString(4,startdate);
	st.setString(5,enddate);
	st.setString(6,subject);
	st.setString(7,facultyid);
	ResultSet rs=st.executeQuery();
	if(rs.next()){
	int noOfPeriods=rs.getInt("cnt");
	PreparedStatement ps=con.prepareStatement("select distinct StudentId from attendence where Branch=? and Year=? and Section=? and (Date BETWEEN ? and ?)");
	ps.setString(1,branch);
	ps.setString(2,year);
	ps.setString(3,section);
	ps.setString(4,startdate);
	ps.setString(5,enddate);
	ResultSet r=ps.executeQuery();
	while(r.next()){
		arr.add(r.getString(1));
	}
	if(arr.size()==0)
	{
			out.println("<body><center><h1>No classes on this date</h1>"
					+"<a href='FacultyDashboard.jsp'><b>click here to go back</b></a></center></body>");
		
	}
	else{
	out.println("<body><center>"+
			"<div style='opacity:0.8;border:0px solid black;background-color:#ccccff;margin:60px 200px;padding:20px;'>"+
			"<table border='1'>");
	
	out.println("<caption><b>VJIT<b><br><b>ATTENDANCE REPORT</b><br>"+branch+"<br>"+year+"<br>"+section+"<br>"+subject+"<br>"+"From : "+startdate+" to : "+enddate+"</caption>");
	int sum1=0;
	out.println("<tr><td><b>SUBJECT<b></td><td><b>"+subject+"</b></td><td><b>AVERAGE</b></td></tr>");
	out.println("<tr><td><b>Classes Conducted<b></td><td>"+noOfPeriods+"</td><td><b>100</b></td></tr>");
	for(int j=0;j<arr.size();j++)
	{
		out.println("<tr>");
		out.println("<td>"+arr.get(j)+"</td>");
		PreparedStatement stmt=con.prepareStatement("select count(*) as scnt from attendence where Branch=?  and Year=? and Section=? and (Date BETWEEN ? and ?) and subject=? and StudentId=? and AttendenceStatus=? and FacultyId=?");
		stmt.setString(1,branch);
		stmt.setString(2,year);
		stmt.setString(3,section);
		stmt.setString(4,startdate);
		stmt.setString(5,enddate);
		stmt.setString(6,subject);
		stmt.setString(7,arr.get(j));
		stmt.setString(8,"P");
		stmt.setString(9,facultyid);
		ResultSet rst=stmt.executeQuery();
		rst.next();
		int present=rst.getInt("scnt");
		stmt.close();
		out.println("<td>");
		out.println(present);
		out.println("</td>");
		double avg= ((double)present/(double)noOfPeriods)*(100.0);
		DecimalFormat decimalformat=new DecimalFormat(".##");
		out.println("<td>"+decimalformat.format(avg)+"</td>");
		out.println("</tr>");
	}
    
    out.println("<tr><td colspan='3'><form method='post' action='ExcelForFaculty.jsp'>");
    out.println("<input type='submit' value='GenerateExcel' style='background-color:#0000CC;color:white;margin: 8px 140px;padding:10px 20px;'></form></td></tr>");
    out.println("</table></center></body>");
	}}
	
	}
catch (Exception e) { 
    e.printStackTrace(); 
}
%>
</body>
</html>