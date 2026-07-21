<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SWP391 Contract Auto-Generator Tool</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #1f4037, #99f2c8); 
            min-height: 100vh; 
            margin: 0; 
            padding: 20px; 
            color: #333; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
        }
        .container { 
            background: rgba(255, 255, 255, 0.95); 
            padding: 35px; 
            border-radius: 16px; 
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2); 
            max-width: 750px; 
            width: 100%; 
            backdrop-filter: blur(10px); 
        }
        h2 { 
            color: #1e5236; 
            text-align: center; 
            margin-bottom: 25px; 
            font-weight: 700; 
            border-bottom: 3px solid #99f2c8; 
            padding-bottom: 12px; 
        }
        .form-group { 
            margin-bottom: 22px; 
        }
        label { 
            font-weight: 700; 
            display: block; 
            margin-bottom: 8px; 
            color: #1f4037; 
        }
        select, input[type='text'], input[type='number'] { 
            width: 100%; 
            padding: 12px; 
            border-radius: 8px; 
            border: 1px solid #ccc; 
            font-size: 14px; 
            box-sizing: border-box; 
            background-color: #fff;
        }
        select:focus, input:focus { 
            border-color: #1f4037; 
            outline: none; 
            box-shadow: 0 0 8px rgba(31, 64, 55, 0.2); 
        }
        .product-list { 
            max-height: 250px; 
            overflow-y: auto; 
            border: 1px solid #ddd; 
            padding: 12px; 
            border-radius: 8px; 
            background: #fafafa; 
        }
        .product-item { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            margin-bottom: 10px; 
            padding: 10px; 
            border-bottom: 1px solid #eee; 
            border-radius: 6px;
            background: #ffffff;
        }
        .product-item:last-child { 
            border-bottom: none; 
        }
        .product-item label { 
            display: inline; 
            margin-left: 10px; 
            font-weight: 600; 
            cursor: pointer; 
            color: #444;
        }
        .product-qty { 
            width: 90px !important; 
            padding: 6px; 
            text-align: center; 
        }
        .btn-submit { 
            background: linear-gradient(135deg, #1f4037, #2c7a5f); 
            color: white; 
            border: none; 
            padding: 15px 20px; 
            border-radius: 8px; 
            font-size: 16px; 
            font-weight: bold; 
            width: 100%; 
            cursor: pointer; 
            transition: all 0.3s; 
            margin-top: 15px; 
        }
        .btn-submit:hover { 
            background: linear-gradient(135deg, #2c7a5f, #1f4037);
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(31, 64, 55, 0.4); 
        }
        .btn-submit:active { 
            transform: translateY(0); 
        }
        .alert { 
            padding: 14px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            font-weight: 600; 
        }
        .alert-danger { 
            background-color: #f8d7da; 
            color: #721c24; 
            border: 1px solid #f5c6cb; 
        }
        .alert-success { 
            background-color: #d4edda; 
            color: #155724; 
            border: 1px solid #c3e6cb; 
        }
        .link-btn { 
            display: inline-block; 
            background: #007bff; 
            color: white; 
            padding: 10px 20px; 
            text-decoration: none; 
            border-radius: 6px; 
            font-weight: bold; 
            margin-top: 12px; 
            margin-right: 12px; 
            transition: background 0.2s;
        }
        .link-btn-green { 
            background: #28a745; 
        }
        .link-btn:hover { 
            opacity: 0.9; 
        }
        hr {
            border: 0;
            border-top: 1px solid #eee;
            margin: 20px 0;
        }
        .nav-back {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #1f4037;
            font-weight: 600;
            text-decoration: none;
        }
        .nav-back:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>SWP391 Contract Auto-Generator</h2>

    <%
        String errorMsg = (String) session.getAttribute("tool_error");
        String successMsg = (String) session.getAttribute("tool_success");
        Integer createdQuotationId = (Integer) session.getAttribute("created_quotation_id");
        Integer createdContractId = (Integer) session.getAttribute("created_contract_id");

        session.removeAttribute("tool_error");
        session.removeAttribute("tool_success");
        session.removeAttribute("created_quotation_id");
        session.removeAttribute("created_contract_id");
    %>

    <% if (errorMsg != null) { %>
        <div class="alert alert-danger"><%= errorMsg %></div>
    <% } %>
    
    <% if (successMsg != null) { %>
        <div class="alert alert-success"><%= successMsg %></div>
        <% if (createdQuotationId != null) { %>
            <a href="${pageContext.request.contextPath}/quotation-detail?id=<%= createdQuotationId %>" class="link-btn" target="_blank">Xem Báo Giá #<%= createdQuotationId %></a>
        <% } %>
        <% if (createdContractId != null) { %>
            <a href="${pageContext.request.contextPath}/contract-detail?id=<%= createdContractId %>" class="link-btn link-btn-green" target="_blank">Xem Hợp Đồng #<%= createdContractId %></a>
        <% } %>
        <hr>
    <% } %>

    <form action="${pageContext.request.contextPath}/tool/auto-generate" method="POST">
        <!-- Select Customer -->
        <div class="form-group">
            <label for="customerId">Chọn Khách Hàng (Customer):</label>
            <select name="customerId" id="customerId" required>
                <c:forEach var="customer" items="${customers}">
                    <option value="${customer.customer.customerId}" ${param.customerId == customer.customer.customerId ? 'selected' : ''}>${customer.customer.companyName} (ID: ${customer.customer.customerId} - User ID: ${customer.customer.userId})</option>
                </c:forEach>
            </select>
        </div>

        <!-- Select Manager -->
        <div class="form-group">
            <label for="managerId">Chọn Người Ký Đại Diện (Manager):</label>
            <select name="managerId" id="managerId" required>
                <c:forEach var="manager" items="${managers}">
                    <option value="${manager.userId}">${manager.fullName} (ID: ${manager.userId})</option>
                </c:forEach>
            </select>
        </div>

        <!-- Product list with quantity fields -->
        <div class="form-group">
            <label>Chọn các sản phẩm và số lượng:</label>
            <div class="product-list">
                <c:forEach var="product" items="${products}">
                    <div class="product-item">
                        <div>
                            <input type="checkbox" name="productIds" value="${product.productId}" id="prod_${product.productId}" checked />
                            <label for="prod_${product.productId}">
                                <strong>${product.productName}</strong> (${product.unit} - <fmt:formatNumber value="${product.sellingPrice}" type="number" maxFractionDigits="0"/> đ)
                            </label>
                        </div>
                        <input type="number" name="qty_${product.productId}" class="product-qty" value="10" min="1" required />
                    </div>
                </c:forEach>
            </div>
        </div>

        <button type="submit" class="btn-submit">Tự Động Tạo Quotation & Contract</button>
    </form>
    
    <a href="${pageContext.request.contextPath}/dashboard" class="nav-back"> Quay về Dashboard</a>
</div>
</body>
</html>
