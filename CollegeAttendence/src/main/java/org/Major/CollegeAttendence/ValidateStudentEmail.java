package org.Major.CollegeAttendence;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.Major.CollegeAttendence.DatabaseConnection;
/*
 * Note: This file is used for Servlet implementation class Validate Student Email
 * Name: Viraj Panchal
 */

public class ValidateStudentEmail extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException{ 
		PrintWriter out=response.getWriter();
		String emailbyuser=request.getParameter("email");
		HttpSession session=request.getSession();
		String email=(String)session.getAttribute("studentid");
		
		 try {
	            Connection con = DatabaseConnection.initializeDatabase(); 
	            PreparedStatement st = con 
	                   .prepareStatement("select StudentEMail from student where StudentId=?"); 
	            st.setString(1, email); 
	            ResultSet rs=st.executeQuery(); 
	            if(rs.next())
	            {
	            	String emailbyAdmin=rs.getString("StudentEMail");
	            	if(emailbyAdmin.equals(emailbyuser)) {
	            		session.setAttribute("finalemail", emailbyAdmin);
	            	session.removeAttribute("errorMessage");
	            	 response.sendRedirect("EmailProcess.jsp?name=student");}
	            	else
		            {
		            	session.setAttribute("errorMessage","Enter valid Email");
		    			out.println(session.getAttribute("errorMessage"));
		    			response.sendRedirect("ChangePasswordStudent.jsp");
		            }
	            }
	            
	            st.close(); 
	            con.close();   
	        } 
	        catch (Exception e) { 
	            e.printStackTrace(); 
	        }
	}

}
