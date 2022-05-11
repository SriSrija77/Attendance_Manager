package org.Major.CollegeAttendence;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/*
 * Note: This file is used for Servlet implementation class StudentPasswordUpdate
 * Name: Viraj Panchal
 */

public class StudentPasswordUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out=response.getWriter();
		String sid=request.getParameter("studentId");
		String pwd=request.getParameter("pwd");
		try
		{
			 Connection con = DatabaseConnection.initializeDatabase(); 
	            PreparedStatement st = con 
	                   .prepareStatement("update student set StudentPassword=? where StudentId=?"); 
	            st.setString(1, pwd);
	            st.setString(2, sid); 
	            int u=st.executeUpdate();
	            if(u>0)
	            {
	            	response.sendRedirect("Login.jsp");
	            }
	            else
	            {
	            	response.sendRedirect("ChangePasswordStudent.jsp");
	            }
		}
		catch(Exception e)
		{
			System.out.print("StudentPassword Update Error"+e);
			e.printStackTrace();
		}
	}

}
