<%-- 
    Document   : detail
    Created on : May 31, 2026, 12:57:11 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Detail</title>
    </head>
    <body>
        <div>
            <c:if test="${action == 'edit'}">
                <h1>Product Edit</h1>
            </c:if>
            <c:if test="${action != 'edit'}">
                <h1>Product Detail</h1>
            </c:if>
            <div>
                <form action="edit-product?id=${product.productId}" method="post">
                    <table border="1">
                        <tr>
                            <td>Product Name</td>
                            <td><input type="text" name="name" value="${product.productName}" ${action == 'edit' ? ' ' : 'readonly'} required></td>
                        </tr>
                        <tr>
                            <td>Cost Price</td>
                            <fmt:formatNumber var="fmtCost" value="${product.costPrice}" pattern="#"/>
                            <td><input type="number"  name="cost" value="${fmtCost}" min="0" ${action == 'edit' ? ' ' : 'readonly'} required></td>
                        </tr>
                        <tr>
                            <td>Selling Price</td>
                            <fmt:formatNumber var="fmtSell" value="${product.sellingPrice}" pattern="#"/>
                            <td><input type="number" name="sell" value="${fmtSell}" min="0" ${action == 'edit' ? ' ' : 'readonly'} required></td>
                        </tr>
                        <tr>
                            <td>Description</td>
                            <td><textarea name="description" rows="5" cols="20" ${action == 'edit' ? ' ' : 'readonly'} required>${product.description}</textarea></td>
                        </tr>
                        <tr>
                            <td>Unit</td>
                            <td>
                                <select name="unit" ${action == 'edit' ? ' ' : 'disabled'}>
                                    <c:forEach var="u" items="${units}">
                                        <option value="${u}" ${u == product.unit ? 'selected':''}>${u}</option>
                                    </c:forEach>
                                </select>

                            </td>
                        </tr>
                        <tr>
                            <td>Product Status</td>
                            <td>
                                <select name="status" ${action == 'edit' ? ' ' : 'disabled'}>
                                    <c:forEach var="s" items="${statusList}">
                                        <option value="${s}" ${s == product.productStatus ? 'selected':''}>${s}</option>
                                    </c:forEach>
                                </select>

                            </td>
                        </tr>
                        <tr>
                            <td>Quantity</td>
                            <td><input type="number" name="quantity" value="${product.quantityAvailable}" min="0" ${action == 'edit' ? ' ' : 'readonly'} required></td>
                        </tr>
                        <tr>
                            <td>Category</td>
                            <td>
                                <select name="categoryId" ${action == 'edit' ? ' ' : 'disabled'}>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.categoryId}" ${c.categoryId == product.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Create At</td>
                            <td><fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>

                        </tr>
                        <tr>
                            <td>Update At</td>
                            <td><fmt:formatDate value="${product.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>

                        </tr>
                        <tr>
                            <td>Update By</td>
                            <td><input type="text" name="update_by" value="${update_by}" readonly></td>
                        </tr>
                    </table>
                    <div>
                        <c:if test="${action == 'edit'}">
                            <input type="submit" name="action" value="Save">
                            <a href="${pageContext.request.contextPath}/product-list">Cancel</a>  
                        </c:if>
                        <c:if test="${action != 'edit'}">    
                        <a href="${pageContext.request.contextPath}/edit-product?id=${product.productId}&action=edit"><button type="button">Edit</button></a>
                        <a href="${pageContext.request.contextPath}/product-list">Cancel</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
