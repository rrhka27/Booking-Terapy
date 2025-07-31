<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Jasa Terapi MI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #2D5A3D 0%, #4A7C59 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(45, 90, 61, 0.15);
            max-width: 400px;
            width: 100%;
        }
        .form-control {
            border: 2px solid #E8F5E8;
            padding: 15px;
            border-radius: 10px;
        }
        .form-control:focus {
            border-color: #7FB069;
            box-shadow: 0 0 0 0.2rem rgba(127, 176, 105, 0.25);
        }
        .btn-primary-custom {
            background: linear-gradient(135deg, #2D5A3D 0%, #4A7C59 100%);
            border: none;
            padding: 15px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            color: white;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(45, 90, 61, 0.2);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h3 class="text-center mb-4" style="color: #2D5A3D;">Login ke Jasa Terapi MI</h3>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <form action="login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary-custom w-100">
                <i class="fas fa-sign-in-alt me-2"></i>Login
            </button>
        </form>
        <p class="text-center mt-3">Belum punya akun? <a href="register.jsp">Daftar sekarang</a></p>
        <div class="text-center mt-3">
            <a href="index.jsp" class="btn btn-primary-custom w-100">
                <i class="fas fa-home me-2"></i>Kembali ke Beranda
            </a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>