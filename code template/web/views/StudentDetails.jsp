<%-- 
    Document   : StudentDetails
    Created on : Jan 30, 2026, 2:52:19 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Student" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AccountDetails</title>
    </head>
    <body>
        <div>
            <h2>Student Details</h2>
            <% Student std = (Student)request.getAttribute("student"); %>
            <% if (std != null) { %>
            <div>
                <table>
                    <tr>
                        <td>Roll Number: </td>
                        <td><%= std.rollNumber %></td>
                    </tr>
                    <tr>
                        <td>LastName: </td>
                        <td><%= std.lastName %></td>
                    </tr>
                    <tr>
                        <td>FirstName: </td>
                        <td><%= std.firstName %></td>
                    </tr>
                    <tr>
                        <td>Birthday: </td>
                        <td><%= std.birthday %></td>
                    </tr>
                    <tr>
                        <td>Gender: </td>
                        <%
                    if("M".equals(std.gender)){
                %>
                <td>Male</td>
                <%
                    } else {

                   %>
                <td>Female</td>
                <% }
                %>
                    </tr>
                    <tr>
                        <td>English1: </td>
                        <td><%= std.english1 %></td>
                    </tr>
                    <tr>
                        <td>English2: </td>
                        <td><%= std.english2 %></td>
                    </tr>
                    <tr>
                        <td>English3: </td>
                        <td><%= std.english3 %></td>
                    </tr>
                    <tr>
                        <td>English3: </td>
                        <td><%= std.english3 %></td>
                    </tr>
                    <tr>
                        <td>Specialization: </td>
                        <td><%= std.specId %></td>
                    </tr>
                </table>
            </div>
            <% } %>
            <div>
                <a href="Students">Back to List</a> | <a href="#">Edit</a>
            </div>
        </div>
    </body>
</html>