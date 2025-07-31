<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Booking - Sistem Booking Jasa Terapi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700">
    <style>
        .card { border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .card-header { background-color: #e0f7fa; color: #0288d1; }
        .btn { border-radius: 8px; }
        #therapyDetails { display: none; }
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
                        <h1 class="m-0">Riwayat Booking</h1>
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

                <!-- Tabel Riwayat Booking -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Daftar Booking</h3>
                    </div>
                    <div class="card-body">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Nama Terapi</th>
                                    <th>Tanggal Booking</th>
                                    <th>Status</th>
                                    <th>Dibuat Pada</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>${booking.id}</td>
                                        <td>${booking.username}</td>
                                        <td>${booking.therapyName}</td>
                                        <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd-MM-yyyy HH:mm"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${booking.status == 'pending'}">
                                                    <span class="badge badge-warning">Pending</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'confirmed'}">
                                                    <span class="badge badge-success">Confirmed</span>
                                                </c:when>
                                                <c:when test="${booking.status == 'cancelled'}">
                                                    <span class="badge badge-danger">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-secondary">${booking.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${booking.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                                        <td>
                                            <c:if test="${booking.status == 'pending'}">
                                                <a href="${pageContext.request.contextPath}/cancelBooking?booking_id=${booking.id}" 
                                                   class="btn btn-sm btn-danger" 
                                                   onclick="return confirm('Apakah Anda yakin ingin membatalkan booking ini?')">
                                                    <i class="fas fa-trash"></i> Batalkan
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
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
</body>
</html>