<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Booking - Sistem Booking Jasa Terapi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700">
    <style>
        .card { border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-header { background-color: #e0f7fa; color: #0288d1; }
        .btn { border-radius: 8px; }
        .table { font-size: 14px; }
        .form-inline .form-control { width: 200px; }
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
                        <h1 class="m-0">Kelola Booking</h1>
                    </div>
                </div>
            </div>
        </div>
        <section class="content">
            <div class="container-fluid">
                <!-- Pesan Sukses/Error/Warning -->
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
                <c:if test="${not empty warning}">
                    <div class="alert alert-warning alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                        ${warning}
                    </div>
                </c:if>

                <!-- Form Pencarian dan Filter -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Filter dan Pencarian Booking</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/manageBookings" method="get" class="form-inline">
                            <div class="form-group mb-2 mr-2">
                                <input type="text" name="search" class="form-control" placeholder="Cari username, terapi, atau tanggal" value="${search}">
                            </div>
                            <div class="form-group mb-2 mr-2">
                                <select name="status" class="form-control">
                                    <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Semua Status</option>
                                    <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Dikonfirmasi</option>
                                    <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Dibatalkan</option>
                                </select>
                            </div>
                            <div class="form-group mb-2 mr-2">
                                <select name="sortBy" class="form-control">
                                    <option value="id" ${sortBy == 'id' ? 'selected' : ''}>ID</option>
                                    <option value="booking_date" ${sortBy == 'booking_date' ? 'selected' : ''}>Tanggal Booking</option>
                                    <option value="created_at" ${sortBy == 'created_at' ? 'selected' : ''}>Tanggal Dibuat</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary mb-2"><i class="fas fa-search"></i> Cari</button>
                        </form>
                    </div>
                </div>

                <!-- Tabel Booking -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Daftar Booking</h3>
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>User</th>
                                    <th>Terapi</th>
                                    <th>Tanggal Booking</th>
                                    <th>Status</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>${booking.id}</td>
                                        <td>${booking.username}</td>
                                        <td>${booking.therapyName}</td>
                                        <td><fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.status == 'pending'}">
                                                    <span class="badge badge-warning">${booking.status}</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'confirmed'}">
                                                    <span class="badge badge-success">${booking.status}</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'cancelled'}">
                                                    <span class="badge badge-danger">${booking.status}</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${booking.status != 'confirmed'}">
                                                <form action="${pageContext.request.contextPath}/manageBookings" method="post" class="d-inline" onsubmit="return confirm('Apakah Anda yakin ingin mengkonfirmasi booking ini?');">
                                                    <input type="hidden" name="booking_id" value="${booking.id}">
                                                    <input type="hidden" name="action" value="confirm">
                                                    <button type="submit" class="btn btn-success btn-sm"><i class="fas fa-check"></i> Konfirmasi</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${booking.status != 'cancelled'}">
                                                <form action="${pageContext.request.contextPath}/manageBookings" method="post" class="d-inline" onsubmit="return confirm('Apakah Anda yakin ingin membatalkan booking ini?');">
                                                    <input type="hidden" name="booking_id" value="${booking.id}">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-times"></i> Batalkan</button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <!-- Paginasi -->
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center mt-3">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/manageBookings?page=${currentPage - 1}&search=${search}&status=${statusFilter}&sortBy=${sortBy}">Previous</a>
                                    </li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/manageBookings?page=${i}&search=${search}&status=${statusFilter}&sortBy=${sortBy}">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/manageBookings?page=${currentPage + 1}&search=${search}&status=${statusFilter}&sortBy=${sortBy}">Next</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
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
    // Set menu aktif
    $(document).ready(function() {
        $('.nav-link').removeClass('active');
        $('[href="${pageContext.request.contextPath}/manageBookings"]').addClass('active');
    });
</script>
</body>
</html>