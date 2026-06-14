<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Pơ Bread</title>
        <!-- Tailwind CSS (CDN) -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;600;700&family=Nunito+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: "#4a7c59",
                            "on-primary-fixed-variant": "#2a6038",
                            background: "#faf6f0",
                            surface: "#ffffff",
                            "surface-container-low": "#f5f1ea",
                            "on-surface": "#2e3230",
                            "on-surface-variant": "#4a4e4a",
                            outline: "#74796e",
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
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .hero-gradient {
                background: linear-gradient(135deg, #4a7c59 0%, #2a4a35 100%);
            }
        </style>
    </head>

    <body class="min-h-screen flex items-center justify-center bg-background font-body text-on-surface">

        <main class="flex w-full max-w-5xl bg-surface-container-low rounded-xl shadow-lg overflow-hidden min-h-[600px]">

            <!-- Left section -->
            <section class="hidden lg:flex lg:w-1/2 hero-gradient p-12 flex-col justify-center text-white">
                <div class="space-y-4 text-center">
                    <div class="text-6xl">🥐</div>
                    <h1 class="text-4xl font-headline font-bold">Pơ Bread</h1>
                    <p class="text-sm opacity-90 leading-relaxed">
                        Sales Process Digitalization System for managing users, roles,
                        customers, contracts, providers and reports.
                    </p>
                </div>
            </section>

            <!-- Right section -->
            <section class="w-full lg:w-1/2 p-8 flex items-center">
                <div class="w-full max-w-md mx-auto space-y-6">

                    <div class="text-center">
                        <div class="text-5xl">🥖</div>
                        <h2 class="mt-4 text-2xl font-headline font-semibold text-primary">Welcome Back</h2>
                        <p class="mt-2 text-sm text-on-surface-variant">Sign in to continue to Pơ Bread system</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-1" for="username">Username</label>
                            <input type="text" id="username" name="username" required placeholder="Enter username"
                                   class="block w-full px-4 py-3 bg-surface rounded-lg border border-outline focus:border-primary focus:ring-2 focus:ring-primary/20 transition">
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-on-surface-variant mb-1" for="password">Password</label>
                            <input type="password" id="password" name="password" required placeholder="Enter password"
                                   class="block w-full px-4 py-3 bg-surface rounded-lg border border-outline focus:border-primary focus:ring-2 focus:ring-primary/20 transition">
                        </div>

                        <div class="flex items-center justify-between text-sm">
                            <label class="flex items-center gap-2 cursor-pointer">
                                <input type="checkbox" class="accent-primary">
                                <span class="text-on-surface-variant">Remember me</span>
                            </label>
                            <a href="${pageContext.request.contextPath}/user/password/forgot" class="font-semibold text-primary hover:underline">Forgot password?</a>
                        </div>

                        <button type="submit" class="w-full py-3 bg-primary text-white rounded-lg font-bold hover:bg-on-primary-fixed-variant transition active:scale-95">
                            Login
                        </button>

                        <p class="text-center text-sm text-error">${error}</p>
                    </form>

                    <div class="text-center text-xs text-on-surface-variant pt-6 border-t border-gray-200">
                        © 2026 Pơ Bread. SWP391 Group 3.
                    </div>

                </div>
            </section>
        </main>

    </body>
</html>