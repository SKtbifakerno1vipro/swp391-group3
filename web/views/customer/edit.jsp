<%--
    EditCustomer.jsp â€” uses frontend template from frontend.txt
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Edit Customer - Terra Enterprise</title>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect"/>
    
    
    
    
    
</head>
<body>
    <!-- Top nav + side simplified to reuse template look -->
    <header>
        <div>
            <div>
                <input placeholder="Search..." type="text"/>
            </div>
        </div>
        <div>
            <h1>Terra</h1>
        </div>
        <div>Admin</div>
    </header>

    <nav>
        <div><h1>Terra</h1></div>
    </nav>

    <main>
        <div>
            <h2>Edit Customer</h2>

            <c:if test="${not empty success}">
                <div>Edit successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div>Edit failed</div>
                <c:if test="${not empty errorDetail}">
                    <div>${errorDetail}</div>
                </c:if>
            </c:if>

            <c:if test="${not empty customer}">
                <form action="EditCustomer" method="post">
                    <input type="hidden" name="customerId" value="${customer.customerId}" />
                    <div>
                        <div>
                            <label>Customer ID</label>
                            <input value="${customer.customerId}" readonly />
                        </div>
                        <div>
                            <label>User ID</label>
                            <input value="${customer.userId}" readonly />
                        </div>
                        <div>
                            <label>Username</label>
                            <input name="username" value="${user.userName}" />
                        </div>
                        <div>
                            <label>Password</label>
                            <input name="password" type="password" placeholder="Leave blank to keep current" />
                        </div>
                        <div>
                            <label>Email</label>
                            <input name="email" value="${user.email}" />
                        </div>
                        <div>
                            <label>Full name</label>
                            <input name="fullname" value="${user.fullName}" />
                        </div>
                        <div>
                            <label>Status</label>
                            <select name="status">
                                <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div>
                            <label>Tax Code</label>
                            <input name="taxCode" value="${customer.taxCode}" required />
                        </div>
                        <div>
                            <label>Type</label>
                            <input name="type" value="${customer.type}" required />
                        </div>
                    </div>

                    <div>
                        <a href="CustomerDetail?id=${customer.customerId}">Cancel</a>
                        <button type="submit">Save changes</button>
                    </div>
                </form>
            </c:if>
        </div>
    </main>
</body>
</html>


