<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Pơ Bread</title>
        <script src="https://cdn.tailwindcss.com"></script>
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
                            outline: "#c4c8bc",
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
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 20;
            }
            .hero-gradient {
                background: linear-gradient(135deg, #4a7c59 0%, #2a4a35 100%);
            }
        </style>
    </head>

    <body class="min-h-screen bg-background font-body text-on-surface flex items-center justify-center p-6">

        <main class="flex w-full max-w-5xl bg-surface rounded-2xl shadow-xl overflow-hidden min-h-[600px] border border-outline/30">

            <!-- Left section -->
            <section class="hidden lg:flex lg:w-1/2 hero-gradient p-12 flex-col justify-center text-white items-center text-center">
                <div class="space-y-6 max-w-sm">
                    <div class="text-7xl">🥐</div>
                    <h1 class="text-5xl font-headline font-bold">Pơ Bread</h1>
                    <p class="text-lg opacity-90 leading-relaxed font-body">
                        Sales Process Digitalization System for managing users, roles,
                        customers, contracts, providers and reports.
                    </p>
                </div>
            </section>

            <!-- Right section -->
            <section class="w-full lg:w-1/2 p-8 sm:p-12 flex items-center">
                <div class="w-full max-w-md mx-auto space-y-8">

                    <div class="text-center">
                        <div class="text-5xl mb-4">🥖</div>
                        <h2 class="text-3xl font-headline font-bold text-on-surface">Welcome Back</h2>
                        <p class="mt-2 text-on-surface-variant">Sign in to continue to Pơ Bread</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-6">
                        <div class="space-y-2">
                            <label class="block text-sm font-semibold text-on-surface-variant" for="username">Username</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-outline"><span class="material-symbols-outlined">person</span></span>
                                <input type="text" id="username" name="username" required placeholder="Enter username"
                                       class="block w-full pl-10 pr-4 py-3 bg-surface-container-low rounded-xl border-transparent focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all">
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label class="block text-sm font-semibold text-on-surface-variant" for="password">Password</label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-outline"><span class="material-symbols-outlined">lock</span></span>
                                <input type="password" id="password" name="password" required placeholder="Enter password"
                                       class="block w-full pl-10 pr-4 py-3 bg-surface-container-low rounded-xl border-transparent focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all">
                            </div>
                        </div>

                        <div class="flex items-center justify-between text-sm">
                            <label class="flex items-center gap-2 cursor-pointer group">
                                <input type="checkbox" class="w-4 h-4 rounded border-outline text-primary focus:ring-primary">
                                <span class="text-on-surface-variant group-hover:text-primary transition-colors">Remember me</span>
                            </label>
                            <a href="${pageContext.request.contextPath}/user/password/forgot" class="font-semibold text-primary hover:underline">Forgot password?</a>
                        </div>

                        <button type="submit" class="w-full py-4 bg-primary text-white rounded-xl font-bold tracking-wide shadow-md hover:bg-on-primary-fixed-variant hover:shadow-lg active:scale-[0.98] transition-all">
                            Login
                        </button>

                        <c:if test="${not empty error}">
                            <p class="text-center text-sm font-medium text-error p-3 bg-error/10 rounded-lg">${error}</p>
                        </c:if>
                    </form>

                    <div class="text-center text-xs text-outline pt-8 border-t border-outline/30">
                        © 2026 Pơ Bread. SWP391 Group 3.
                    </div>

                </div>
            </section>
        </main>
    </body>
</html>