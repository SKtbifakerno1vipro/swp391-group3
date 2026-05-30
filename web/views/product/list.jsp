<%-- 
    Document   : list
    Created on : May 30, 2026, 12:55:27 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product List</title>
    </head>
    <body>
        <div>
            <h2>Products</h2>
            <div><a href="${pageContext.request.contextPath}/create-product"></a></div>
            <div><form action="${pageContext.request.contextPath}/product-list" method="get">
                    <table>
                        <tr>
                            <td>Product Name</td>
                            <td><input type="text" name="searchText" value="${searchText}"></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                               
                                    Category
                                    <select name="categoryId">
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.categoryId}" ${c.categoryId == categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                        </c:forEach>
                                    </select>

                                
                                | Status
                                <select name="status">
                                    <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                    <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                                </select>

                            </td>
                        </tr>
                        <tr>
                            <td><input type="submit" name="search" value="Search"></td>
                        </tr>
                    </table>
                </form>
            </div>
            <div>
                <h3>Product List</h3>
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
                            <td>${p.costPrice}</td>
                            <td>${p.sellingPrice}</td>
                            <td>${p.unit}</td>
                            <td>${p.quantityAvailable}</td>
                            <td>${p.categoryName}</td>
                            <td>${p.productStatus}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </body>
</html>
