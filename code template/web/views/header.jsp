<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Account" %>
<div class="header">
    <table>
        <tr>
            <% Account user = (Account)(session.getAttribute("user")); %>
            <td><b>User: <%= user.AccountId %></b></td>
        </tr>
    </table>
</div>