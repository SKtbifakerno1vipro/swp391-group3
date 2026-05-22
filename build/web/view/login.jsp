<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>

        <title>Admin Login</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>

    <body class="bg-light">

        <div class="container">

            <div class="row justify-content-center mt-5">

                <div class="col-md-4">

                    <div class="card shadow">

                        <div class="card-body">

                            <h4 class="text-center mb-4">Admin Login</h4>

                            <form method="post" action="Login">

                                <div class="mb-3">
                                    <input type="text"
                                           name="username"
                                           class="form-control"
                                           placeholder="Username"
                                           required>
                                </div>

                                <div class="mb-3">
                                    <input type="password"
                                           name="password"
                                           class="form-control"
                                           placeholder="Password"
                                           required>
                                </div>

                                <button class="btn btn-primary w-100">
                                    Login
                                </button>

                            </form>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger mt-3">
                                    ${error}
                                </div>
                            </c:if>

                        </div>
                    </div>

                </div>
            </div>

        </div>

    </body>
</html>