<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Pơ Bread</title>

    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;600;700&family=Nunito+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#4a7c59",
                        background: "#faf6f0",
                        surface: "#ffffff",
                        error: "#b83230"
                    },
                    fontFamily: {
                        headline: ["Literata", "serif"],
                        body: ["Nunito Sans", "sans-serif"]
                    }
                }
            }
        }
    </script>
</head>

<body class="min-h-screen bg-background font-body text-gray-800">

<main class="flex min-h-screen">

    <!-- Left section -->
    <section class="hidden lg:flex lg:w-1/2 items-center justify-center p-12 bg-[#f0ece4]">
        <div class="max-w-lg text-center">
            <div class="text-7xl mb-6">🥐</div>

            <h1 class="text-4xl font-headline font-bold text-primary mb-4">
                Pơ Bread
            </h1>

            <p class="text-gray-600 leading-relaxed">
                Sales Process Digitalization System for managing users, roles,
                customers, contracts, providers and reports.
            </p>
        </div>
    </section>

    <!-- Right section -->
    <section class="w-full lg:w-1/2 flex items-center justify-center p-6 bg-[#F9FAFB]">

        <div class="w-full max-w-md bg-white p-10 rounded-2xl shadow-lg border border-gray-200">

            <div class="text-center mb-8">
                <div class="text-5xl mb-4">🥖</div>

                <h2 class="text-3xl font-headline font-bold text-primary">
                    Welcome Back
                </h2>

                <p class="text-gray-500 mt-2">
                    Sign in to continue to Pơ Bread system
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-5">

                <div>
                    <label class="block text-sm font-semibold mb-2">
                        Username
                    </label>

                    <input
                        type="text"
                        name="username"
                        required
                        placeholder="Enter username"
                        class="w-full rounded-lg border-gray-300 focus:border-primary focus:ring-primary"
                    >
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-2">
                        Password
                    </label>

                    <input
                        type="password"
                        name="password"
                        required
                        placeholder="Enter password"
                        class="w-full rounded-lg border-gray-300 focus:border-primary focus:ring-primary"
                    >
                </div>

                <div class="flex items-center justify-between text-sm">
                    <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-gray-300 text-primary">
                        Remember me
                    </label>

                    <a href="javascript:void(0)" class="text-primary font-semibold hover:underline">
                        Forgot password?
                    </a>
                </div>

                <button
                    type="submit"
                    class="w-full bg-primary text-white py-3 rounded-lg font-bold hover:bg-[#3d684a] transition">
                    Login
                </button>

                <p class="text-center text-red-600 font-semibold">
                    ${error}
                </p>

            </form>

            <div class="mt-8 text-center text-xs text-gray-400">
                © 2026 Pơ Bread. SWP391 Group 3.
            </div>

        </div>
    </section>

</main>

</body>
</html>
