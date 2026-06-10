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
                                    <a href="${pageContext.request.contextPath}/product-list?id=${p.productId}&delete=true&page=${page}&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}">Delete</a>
                                    
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
                <div>
                    
                    <div>
                        Page
                    <select  onchange="window.location.href='${pageContext.request.contextPath}/product-list?page='+this.value +'&searchText=${searchText}&categoryId=${categoryId}&sort=${sort}'">
                        <c:forEach var="i" begin="1" end="${totalPage}">
                            <option value="${i}" ${page == i ? 'selected' : ''}>${i}</option>
                        </c:forEach>
                    </select>
                    </div>
                </div>
                <div><a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
            </div>
        </div>

    </body>
</html>
