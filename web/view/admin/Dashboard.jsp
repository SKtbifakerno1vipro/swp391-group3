<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard</title>
    </head>
    <body>
        <jsp:include page="menu.jsp"/>

        <h2 class="mb-4">Admin Dashboard</h2>

        <div class="row">

            <div class="col-md-3">
                <div class="card text-bg-primary">
                    <div class="card-body">
                        <h5>Total Houses</h5>
                        <h3>${totalHouses}</h3>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card text-bg-success">
                    <div class="card-body">
                        <h5>Total Rooms</h5>
                        <h3>${totalRooms}</h3>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card text-bg-warning">
                    <div class="card-body">
                        <h5>Occupied Rate</h5>
                        <h3>${occupiedRate}%</h3>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card text-bg-dark">
                    <div class="card-body">
                        <h5>Revenue</h5>
                        <h3>${revenue}</h3>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>