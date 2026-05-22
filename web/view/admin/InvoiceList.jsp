<%-- 
    Document   : InvoiceList
    Created on : Mar 4, 2026, 1:04:06 AM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:include page="menu.jsp"/>

        <h2>Invoice List</h2>

        <table class="table table-striped">

            <thead class="table-dark">

                <tr>

                    <th>ID</th>
                    <th>Contract</th>
                    <th>Electric</th>
                    <th>Water</th>
                    <th>Room</th>
                    <th>Other</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Action</th>

                </tr>

            </thead>

            <tbody>

                <c:forEach var="i" items="${invoices}">

                    <tr>

                        <td>${i.invoiceID}</td>

                        <td>${i.contractID}</td>

                        <td>${i.electric}</td>

                        <td>${i.water}</td>

                        <td>${i.roomPrice}</td>

                        <td>${i.other}</td>

                        <td>${i.total}</td>

                        <td>

                            <c:choose>

                                <c:when test="${i.status=='P'}">

                                    <span class="badge bg-success">Paid</span>

                                </c:when>

                                <c:otherwise>

                                    <span class="badge bg-warning">Unpaid</span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <c:if test="${i.status=='U'}">

                                <a class="btn btn-primary btn-sm"
                                   href="${pageContext.request.contextPath}/Invoice?action=pay&id=${i.invoiceID}">
                                    Mark Paid
                                </a>

                            </c:if>

                        </td>

                    </tr>

                </c:forEach>

            </tbody>

        </table>


    </body>
</html>
