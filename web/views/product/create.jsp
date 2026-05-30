<%-- 
    Document   : create
    Created on : May 30, 2026, 2:42:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Product</title>
    </head>
    <body>
        <div>
            <h2>Create Product</h2>
            <form action="create-product" method="post">
                <table>
                    <tr>
                        <td>Product Name</td>
                        <td><input type="text" name="name" value="${name}" required></td>
                    </tr>
                    <tr>
                        <td>Cost Price</td>
                        <td><input type="number" name="cost" value="${cost}" required min="0"></td>
                    </tr>
                    <tr>
                        <td>Selling Price</td>
                        <td><input type="number" name="sell" value="${sell}" required min="0"></td>
                    </tr>
                    <tr>
                        <td>Description</td>
                        <td><textarea name="description" rows="5" cols="20" required>${description}</textarea></td>
                    </tr>
                    <tr>
                        <td>Unit</td>
                        <td>
                            <select name="unit">
                                <c:forEach var="u" items="${units}">
                                    <option value="${u}" ${u == unit ? 'selected':''}>${u}</option>
                                </c:forEach>
                            </select>

                        </td>
                    </tr>
                    <tr>
                        <td>Product Status</td>
                        <td>
                            <select name="status">
                                <c:forEach var="s" items="${statusList}">
                                    <option value="${s}" ${s == status ? 'selected':''}>${s}</option>
                                </c:forEach>
                            </select>

                        </td>
                    </tr>
                    <tr>
                        <td>Quantity</td>
                        <td><input type="number" name="quantity" value="${quantity}" required min="0"></td>
                    </tr>
                    <tr>
                        <td>Category</td>
                        <td>
                            <select name="categoryId">
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}" ${c.categoryId == categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <input type="hidden" name="upby" value="${sessionScope.user.userId}">
                    <tr>
                        <td colspan="2"><input type="submit" name="Create" value="Create"> 
                            <a href="${pageContext.request.contextPath}/product-list">Cancel</a></td>
                    </tr>

                </table>
                <div>${error}</div>
            </form>
        </div>

    </body>
</html>
