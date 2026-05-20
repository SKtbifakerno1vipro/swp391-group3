<%-- 
    Document   : AccountList
    Created on : Jan 30, 2026, 1:06:59 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Student" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
    <head>
        <title>AccountList</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <div>
            <h2>Students</h2>
            <div><a href="StudentCreate">Create New Studnet</a></div>
            <div>
                <h4>List of Students</h4>
                <table>
                    <tr>
                        <th>RollNumber</th>
                        <th>LastName</th>
                        <th>FirstName</th>
                        <th>Actions</th>
                    </tr>
                    <% List<Student> students = (ArrayList<Student>)request.getAttribute("students"); %>
                    <% for (Student std : students) { %>
                        <tr>
                            <td><%= std.rollNumber %></td>
                            <td><%= std.lastName %></td>
                            <td><%= std.firstName %></td>
                            <td>
                                <a href="StudentDetails?rollNumber=<%=std.rollNumber%>">Details</a> | 
                                <a href="#">Edit</a> | 
                                <a href="#">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </table>
            </div>
        </div>
    </body>
</html>
