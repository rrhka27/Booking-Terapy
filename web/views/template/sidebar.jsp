<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <a href="${pageContext.request.contextPath}/dashboard" class="brand-link">
        <i class="fas fa-spa brand-logo"></i>
        <span class="brand-text font-weight-light">Booking Terapi</span>
    </a>
    <div class="sidebar">
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link ${active == 'dashboard' ? 'active' : ''}">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>Dashboard</p>
                    </a>
                </li>
                <c:if test="${sessionScope.user.role == 'user'}">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/therapies" class="nav-link ${active == 'therapies' ? 'active' : ''}">
                            <i class="nav-icon fas fa-list"></i>
                            <p>Daftar Terapi</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/createBooking" class="nav-link ${active == 'create_booking' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-check"></i>
                            <p>Buat Booking</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/bookingHistory" class="nav-link ${active == 'booking_history' ? 'active' : ''}">
                            <i class="nav-icon fas fa-history"></i>
                            <p>Riwayat Booking</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/profile" class="nav-link ${active == 'profile' ? 'active' : ''}">
                            <i class="nav-icon fas fa-user"></i>
                            <p>Profil</p>
                        </a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/manageTherapies" class="nav-link ${active == 'manage_therapies' ? 'active' : ''}">
                            <i class="nav-icon fas fa-cogs"></i>
                            <p>Kelola Terapi</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/manageBookings" class="nav-link ${active == 'manage_bookings' ? 'active' : ''}">
                            <i class="nav-icon fas fa-calendar-alt"></i>
                            <p>Kelola Booking</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/manageUsers" class="nav-link ${active == 'manage_users' ? 'active' : ''}">
                            <i class="nav-icon fas fa-users"></i>
                            <p>Kelola User</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/reports" class="nav-link ${active == 'reports' ? 'active' : ''}">
                            <i class="nav-icon fas fa-chart-bar"></i>
                            <p>Laporan</p>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>
</aside>