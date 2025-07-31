<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Sistem Booking Jasa Terapi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
    <!-- Navbar -->
    <%@ include file="views/template/navbar.jsp" %>

    <!-- Sidebar -->
    <%@ include file="views/template/sidebar.jsp" %>

  <!-- Content Wrapper -->
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Dashboard</h1>
                    </div>
                </div>
            </div>
        </div>
        <section class="content">
            <div class="container-fluid">
                <!-- Pesan Error -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                        ${error}
                    </div>
                </c:if>

                <!-- Welcome Message -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <h5>Selamat datang, ${sessionScope.user.username}!</h5>
                                <c:if test="${sessionScope.user.role == 'user'}">
                                    <p>Lihat statistik booking Anda di bawah ini atau gunakan menu sidebar untuk booking terapi.</p>
                                </c:if>
                                <c:if test="${sessionScope.user.role == 'admin'}">
                                    <p>Lihat statistik sistem di bawah ini atau gunakan menu sidebar untuk mengelola terapi, booking, atau user.</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistik -->
                <c:if test="${sessionScope.user.role == 'user'}">
                    <div class="row">
                        <div class="col-lg-4 col-6">
                            <div class="info-box">
                                <span class="info-box-icon bg-warning"><i class="fas fa-clock"></i></span>
                                <div class="info-box-content">
                                    <span class="info-box-text">Booking Pending</span>
                                    <span class="info-box-number">${bookingStats.pending}</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-6">
                            <div class="info-box">
                                <span class="info-box-icon bg-success"><i class="fas fa-check-circle"></i></span>
                                <div class="info-box-content">
                                    <span class="info-box-text">Booking Confirmed</span>
                                    <span class="info-box-number">${bookingStats.confirmed}</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-6">
                            <div class="info-box">
                                <span class="info-box-icon bg-danger"><i class="fas fa-times-circle"></i></span>
                                <div class="info-box-content">
                                    <span class="info-box-text">Booking Cancelled</span>
                                    <span class="info-box-number">${bookingStats.cancelled}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <div class="row">
                        <div class="col-lg-4 col-6">
                            <div class="info-box">
                                <span class="info-box-icon bg-info"><i class="fas fa-users"></i></span>
                                <div class="info-box-content">
                                    <span class="info-box-text">Total User</span>
                                    <span class="info-box-number">${adminStats.totalUsers}</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-6">
                            <div class="info-box">
                                <span class="info-box-icon bg-primary"><i class="fas fa-calendar-alt"></i></span>
                                <div class="info-box-content">
                                    <span class="info-box-text">Total Booking</span>
                                    <span class="info-box-number">${adminStats.totalBookings}</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-6">
                            <div class="info-box">
                                <span class="info-box-icon bg-secondary"><i class="fas fa-spa"></i></span>
                                <div class="info-box-content">
                                    <span class="info-box-text">Total Terapi</span>
                                    <span class="info-box-number">${adminStats.totalTherapies}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
    </div>

    <!-- Footer -->
    <%@ include file="views/template/footer.jsp" %>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>