<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Terapi - Sistem Booking Jasa Terapi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700">
    <style>
        .card { border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-header { background-color: #e0f7fa; color: #0288d1; }
        .btn { border-radius: 8px; }
        .table-responsive { overflow-x: auto; }
        th, td { min-width: 100px; } 
        .price-column { min-width: 120px; } 
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
                        <h1 class="m-0">Kelola Terapi</h1>
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
                        <h3 class="card-title">Cari dan Filter Terapi</h3>
                        <div class="card-tools">
                            <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addModal"><i class="fas fa-plus"></i> Tambah Terapi</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/manageTherapies" method="get" id="filterForm">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="search">Cari (Nama/Deskripsi)</label>
                                        <input type="text" name="search" id="search" class="form-control" 
                                               value="${search}" placeholder="Masukkan kata kunci">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="priceFilter">Rentang Harga</label>
                                        <select name="priceFilter" id="priceFilter" class="form-control">
                                            <option value="all" ${priceFilter == 'all' ? 'selected' : ''}>Semua</option>
                                            <option value="low" ${priceFilter == 'low' ? 'selected' : ''}>Murah (≤ Rp100.000)</option>
                                            <option value="medium" ${priceFilter == 'medium' ? 'selected' : ''}>Sedang (Rp100.000 - Rp300.000)</option>
                                            <option value="high" ${priceFilter == 'high' ? 'selected' : ''}>Mahal (> Rp300.000)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="sortBy">Urutkan Berdasarkan</label>
                                        <select name="sortBy" id="sortBy" class="form-control">
                                            <option value="id" ${sortBy == 'id' ? 'selected' : ''}>ID</option>
                                            <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Nama</option>
                                            <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Harga</option>
                                            <option value="duration" ${sortBy == 'duration' ? 'selected' : ''}>Durasi</option>
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
                            <a href="${pageContext.request.contextPath}/manageTherapies" class="btn btn-secondary"><i class="fas fa-undo"></i> Reset Filter</a>
                        </form>
                    </div>
                </div>

                <!-- Modal Tambah Terapi -->
                <div class="modal fade" id="addModal">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Tambah Terapi Baru</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <form action="${pageContext.request.contextPath}/manageTherapies" method="post" onsubmit="return validateAddForm()">
                                <input type="hidden" name="action" value="add">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label for="name">Nama Terapi</label>
                                        <input type="text" name="name" id="name" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="description">Deskripsi</label>
                                        <textarea name="description" id="description" class="form-control"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label for="price">Harga (Rp)</label>
                                        <input type="number" name="price" id="price" class="form-control" required min="1">
                                    </div>
                                    <div class="form-group">
                                        <label for="duration">Durasi (menit)</label>
                                        <input type="number" name="duration" id="duration" class="form-control" required min="1">
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

                <!-- Tabel Terapi -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Daftar Terapi</h3>
                    </div>
                    <div class="card-body table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nama</th>
                                    <th>Deskripsi</th>
                                    <th class="price-column">Harga</th>
                                    <th>Durasi</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="therapy" items="${therapies}">
                                    <tr>
                                        <td>${therapy.id}</td>
                                        <td>${therapy.name}</td>
                                        <td>${therapy.description}</td>
                                        <td class="price-column">
                                            <c:choose>
                                                <c:when test="${not empty therapy.price and therapy.price > 0}">
                                                    Rp <fmt:formatNumber value="${therapy.price}" type="number" groupingUsed="true" minFractionDigits="0" maxFractionDigits="0" />
                                                </c:when>
                                                <c:otherwise>
                                                    Tidak Valid
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${therapy.duration} menit</td>
                                        <td>
                                            <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#editModal${therapy.id}"><i class="fas fa-edit"></i> Edit</button>
                                            <form action="${pageContext.request.contextPath}/manageTherapies" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${therapy.id}">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Apakah Anda yakin ingin menghapus terapi ini?')"><i class="fas fa-trash"></i> Hapus</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <!-- Modal Edit -->
                                    <div class="modal fade" id="editModal${therapy.id}">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h4 class="modal-title">Edit Terapi</h4>
                                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/manageTherapies" method="post" onsubmit="return validateEditForm(${therapy.id})">
                                                    <input type="hidden" name="action" value="edit">
                                                    <input type="hidden" name="id" value="${therapy.id}">
                                                    <div class="modal-body">
                                                        <div class="form-group">
                                                            <label for="name${therapy.id}">Nama Terapi</label>
                                                            <input type="text" name="name" id="name${therapy.id}" class="form-control" value="${therapy.name}" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="description${therapy.id}">Deskripsi</label>
                                                            <textarea name="description" id="description${therapy.id}" class="form-control">${therapy.description}</textarea>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="price${therapy.id}">Harga (Rp)</label>
                                                            <input type="number" name="price" id="price${therapy.id}" class="form-control" value="${therapy.price}" required min="1">
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="duration${therapy.id}">Durasi (menit)</label>
                                                            <input type="number" name="duration" id="duration${therapy.id}" class="form-control" value="${therapy.duration}" required min="1">
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
                                <c:if test="${empty therapies}">
                                    <tr>
                                        <td colspan="6" class="text-center">Tidak ada data terapi.</td>
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
        var name = document.getElementById('name').value;
        var price = document.getElementById('price').value;
        var duration = document.getElementById('duration').value;
        if (!name.trim()) {
            alert('Nama terapi harus diisi!');
            return false;
        }
        if (price <= 0) {
            alert('Harga harus positif!');
            return false;
        }
        if (duration <= 0) {
            alert('Durasi harus positif!');
            return false;
        }
        return confirm('Apakah Anda yakin ingin menambahkan terapi ini?');
    }

    function validateEditForm(id) {
        var name = document.getElementById('name' + id).value;
        var price = document.getElementById('price' + id).value;
        var duration = document.getElementById('duration' + id).value;
        if (!name.trim()) {
            alert('Nama terapi harus diisi!');
            return false;
        }
        if (price <= 0) {
            alert('Harga harus positif!');
            return false;
        }
        if (duration <= 0) {
            alert('Durasi harus positif!');
            return false;
        }
        return confirm('Apakah Anda yakin ingin menyimpan perubahan?');
    }
</script>
</body>
</html>