<%-- 
    Document   : menu
    Created on : Mar 4, 2026, 1:12:27 AM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container-fluid">

                <a class="navbar-brand" href="${pageContext.request.contextPath}/Dashboard">
                    Rental Admin
                </a>

                <button class="navbar-toggler" type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#navbarNav">

                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">

                    <ul class="navbar-nav ms-auto">

                        <li class="nav-item">
                            <a class="nav-link"
                               href="${pageContext.request.contextPath}/Dashboard">
                                Dashboard
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link"
                               href="${pageContext.request.contextPath}/House">
                                Houses
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link"
                               href="${pageContext.request.contextPath}/Contract">
                                Contracts
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link"
                               href="${pageContext.request.contextPath}/Invoice">
                                Invoices
                            </a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link text-danger"
                               href="${pageContext.request.contextPath}/Logout">
                                Logout
                            </a>
                        </li>

                    </ul>

                </div>

            </div>
        </nav>

        <div class="container mt-4"></div>
    </body>
</html>
