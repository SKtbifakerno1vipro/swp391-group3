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
    </head>
    <body>
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
                <div><a href="${pageContext.request.contextPath}/create-product">Create Product</a></div>
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
                                    <a href="${pageContext.request.contextPath}/edit-product?id=${p.productId}&action=detail">View</a> |
                                    <form action="product-list" method="post" style="display: inline">
                                        <input type="submit" value="Delete">
                                        <input type="hidden" name="id" value="${p.productId}">
                                    </form>

                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <div>
                    <c:set var="numLinksTwoSide" value="2"></c:set>
                    <c:set var="start" value="${page - numLinksTwoSide > 1 ? page : 1}"></c:set>
                    <c:set var="end" value="${page + numLinksTwoSide > totalPage ? totalPage : page + numLinksTwoSide}"></c:set>
                        <table border="1">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/product-list?page=1&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Begin</a></td>
                            <c:if test="${page!=1}"><td><a href="${pageContext.request.contextPath}/product-list?page=${page - 1}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Prerious</a></td></c:if>
                            <c:if test="${start>1}"><td>...</td></c:if>
                            <c:forEach var="i" begin="${start}" end="${end}">
                                <td><a href="${pageContext.request.contextPath}/product-list?page=${i}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">${i}</a></td>
                                </c:forEach>
                                <c:if test="${end < totalPage}"><td>...</td></c:if>
                            <c:if test="${page < totalPage}"><td><a href="${pageContext.request.contextPath}/product-list?page=${page + 1}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Next</a> </td></c:if>
                            <td><a href="${pageContext.request.contextPath}/product-list?page=${totalPage}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">End</a>
                            </tr>
                        </table>

                </div>
                <div><a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
            </div>
        </div>

    </body>
</html>
