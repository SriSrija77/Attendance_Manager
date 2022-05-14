<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.Date"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="style.css">
<!-- Title Added: Viraj -->
<title>Attendance Manager</title>
</head>
<body>
<%
int otp= (Integer) session.getAttribute("otp");
String otpvalue=request.getParameter("otp");
int enterOtp=Integer.parseInt(otpvalue);
Date enddate=new Date();
Date start=(Date)session.getAttribute("startdate");

long diff= enddate.getTime()-start.getTime();
if((diff/1000)<60){
if(otp==enterOtp)
{       session.removeAttribute("errorMessage");
	    out.println("<div style='opacity:0.9;border:0px solid black;background-color:#ccccff;margin:60px 200px;padding:0px;'>"+
		"<center><h2>Change Password</h2><form action='./FacultyPasswordUpdate' method='post' style='font-weight:bold;margin:30px 20px 30px 20px'><table><span><a href='otp.jsp' style='padding:0px 0px 0px 10px;float:right;'><strong>&times;</strong></a></span><tr><td><input type='text' name='facultyId' value='"+session.getAttribute("facultyid")+"' readonly></td></tr>"+
	    "<tr><td><input type='password' name='pwd' placeholder='Enter new Password'></td></tr>"+      
		    "<tr><td><button type='submit' class='btn btn-primary btn-block'>Submit</button></td></tr></table></form></center></div>");
}
else
{
	session.setAttribute("errorMessage","Incorrect OTP");
	response.sendRedirect("otp.jsp");
}}
else{
	session.setAttribute("errorMessage","Session Expired");
	response.sendRedirect("changePassword.jsp");
}
%>
</body>
</html>
