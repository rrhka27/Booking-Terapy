<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Jasa Terapi MI</title>
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
            display: block;
            width: 100%;
            text-align: center;
            color: white;
            text-decoration: none;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(45, 90, 61, 0.2);
        }
        .btn-link {
            color: #2D5A3D;
            text-decoration: none;
        }
        .btn-link:hover {
            text-decoration: underline;
            color: #4A7C59;
        }
        h2 {
            color: #2D5A3D;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2 class="text-center mb-4">Registrasi</h2>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <form action="register" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <button type="submit" class="btn btn-primary-custom">
                <i class="fas fa-user-alt me-2"></i>Register</button>
            <p class="text-center mt-3">
                Sudah punya akun?<a href="login.jsp" class="btn btn-link"> Login</a>
            </p>
            <div class="text-center mt-3">
                <a href="index.jsp" class="btn btn-primary-custom">
                    <i class="fas fa-home me-2"></i>Kembali ke Beranda
                </a>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>