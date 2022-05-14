<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.Date,java.text.SimpleDateFormat,java.io.*,java.text.DecimalFormat,java.util.ArrayList "%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="style.css">
<title>Attendance Manager</title>

<style>
th,td,b{
text-align:center;
color:#000066;
padding:5px;
}
</style>
</head>
<body>
<div style="opacity:0.8;border:0px solid black;background-color:#ccccff;margin:60px 200px;padding:0px;">

<%
session.setAttribute("branch",request.getParameter("branch"));
session.setAttribute("year",request.getParameter("year"));
session.setAttribute("section",request.getParameter("section"));
session.setAttribute("startdate",request.getParameter("startdate"));
session.setAttribute("enddate",request.getParameter("enddate"));
out.println("<h3 align='center'><a href='AdminNavbar.jsp'><b>Back</b></a></h3>");
String branch=(String)session.getAttribute("branch");
String year=(String)session.getAttribute("year");
String section=(String)session.getAttribute("section");
String startdate=(String)session.getAttribute("startdate");
String enddate=(String)session.getAttribute("enddate");
String dbDriver = "com.mysql.cj.jdbc.Driver"; 
String dbURL = "jdbc:mysql://localhost:3306/"; 
String dbName = "attendancereport"; 
String dbUsername = "root"; 
String dbPassword = ""; 
Class.forName(dbDriver); 
double total=0;
double temp=0;
DecimalFormat df=new DecimalFormat(".##");
try {
	
	Connection con = DriverManager.getConnection(dbURL + dbName, 
            dbUsername,  
            dbPassword);
	PreparedStatement p=con.prepareStatement("select distinct Subject from attendence where Branch=? and Year=? and Section=? and (Date BETWEEN ? and ?)");
	p.setString(1,branch);
	p.setString(2,year);
	p.setString(3,section);
	p.setString(4,startdate);
	p.setString(5,enddate);
	ResultSet result=p.executeQuery();
	ArrayList<String> arr=new ArrayList<String>();
	ArrayList<String> arr1=new ArrayList<String>();
	ArrayList<Integer> totalPeriods=new ArrayList<Integer>();
	while(result.next())
	{
		arr.add(result.getString(1));
	}
	if(arr.size()==0)
	{
		out.println("<body><center><h1>No classes on this date</h1>"
				+"<a href='AdminDashboard.jsp'><b>click here to go back</b></a></center></body>");
	}else{
	for(int i=0;i<arr.size();i++)
	{
		
		PreparedStatement stmttotal=con.prepareStatement("select count(*) as cnt from facultydailyactivity where Branch=?  and Year=? and Section=? and (Date BETWEEN ? and ?) and subject=?");
		stmttotal.setString(1,branch);
		stmttotal.setString(2,year);
		stmttotal.setString(3,section);
		stmttotal.setString(4,startdate);
		stmttotal.setString(5,enddate);
		stmttotal.setString(6,arr.get(i));
		ResultSet rs=stmttotal.executeQuery();
		rs.next();
		totalPeriods.add(rs.getInt("cnt"));
		stmttotal.close();
	}

		PreparedStatement p1=con.prepareStatement("select distinct StudentId from attendence where Branch=?  and Year=? and Section=? and (Date BETWEEN ? and ?)");
		p1.setString(1,branch);
		//p1.setString(2,s);
		p1.setString(2,year);
		p1.setString(3,section);
		p1.setString(4,startdate);
		p1.setString(5,enddate);
		ResultSet result1=p1.executeQuery();
		while(result1.next()){
			arr1.add(result1.getString(1));	
		}
		out.println("<table align='center'>");
		out.println("<caption><b>VJIT<br>"+branch+"<br>Attendance Report<br>Year:"+year+"<br>Section : "+section+"<br>From : "+startdate+" to : "+enddate+"</b></caption>");
		out.println("<tr>");
		out.println("<td><b>SUBJECTS</b></td>");
        for(int i=0;i<arr.size();i++)
        {
        	out.println("<td><b>"+arr.get(i)+"</b></td>");
        }
        out.println("<td><b>TOTAL</b></td><td><b>PERCENTAGE</b></td>");
        out.println("</tr>");
        out.println("<td><b>TOTAL PERIODS</b></td>");
        int summation=0;
        for(int i=0;i<totalPeriods.size();i++)
        {
        	out.println("<td><b>"+totalPeriods.get(i)+"</b></td>");
        	summation=summation+totalPeriods.get(i);
        }
        out.println("<td><b>"+summation+"</b></td><td><b>100</b></td>");
        out.println("</tr>");
        
		for(int i=0;i<arr1.size();i++)
		{
			out.println("<tr>");
			int sum1=0,sum2=0;
			out.println("<td>");
			out.println(arr1.get(i));
			out.println("</td>");
			for(int j=0;j<arr.size();j++)
			{
				out.println("<td>");
				PreparedStatement stmt=con.prepareStatement("select count(*) as scnt from attendence where Branch=?  and Year=? and Section=? and (Date BETWEEN ? and ?) and subject=? and StudentId=? and AttendenceStatus=?");
				stmt.setString(1,branch);
				stmt.setString(2,year);
				stmt.setString(3,section);
				stmt.setString(4,startdate);
				stmt.setString(5,enddate);
				stmt.setString(6,arr.get(j));
				stmt.setString(7,arr1.get(i));
				stmt.setString(8,"P");
				ResultSet rst=stmt.executeQuery();
				rst.next();
				int present=rst.getInt("scnt");
				sum1=sum1+present;
				
			 int conducted=totalPeriods.get(j);
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
		}
		 out.println("<tr><td colspan='4'><form method='post' action='ExcelForAdmin.jsp'>");
		    out.println("<input type='submit' value='GenerateExcel' style='background-color:#0000CC;color:white;margin: 8px 140px;padding:10px 20px;'></form></td></tr>");
		    out.println("</table></center></body>");
	   
		}}

catch (Exception e) { 
    e.printStackTrace(); 
}
%>
</div>
</body>
</html>