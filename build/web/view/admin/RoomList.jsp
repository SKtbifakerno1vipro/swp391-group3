<%-- 
    Document   : RoomList
    Created on : Mar 4, 2026, 12:01:58 AM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Room List</title>
    </head>
    <body>
        <jsp:include page="menu.jsp"/>

        <h2>Room List</h2>

        <table class="table table-striped">

            <thead class="table-dark">

                <tr>
                    <th>ID</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>

            </thead>

            <tbody>

                <c:forEach var="r" items="${rooms}">

                    <tr>

                        <td>${r.roomID}</td>

                        <td>

                            <c:choose>

                                <c:when test="${r.status == 'A'}">

                                    <span class="badge bg-success">Available</span>

                                </c:when>

                                <c:otherwise>

                                    <span class="badge bg-danger">Occupied</span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <a class="btn btn-warning btn-sm"
                               href="${pageContext.request.contextPath}/Room?action=toggle&id=${r.roomID}&status=${r.status}&houseId=${houseId}">
                                Toggle
                            </a>

                            <a class="btn btn-danger btn-sm"
                               href="${pageContext.request.contextPath}/Room?action=delete&id=${r.roomID}&houseId=${houseId}">
                                Delete
                            </a>

                        </td>

                    </tr>

                </c:forEach>

            </tbody>

        </table>


        <h4>Add Room</h4>

        <form action="Room" method="post" class="row g-3">

            <input type="hidden" name="houseId" value="${houseId}"/>

            <div class="col-md-3">

                <input class="form-control"
                       name="id"
                       placeholder="Room ID">

            </div>

            <div class="col-md-2">

                <button class="btn btn-success">
                    Add Room
                </button>

            </div>

        </form>



    </body>
</html>
