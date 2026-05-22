<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>House Management</title>
    </head>
    <body>
        <jsp:include page="menu.jsp"/>

        <h2>House Management</h2>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <table class="table table-striped table-hover">

            <thead class="table-dark">

                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Address</th>
                    <th>Rooms</th>
                    <th>Action</th>
                    <th>Rooms</th>
                </tr>

            </thead>

            <tbody>

                <c:forEach var="h" items="${houses}">

                    <tr>

                        <td>${h.houseID}</td>

                        <td>${h.houseName}</td>

                        <td>${h.address}</td>

                        <td>${h.roomNum}</td>

                        <td>

                            <a class="btn btn-danger btn-sm"
                               href="House?action=delete&id=${h.houseID}">
                                Delete
                            </a>

                        </td>

                        <td>

                            <a class="btn btn-primary btn-sm"
                               href="${pageContext.request.contextPath}/Room?houseId=${h.houseID}">
                                Manage Rooms
                            </a>

                        </td>

                    </tr>

                </c:forEach>

            </tbody>

        </table>


        <h4 class="mt-4">Add House</h4>

        <form action="House" method="post" class="row g-3">

            <div class="col-md-3">
                <input class="form-control" name="id" placeholder="House ID" required>
            </div>

            <div class="col-md-3">
                <input class="form-control" name="name" placeholder="House Name" required>
            </div>

            <div class="col-md-4">
                <input class="form-control" name="address" placeholder="Address">
            </div>

            <div class="col-md-2">
                <input class="form-control" type="number" name="roomNum" placeholder="Rooms">
            </div>

            <div class="col-12">
                <button class="btn btn-success">
                    Add House
                </button>
            </div>

        </form>

    </div>


</body>
</html>