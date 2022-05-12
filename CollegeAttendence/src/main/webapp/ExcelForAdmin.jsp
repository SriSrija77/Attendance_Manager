<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.Date,java.text.SimpleDateFormat,java.io.*,java.text.DecimalFormat,java.util.* "%>
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
	String filename="G:/CollegeAttendence//"+year+"_"+branch+"_"+section+"_Release"+datestring1+".xls" ;
	HSSFWorkbook hwb=new HSSFWorkbook();
	HSSFSheet sheet =  hwb.createSheet("new sheet");
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
		p1.setString(2,year);
		p1.setString(3,section);
		p1.setString(4,startdate);
		p1.setString(5,enddate);
		ResultSet result1=p1.executeQuery();
		while(result1.next()){
			arr1.add(result1.getString(1));	
		}
		
	 sheet.addMergedRegion(new CellRangeAddress(0,0,0,arr.size()+2));
	HSSFRow rowhead= sheet.createRow((short)row++);
	rowhead.createCell((short) 0).setCellValue("VJIT");
	Cell cell=sheet.getRow(0).getCell(0);
	CellStyle cellstyle=hwb.createCellStyle();
	cellstyle.setAlignment(HorizontalAlignment.CENTER);
	cell.setCellStyle(cellstyle);
	
	 sheet.addMergedRegion(new CellRangeAddress(1,1,0,arr.size()+2));
	HSSFRow rowhead1=   sheet.createRow((short)row++);
	rowhead1.createCell((short) 0).setCellValue(branch);
	Cell cell1=sheet.getRow(1).getCell(0);
	CellStyle cellstyle1=hwb.createCellStyle();
	cellstyle1.setAlignment(HorizontalAlignment.CENTER);
	cell1.setCellStyle(cellstyle1);
	
	 sheet.addMergedRegion(new CellRangeAddress(2,2,0,arr.size()+2));
	HSSFRow rowhead2=   sheet.createRow((short)row++);
	rowhead2.createCell((short) 0).setCellValue("ATTENDANCE REPORT");
	Cell cell2=sheet.getRow(2).getCell(0);
	CellStyle cellstyle2=hwb.createCellStyle();
	cellstyle2.setAlignment(HorizontalAlignment.CENTER);
	cell2.setCellStyle(cellstyle2);
	
	
	sheet.addMergedRegion(new CellRangeAddress(3,3,0,arr.size()+2));
	HSSFRow rowhead3=   sheet.createRow((short)row++);
	rowhead3.createCell((short) 0).setCellValue(year+" year "+section+" section");
	Cell cell3=sheet.getRow(3).getCell(0);
	CellStyle cellstyle3=hwb.createCellStyle();
	cellstyle3.setAlignment(HorizontalAlignment.CENTER);
	cell3.setCellStyle(cellstyle3);
	
	sheet.addMergedRegion(new CellRangeAddress(4,4,0,arr.size()+2));
	HSSFRow rowhead31=   sheet.createRow((short)row++);
	rowhead31.createCell((short) 0).setCellValue("From : "+startdate+" to : "+enddate);
	Cell cell31=sheet.getRow(4).getCell(0);
	CellStyle cellstyle31=hwb.createCellStyle();
	cellstyle31.setAlignment(HorizontalAlignment.CENTER);
	cell31.setCellStyle(cellstyle31);
		HSSFRow rowhead4=   sheet.createRow((short)row++);
		int c=0;
	rowhead4.createCell((short) c++).setCellValue("SUBJECTS");
	
        for(int i=0;i<arr.size();i++)
        {
        	rowhead4.createCell((short) c++).setCellValue(arr.get(i));
        }
        rowhead4.createCell((short) c++).setCellValue("TOTAL");
        rowhead4.createCell((short) c++).setCellValue("PERCENTAGE");
       HSSFRow rowhead5=   sheet.createRow((short)row++);
       int c1=0;
	rowhead5.createCell((short) c1++).setCellValue("TOTAL PERIODS");
        int summation=0;
        for(int i=0;i<totalPeriods.size();i++)
        {
        	rowhead5.createCell((short) c1++).setCellValue(totalPeriods.get(i));
        	summation=summation+totalPeriods.get(i);
        }

    	rowhead5.createCell((short) c1++).setCellValue(summation);

    	rowhead5.createCell((short) c1++).setCellValue("100");
        
		for(int i=0;i<arr1.size();i++)
		{
			HSSFRow rowhead6=   sheet.createRow((short)row++);
			int sum1=0,sum2=0;
			int cnt=0;
			rowhead6.createCell((short) cnt++).setCellValue(arr1.get(i));
			for(int j=0;j<arr.size();j++)
			{
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
				rowhead6.createCell((short) cnt++).setCellValue(present);
				
			}
		    rowhead6.createCell((short) cnt++).setCellValue(sum1);
			double avg= ((double)sum1/(double)sum2)*100;
			DecimalFormat decimalformat=new DecimalFormat(".##");
			rowhead6.createCell((short) cnt++).setCellValue(decimalformat.format(avg));
		}
  
    FileOutputStream fileOut =  new FileOutputStream(filename);
    hwb.write(fileOut);
    fileOut.close();
    out.println("</table>");
 
    con.close();
    response.sendRedirect("AdminNavbar.jsp");
    
} 
catch (Exception e) { 
    e.printStackTrace(); 
}


%>
</body>
</html>