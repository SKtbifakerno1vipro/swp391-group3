<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Pơ Bread</title>
</head>

<body>

<main>

    <!-- Left section -->
    <section>
        <div>
            <div>🥐</div>

            <h1>
                Pơ Bread
            </h1>

            <p>
                Sales Process Digitalization System for managing users, roles,
                customers, contracts, providers and reports.
            </p>
        </div>
    </section>

    <!-- Right section -->
    <section>

        <div>

            <div>
                <div>🥖</div>

                <h2>
                    Welcome Back
                </h2>

                <p>
                    Sign in to continue to Pơ Bread system
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post">

                <div>
                    <label>
                        Username
                    </label>

                    <input
                        type="text"
                        name="username"
                        required
                        placeholder="Enter username"
                    >
                </div>

                <div>
                    <label>
                        Password
                    </label>

                    <input
                        type="password"
                        name="password"
                        required
                        placeholder="Enter password"
                    >
                </div>

                <div>
                    <label>
                        <input type="checkbox">
                        Remember me
                    </label>

                    <a href="${pageContext.request.contextPath}/user/password/forgot">
                        Forgot password?
                    </a>
                </div>

                <button
                    type="submit">
                    Login
                </button>

                <p>
                    ${error}
                </p>

            </form>

            <div>
                © 2026 Pơ Bread. SWP391 Group 3.
            </div>

        </div>
    </section>

</main>

</body>
</html>
