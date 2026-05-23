<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Dashboard</title>
    </head>
    <body>
        <jsp:include page="menu.jsp"/>

        <h2>Admin Dashboard</h2>

        <div>

            <div>
                <div>
                    <div>
                        <h5>Total Houses</h5>
                        <h3>${totalHouses}</h3>
                    </div>
                </div>
            </div>

            <div>
                <div>
                    <div>
                        <h5>Total Rooms</h5>
                        <h3>${totalRooms}</h3>
                    </div>
                </div>
            </div>

            <div>
                <div>
                    <div>
                        <h5>Occupied Rate</h5>
                        <h3>${occupiedRate}%</h3>
                    </div>
                </div>
            </div>

            <div>
                <div>
                    <div>
                        <h5>Revenue</h5>
                        <h3>${revenue}</h3>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>

