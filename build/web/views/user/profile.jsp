<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil User - Sistem Booking Jasa Terapi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700">
    <style>
        .card { border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-header { background-color: #e0f7fa; color: #0288d1; }
        .btn { border-radius: 8px; }
    </style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
    <!-- Navbar -->
    <%@ include file="../template/navbar.jsp" %>

    <!-- Sidebar -->
    <%@ include file="../template/sidebar.jsp" %>

   <!-- Content Wrapper -->
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Profil User</h1>
                    </div>
                </div>
            </div>
        </div>
        <section class="content">
            <div class="container-fluid">
                <!-- Pesan Sukses/Error -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                        ${error}
                    </div>
                </c:if>

                <!-- Data Profil -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Data Profil</h3>
                    </div>
                    <div class="card-body">
                        <p><strong>Username:</strong> ${sessionScope.user.username}</p>
                        <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                        <p><strong>Role:</strong> ${sessionScope.user.role}</p>
                    </div>
                </div>

                <!-- Form Edit Profil -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Edit Profil</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/profile" method="post" onsubmit="return confirm('Apakah Anda yakin ingin menyimpan perubahan?');">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" name="username" id="username" class="form-control" 
                                       value="${sessionScope.user.username}" disabled>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" name="email" id="email" class="form-control" 
                                       value="${sessionScope.user.email}" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Password Baru (kosongkan jika tidak ingin mengubah)</label>
                                <input type="password" name="password" id="password" class="form-control" 
                                       placeholder="Masukkan password baru">
                            </div>
                            <div class="form-group">
                                <label for="confirm_password">Konfirmasi Password Baru</label>
                                <input type="password" name="confirm_password" id="confirm_password" class="form-control" 
                                       placeholder="Konfirmasi password baru">
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Perubahan</button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary"><i class="fas fa-times"></i> Batal</a>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- Footer -->
    <%@ include file="../template/footer.jsp" %>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>