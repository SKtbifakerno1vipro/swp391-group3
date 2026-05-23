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

        

        <nav>
            <div>

                <a href="${pageContext.request.contextPath}/Dashboard">
                    Rental Admin
                </a>

                <button type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#navbarNav">

                    <span></span>
                </button>

                <div id="navbarNav">

                    <ul>

                        <li>
                            <a
                               href="${pageContext.request.contextPath}/Dashboard">
                                Dashboard
                            </a>
                        </li>

                        <li>
                            <a
                               href="${pageContext.request.contextPath}/House">
                                Houses
                            </a>
                        </li>

                        <li>
                            <a
                               href="${pageContext.request.contextPath}/Contract">
                                Contracts
                            </a>
                        </li>

                        <li>
                            <a
                               href="${pageContext.request.contextPath}/Invoice">
                                Invoices
                            </a>
                        </li>

                        <li>
                            <a
                               href="${pageContext.request.contextPath}/logout">
                                Logout
                            </a>
                        </li>

                    </ul>

                </div>

            </div>
        </nav>

        <div></div>
    </body>
</html>


