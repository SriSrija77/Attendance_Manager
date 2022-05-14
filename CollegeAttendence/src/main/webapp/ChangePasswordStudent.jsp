<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="style.css">
<!-- Title Added: Viraj -->
<title>Attendance Manager</title>
</head>
<body>
<div style="opacity:0.9;border:0px solid black;background-color:#ccccff;margin:60px 200px;padding:0px;">
<center>
<form action="./ValidateStudentEmail" method="post" style="font-weight:bold;margin:30px 20px 30px 20px">
<table align="center">

<span><a href="StudentNavbar.jsp" style="padding:0px 0px 0px 10px;float:right;"><strong>&times;</strong></a></span>
<%
if(session.getAttribute("errorMessage")!=null)
out.println("<h1>"+session.getAttribute("errorMessage")+"</h1>");
session.removeAttribute("errorMessage");
%>
<caption><h3>Enter Email</h3></caption>
<tr>
  <div class="container">
   <td>
   <input type="text" placeholder="Email" name="email" required>
   </td>
   </tr>
    <tr><td><button type="submit"><strong>Submit</strong></button></td></tr>
  </div>
  </table>
</form>
</center>
</div>
</body>
</html>