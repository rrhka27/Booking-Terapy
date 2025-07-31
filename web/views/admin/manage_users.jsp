<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola User - Sistem Booking Jasa Terapi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700">
    <style>
        .card { border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-header { background-color: #e0f7fa; color: #0288d1; }
        .btn { border-radius: 8px; }
        .table-responsive { overflow-x: auto; }
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
                        <h1 class="m-0">Kelola User</h1>
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

                <!-- Form Pencarian dan Filter -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Cari dan Filter User</h3>
                        <div class="card-tools">
                            <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addModal"><i class="fas fa-plus"></i> Tambah User</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/manageUsers" method="get" id="filterForm">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="search">Cari (Username/Email)</label>
                                        <input type="text" name="search" id="search" class="form-control" 
                                               value="${search}" placeholder="Masukkan kata kunci">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="roleFilter">Role</label>
                                        <select name="roleFilter" id="roleFilter" class="form-control">
                                            <option value="all" ${roleFilter == 'all' ? 'selected' : ''}>Semua</option>
                                            <option value="admin" ${roleFilter == 'admin' ? 'selected' : ''}>Admin</option>
                                            <option value="user" ${roleFilter == 'user' ? 'selected' : ''}>User</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="sortBy">Urutkan Berdasarkan</label>
                                        <select name="sortBy" id="sortBy" class="form-control">
                                            <option value="id" ${sortBy == 'id' ? 'selected' : ''}>ID</option>
                                            <option value="username" ${sortBy == 'username' ? 'selected' : ''}>Username</option>
                                            <option value="email" ${sortBy == 'email' ? 'selected' : ''}>Email</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <button type="submit" class="btn btn-primary btn-block"><i class="fas fa-search"></i> Cari</button>
                                    </div>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/manageUsers" class="btn btn-secondary"><i class="fas fa-undo"></i> Reset Filter</a>
                        </form>
                    </div>
                </div>

                <!-- Modal Tambah User -->
                <div class="modal fade" id="addModal">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Tambah User Baru</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <form action="${pageContext.request.contextPath}/manageUsers" method="post" onsubmit="return validateAddForm()">
                                <input type="hidden" name="action" value="add">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label for="username">Username</label>
                                        <input type="text" name="username" id="username" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email</label>
                                        <input type="email" name="email" id="email" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="password">Password</label>
                                        <input type="password" name="password" id="password" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="role">Role</label>
                                        <select name="role" id="role" class="form-control" required>
                                            <option value="user">User</option>
                                            <option value="admin">Admin</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Batal</button>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Tabel User -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Daftar User</h3>
                    </div>
                    <div class="card-body table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.role == 'admin'}">
                                                    <span class="badge badge-primary">Admin</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-info">User</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#editModal${user.id}"><i class="fas fa-edit"></i> Edit</button>
                                            <form action="${pageContext.request.contextPath}/manageUsers" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${user.id}">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus user ini?')"><i class="fas fa-trash"></i> Hapus</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <!-- Modal Edit -->
                                    <div class="modal fade" id="editModal${user.id}">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h4 class="modal-title">Edit User</h4>
                                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/manageUsers" method="post" onsubmit="return validateEditForm(${user.id})">
                                                    <input type="hidden" name="action" value="edit">
                                                    <input type="hidden" name="id" value="${user.id}">
                                                    <div class="modal-body">
                                                        <div class="form-group">
                                                            <label for="username${user.id}">Username</label>
                                                            <input type="text" name="username" id="username${user.id}" class="form-control" value="${user.username}" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="email${user.id}">Email</label>
                                                            <input type="email" name="email" id="email${user.id}" class="form-control" value="${user.email}" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="password${user.id}">Password (kosongkan jika tidak ingin mengubah)</label>
                                                            <input type="password" name="password" id="password${user.id}" class="form-control">
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="role${user.id}">Role</label>
                                                            <select name="role" id="role${user.id}" class="form-control" required>
                                                                <option value="user" ${user.role == 'user' ? 'selected' : ''}>User</option>
                                                                <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times"></i> Batal</button>
                                                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Perubahan</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty users}">
                                    <tr>
                                        <td colspan="5" class="text-center">Tidak ada data user.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
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
<script>
    function validateAddForm() {
        var username = document.getElementById('username').value;
        var email = document.getElementById('email').value;
        var password = document.getElementById('password').value;
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!username.trim()) {
            alert('Username harus diisi!');
            return false;
        }
        if (!emailPattern.test(email)) {
            alert('Format email tidak valid!');
            return false;
        }
        if (!password.trim()) {
            alert('Password harus diisi!');
            return false;
        }
        return confirm('Apakah Anda yakin ingin menambahkan user ini?');
    }

    function validateEditForm(id) {
        var username = document.getElementById('username' + id).value;
        var email = document.getElementById('email' + id).value;
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!username.trim()) {
            alert('Username harus diisi!');
            return false;
        }
        if (!emailPattern.test(email)) {
            alert('Format email tidak valid!');
            return false;
        }
        return confirm('Apakah Anda yakin ingin menyimpan perubahan?');
    }
</script>
</body>
</html>