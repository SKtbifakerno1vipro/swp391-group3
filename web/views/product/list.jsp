<%--
    Document   : list
    Created on : May 30, 2026, 12:55:27 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product List</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .pagination {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:20px;
                border-top:1px solid var(--line);
            }
            .page-link,.page-current {
                min-width:36px;
                height:36px;
                display:grid;
                place-items:center;
                border-radius:12px;
                font-weight:900;
                text-decoration:none;
                color: whitesmoke
            }
            .page-link {
                background:var(--surface-soft);
                color:var(--muted);
            }
            .page-current,.page-link:hover {
                background:var(--primary);
                color:#fff;
            }
            .disabled {
                opacity:.45;
                pointer-events:none;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="products"/>
            </jsp:include>
            <main class="main legacy-page">
                <div>
                    <h1>Products</h1>
                    <c:if test="${errorDelete != null || empty errorDelete}"> ${errorDelete}</c:if>
                    <div><form action="${pageContext.request.contextPath}/product-list" method="get">
                            <table>
                                <tr>
                                    <td>Product Name</td>
                                    <td><input type="text" name="searchText" value="${searchText}"></td>

                                    <td colspan="2">
                                        Category
                                        <select name="categoryId">
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c.categoryId}" ${c.categoryId == categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                        |Price
                                        <select name="sort">
                                            <option value="default" ${sort == 'default' ? 'selected' : ''}>Default</option>
                                            <option value="increase" ${sort == 'increase' ? 'selected' : ''}>Increase</option>
                                            <option value="decrease" ${sort == 'decrease' ? 'selected' : ''}>Decrease</option>
                                        </select>
                                    </td>

                                    <td><input type="submit" value="Search"></td>
                                </tr>
                            </table>

                            <input type="hidden" name="page" value="${page}">
                            <input type="hidden" name="totalRow" value="${totalRow}">
                            <input type="hidden" name="totalPage" value="${totalPage}">
                        </form>
                    </div>
                    <div>
                        <h3>Product List</h3>
                        <div><a href="${pageContext.request.contextPath}/edit-product?action=create">Create Product</a></div>
                        <div>
                            <table border="1">
                                <tr>
                                    <th>Product Id</th>
                                    <th>Product Name</th>
                                    <th>Cost Price</th>
                                    <th>Selling Price</th>
                                    <th>Unit</th>
                                    <th>Quantity</th>
                                    <th>Category Name</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="8">No product found.</td>
                                    </tr>
                                </c:if>
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <td>${p.productId}</td>
                                        <td>${p.productName}</td>
                                        <td><fmt:formatNumber value="${p.costPrice}" pattern="#,##0.##"/></td>
                                        <td><fmt:formatNumber value="${p.sellingPrice}" pattern="#,##0.##"/></td>
                                        <td>${p.unit}</td>
                                        <td><fmt:formatNumber value="${p.quantityAvailable}" pattern="#,##0"/></td>
                                        <td>${p.categoryName}</td>
                                        <td>${p.productStatus}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/edit-product?id=${p.productId}&action=edit">Edit</a> |
                                            <form action="product-list" method="post" style="display: inline">
                                                <input type="submit" value="Delete">
                                                <input type="hidden" name="id" value="${p.productId}">
                                            </form>

                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>
                        <div class="pagination">
                            <c:set var="numLinksTwoSide" value="2"></c:set>
                            <c:set var="start" value="${page - numLinksTwoSide > 1 ? page - numLinksTwoSide : 1}"></c:set>
                            <c:set var="end" value="${page + numLinksTwoSide > totalPage ? totalPage : page + numLinksTwoSide}"></c:set>

                                <a class="page-link" href="${pageContext.request.contextPath}/product-list?page=1&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Begin</a>
                            <c:if test="${page!=1}"><a class="page-link" href="${pageContext.request.contextPath}/product-list?page=${page - 1}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Prerious</a></c:if>
                            <c:if test="${start>1}">...</c:if>
                            <c:forEach var="i" begin="${start}" end="${end}">
                                <a href="${pageContext.request.contextPath}/product-list?page=${i}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}"><span class="${i==page?'page-current' : 'page-link'}">${i}</span> </a>
                            </c:forEach>
                            <c:if test="${end < totalPage}">...</c:if>
                            <c:if test="${page < totalPage}"><a class="page-link" href="${pageContext.request.contextPath}/product-list?page=${page + 1}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Next</a></c:if>
                            <a class="page-link" href="${pageContext.request.contextPath}/product-list?page=${totalPage}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">End</a>

                        </div>
                        <div><a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
                    </div>
                </div>


            </main>
        </div>
        <script>
            let error = "${errorProduct}";
            if (error !== "") {
                alert(error);
            }
        </script>
    </body>
</html>
