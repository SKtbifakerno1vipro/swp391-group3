<%-- 
    Document   : AccountCreate
    Created on : Feb 3, 2026, 5:11:43 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AccountCreate</title>
    </head>
    <body>
        <div>
            <h2>Create New Account</h2>
            <form action="AccountCreate" method="POST">
                <table>
                    <tr>
                        <td>AccountId:</td>
                        <td><input type="text" name="accountId"/></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="password" name="password"/></td>
                    </tr>
                    <tr>
                        <td>Role:</td>
                        <td>
                            <select name="roleId">
                                <option value="1">Admin</option>
                                <option value="2">Student</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><button type="submit">Create</button></td>
                    </tr>
                </table>
            </form>
            <a href="Accounts">Back to List</a>
        </div>
    </body>
</html>
