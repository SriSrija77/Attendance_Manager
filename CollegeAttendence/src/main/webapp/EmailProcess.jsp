<%@page import="java.util.Random"%>
<%@page import="java.io.BufferedReader"%>
<%@page import ="java.io.IOException" %>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import=" java.net.URLEncoder"%>
<%@page import="java.util.*"%>   
<%@page  import="javax.mail.*"%>
<%@page  import="javax.mail.internet.*"%> 
<%@page import="javax.activation.*" %>  
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%

String name=request.getParameter("name");
String emailto=(String)session.getAttribute("finalemail");
final String user="akankshabhaiyya0508@gmail.com";//change accordingly  
final String password="Akankshagmail@123";//change accordingly  
Properties properties = System.getProperties();  
properties.setProperty("mail.smtp.host", "smtp.gmail.com");  
properties.put("mail.smtp.auth", "true"); 
properties.put("mail.smtp.port", "587");
properties.put("mail.smtp.starttls.enable", "true");

Random rand = new Random();
int otp = rand.nextInt(900000) + 100000;
session.setAttribute("otp",otp);

Session session1 = Session.getDefaultInstance(properties,  
 new javax.mail.Authenticator() {  
 protected PasswordAuthentication getPasswordAuthentication() {  
 return new PasswordAuthentication(user,password);  
 }  
});  
   
//2) compose message     
try{  
  MimeMessage message = new MimeMessage(session1);  
  message.setFrom(new InternetAddress(user));  
  message.addRecipient(Message.RecipientType.TO,new InternetAddress(emailto));  
  message.setSubject("Attendence Manager");  
    
  //3) create MimeBodyPart object and set your message text     
  BodyPart messageBodyPart1 = new MimeBodyPart();  
  messageBodyPart1.setText("OTP : "+ otp);  
    
  //4) create new MimeBodyPart object and set DataHandler object to this object      
 
   
   
  //5) create Multipart object and add MimeBodyPart objects to this object      
   Multipart multipart = new MimeMultipart();  
  multipart.addBodyPart(messageBodyPart1); 

  //6) set the multiplart object to the message object  
  message.setContent(multipart );  
   
  //7) send message  
  Transport.send(message);

  if(name.equals("faculty"))
    response.sendRedirect("otp.jsp");
  else if(name.equals("student"))
	  response.sendRedirect("StudentOtp.jsp");
 
 }catch (MessagingException ex) {ex.printStackTrace();}  


%>
</body>
</html>
