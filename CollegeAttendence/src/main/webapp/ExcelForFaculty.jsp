<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.Date,java.text.SimpleDateFormat,java.text.DecimalFormat,java.io.*,java.util.* "%>
    <%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page import="org.apache.poi.ss.usermodel.*" %>
<%@ page import="org.apache.poi.common.usermodel.HyperlinkType" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<style>
td{
text-align:center;
}
</style>
</head>
<body>
<%
Date date=new Date();
String datestring=date.toString().replace(" ","");
String datestring1=datestring.replace(":","-");
String branch=(String)session.getAttribute("branch");
String year=(String)session.getAttribute("year");
String section=(String)session.getAttribute("section");
String startdate=(String)session.getAttribute("startdate");
String enddate=(String)session.getAttribute("enddate");
String subject=(String)session.getAttribute("subject");
String facultyid=(String)session.getAttribute("facultyid");
String dbDriver = "com.mysql.jdbc.Driver"; 
String dbURL = "jdbc:mysql://localhost:3306/"; 
String dbName = "attendancereport"; 
String dbUsername = "root"; 
String dbPassword = ""; 
Class.forName(dbDriver); 
double total=0;
double temp=0;

try {
	int row=0;
	String namefile=branch+"-"+facultyid+"-"+branch+"-"+year+"-"+section+"-"+datestring1;
	String filename="G:/CollegeAttendence//"+namefile+".xls" ;
	HSSFWorkbook hwb=new HSSFWorkbook();
	HSSFSheet sheet =  hwb.createSheet("new sheet");
	//HSSFRow rowhead=   sheet.createRow((short)0);
// 	rowhead.createCell((short) 0).setCellValue("SNo");
// 	rowhead.createCell((short) 1).setCellValue("StudentId");
// 	rowhead.createCell((short) 2).setCellValue("Subject");
// 	rowhead.createCell((short) 3).setCellValue("Classes Attended");
// 	rowhead.createCell((short) 4).setCellValue("Classes Taken");
// 	rowhead.createCell((short) 5).setCellValue("Attendance Percentage");
	Connection con = DriverManager.getConnection(dbURL + dbName, 
            dbUsername,  
            dbPassword);
	ArrayList<String> arr=new ArrayList<String>();
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
	
	//out.println("<caption><b>VJIT<b><br><b>ATTENDANCE REPORT</b><br>"+branch+"<br>"+year+"<br>"+section+"<br>"+subject+"<br>"+"From : "+startdate+" to : "+enddate+"</caption>");
	sheet.addMergedRegion(new CellRangeAddress(0,0,0,2));
	HSSFRow rowhead= sheet.createRow((short)row++);
	rowhead.createCell((short) 0).setCellValue("VJIT");
	Cell cell=sheet.getRow(0).getCell(0);
	CellStyle cellstyle=hwb.createCellStyle();
	cellstyle.setAlignment(HorizontalAlignment.CENTER);
	cell.setCellStyle(cellstyle);
	
	 sheet.addMergedRegion(new CellRangeAddress(1,1,0,2));
	HSSFRow rowhead1=   sheet.createRow((short)row++);
	rowhead1.createCell((short) 0).setCellValue(branch);
	Cell cell1=sheet.getRow(1).getCell(0);
	CellStyle cellstyle1=hwb.createCellStyle();
	cellstyle1.setAlignment(HorizontalAlignment.CENTER);
	cell1.setCellStyle(cellstyle1);
	
	 sheet.addMergedRegion(new CellRangeAddress(2,2,0,2));
	HSSFRow rowhead2=   sheet.createRow((short)row++);
	rowhead2.createCell((short) 0).setCellValue("ATTENDANCE REPORT FOR "+subject);
	Cell cell2=sheet.getRow(2).getCell(0);
	CellStyle cellstyle2=hwb.createCellStyle();
	cellstyle2.setAlignment(HorizontalAlignment.CENTER);
	cell2.setCellStyle(cellstyle2);
	
	
	sheet.addMergedRegion(new CellRangeAddress(3,3,0,2));
	HSSFRow rowhead3=   sheet.createRow((short)row++);
	rowhead3.createCell((short) 0).setCellValue(year+" year "+section+" section");
	Cell cell3=sheet.getRow(3).getCell(0);
	CellStyle cellstyle3=hwb.createCellStyle();
	cellstyle3.setAlignment(HorizontalAlignment.CENTER);
	cell3.setCellStyle(cellstyle3);
	
	sheet.addMergedRegion(new CellRangeAddress(4,4,0,2));
	HSSFRow rowhead31=   sheet.createRow((short)row++);
	rowhead31.createCell((short) 0).setCellValue("From : "+startdate+" To : "+enddate);
	Cell cell31=sheet.getRow(4).getCell(0);
	CellStyle cellstyle31=hwb.createCellStyle();
	cellstyle31.setAlignment(HorizontalAlignment.CENTER);
	cell31.setCellStyle(cellstyle31);
		HSSFRow rowhead4=   sheet.createRow((short)row++);
	
	int sum1=0;
	//out.println("<tr><td><b>SUBJECT<b></td><td><b>"+subject+"</b></td><td><b>AVERAGE</b></td></tr>");
	//out.println("<tr><td><b>Classes Conducted<b></td><td>"+noOfPeriods+"</td><td><b>100</b></td></tr>");
	HSSFRow rowhead5=   sheet.createRow((short)row++);
	rowhead5.createCell((short) 0).setCellValue("SUBJECTS");
	rowhead5.createCell((short) 1).setCellValue(subject);
	rowhead5.createCell((short) 2).setCellValue("AVERAGE");
	
	HSSFRow rowhead6=   sheet.createRow((short)row++);
	rowhead6.createCell((short) 0).setCellValue("CLASSES CONDUCTED");
	rowhead6.createCell((short) 1).setCellValue(noOfPeriods);
	rowhead6.createCell((short) 2).setCellValue("100");
	
	int c=0;
	for(int j=0;j<arr.size();j++)
	{
		c=0;
		HSSFRow rowhead7=   sheet.createRow((short)row++);
		rowhead7.createCell((short)c++).setCellValue(arr.get(j));
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
		//out.println("<td>");
		rowhead7.createCell((short)c++).setCellValue(present);
		//out.println(present);
		//out.println("</td>");
		double avg= ((double)present/(double)noOfPeriods)*(100.0);
		DecimalFormat decimalformat=new DecimalFormat(".##");
		//out.println("<td>"+decimalformat.format(avg)+"</td>");
		//out.println("</tr>");
		rowhead7.createCell((short)c++).setCellValue(decimalformat.format(avg));
	}
    }
	 FileOutputStream fileOut =  new FileOutputStream(filename);
	    hwb.write(fileOut);
	    fileOut.close();

	   // out.println("<input type='button' name='Generate Excel'>");
	    con.close();
	    response.sendRedirect("FacultyNavbar.jsp");
} 
catch (Exception e) { 
    e.printStackTrace(); 
}
%>
</body>
</html>