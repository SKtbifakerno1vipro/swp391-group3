<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="viewmodels.AccountDetail" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="models.Role" %>
<!DOCTYPE html>
<html>
    <head>
        <title>AccountList</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="static/css/styles.css" />
    </head>
    <body>
        <div>
            <jsp:include page="header.jsp" />
            <jsp:include page="topnav.jsp" />
            <h2>Accounts</h2>
            <div><a href="AccountCreate" class="btnCreate">Create New Account</a></div>
            
            <% String searchText = request.getParameter("searchText"); %>
            <% if (searchText == null) searchText = ""; %>
            <% List<Role> roles = (ArrayList<Role>)request.getAttribute("roles"); %>
            <% String rId = request.getParameter("roleId"); %>
            <% int roleId = 0; %>
            <% if (rId != null) roleId = Integer.parseInt(rId); %>
            <div>
                <form action="Accounts" method="POST">
                    AccountId: <input type="text" name="searchText" value="<%= searchText %>">
                     | Role: 
                    <select name="roleId">
                        <% for (Role role : roles) { %>
                            <% if(role.RoleId == roleId) { %>
                                <option value="<%= role.RoleId %>" selected><%= role.RoleName %></option>
                            <% } else { %>
                                <option value="<%= role.RoleId %>"><%= role.RoleName %></option>
                            <% } %>
                        <% } %>
                    </select>
                    <button type="submit">Search</button>
                </form>
            </div>
            
            <div>
                <h4>List of Accounts</h4>
                <table class="data-table">
                    <tr>
                        <th>AccountId</th>
                        <th>Password</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                    <% List<AccountDetail> accounts = (ArrayList<AccountDetail>)request.getAttribute("accounts"); %>
                    <% for (AccountDetail acc : accounts) { %>
                        <tr>
                            <td><%= acc.AccountId %></td>
                            <td><%= acc.Password %></td>
                            <td><%= acc.Role.RoleName %></td>
                            <td>
                                <a href="AccountDetails?id=<%= acc.AccountId %>" class="btnDetails">Details</a> | 
                                <a href="AccountEdit?id=<%= acc.AccountId %>" class="btnEdit">Edit</a> | 
                                <a href="AccountDelete?id=<%= acc.AccountId %>" class="btnDelete">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </table>
            </div>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>