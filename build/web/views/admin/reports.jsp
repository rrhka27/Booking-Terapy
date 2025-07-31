<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Laporan - Sistem Booking Jasa Terapi</title>
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
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <%@ include file="../template/navbar.jsp" %>

    <!-- Sidebar -->
    <%@ include file="../template/sidebar.jsp" %>
    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <h1>Laporan Booking</h1>
            </div>
        </section>
        <section class="content">
            <div class="container-fluid">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Filter Laporan</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/reports" method="get">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tanggal Mulai</label>
                                        <input type="date" name="startDate" class="form-control" value="${startDate}">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Tanggal Selesai</label>
                                        <input type="date" name="endDate" class="form-control" value="${endDate}">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Status</label>
                                        <select name="status" class="form-control">
                                            <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Semua</option>
                                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
                                            <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Dikonfirmasi</option>
                                            <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Dibatalkan</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>&nbsp;</label>
                                        <button type="submit" class="btn btn-primary btn-block">Filter</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <form action="${pageContext.request.contextPath}/reports" method="get">
                            <input type="hidden" name="startDate" value="${startDate}">
                            <input type="hidden" name="endDate" value="${endDate}">
                            <input type="hidden" name="status" value="${statusFilter}">
                            <input type="hidden" name="export" value="pdf">
                            <button type="submit" class="btn btn-success">Ekspor PDF</button>
                        </form>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Statistik</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="info-box">
                                    <span class="info-box-icon bg-info"><i class="fas fa-list"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Total Booking</span>
                                        <span class="info-box-number">${totalBookings}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="info-box">
                                    <span class="info-box-icon bg-warning"><i class="fas fa-clock"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Pending</span>
                                        <span class="info-box-number">${pendingCount}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="info-box">
                                    <span class="info-box-icon bg-success"><i class="fas fa-check"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Dikonfirmasi</span>
                                        <span class="info-box-number">${confirmedCount}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="info-box">
                                    <span class="info-box-icon bg-danger"><i class="fas fa-times"></i></span>
                                    <div class="info-box-content">
                                        <span class="info-box-text">Dibatalkan</span>
                                        <span class="info-box-number">${cancelledCount}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Data Booking</h3>
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Terapi</th>
                                    <th>Tanggal Booking</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>${booking.id}</td>
                                        <td>${booking.username}</td>
                                        <td>${booking.therapyName}</td>
                                        <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd-MM-yyyy HH:mm"/></td>
                                        <td>${booking.status}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="card-footer">
                        <nav>
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/reports?page=${currentPage - 1}&startDate=${startDate}&endDate=${endDate}&status=${statusFilter}">Sebelumnya</a>
                                    </li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/reports?page=${i}&startDate=${startDate}&endDate=${endDate}&status=${statusFilter}">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/reports?page=${currentPage + 1}&startDate=${startDate}&endDate=${endDate}&status=${statusFilter}">Berikutnya</a>
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
<script src="${pageContext.request.contextPath}/assets/plugins/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/dist/js/adminlte.min.js"></script>
</body>
</html>