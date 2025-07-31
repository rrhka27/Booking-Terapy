<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buat Booking - Sistem Booking Jasa Terapi</title>
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
                        <h1 class="m-0">Buat Booking</h1>
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

                <!-- Form Buat Booking -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Form Booking Terapi</h3>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/createBooking" method="post" onsubmit="return confirm('Apakah Anda yakin ingin membuat booking ini?');">
                            <div class="form-group">
                                <label for="therapy_id">Pilih Terapi</label>
                                <select name="therapy_id" id="therapy_id" class="form-control" required onchange="updateTherapyDetails()">
                                    <option value="">-- Pilih Terapi --</option>
                                    <c:forEach var="therapy" items="${therapies}">
                                        <option value="${therapy.id}" 
                                                data-description="${therapy.description}" 
                                                data-price="${therapy.price}" 
                                                data-duration="${therapy.duration}">
                                            ${therapy.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div id="therapyDetails" class="card card-info">
                                <div class="card-header">
                                    <h3 class="card-title">Detail Terapi</h3>
                                </div>
                                <div class="card-body">
                                    <p><strong>Deskripsi:</strong> <span id="description"></span></p>
                                    <p><strong>Harga:</strong> Rp <span id="price"></span></p>
                                    <p><strong>Durasi:</strong> <span id="duration"></span> menit</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="booking_date">Tanggal Booking</label>
                                <input type="date" name="booking_date" id="booking_date" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="booking_time">Waktu Booking</label>
                                <select name="booking_time" id="booking_time" class="form-control" required>
                                    <option value="">-- Pilih Waktu --</option>
                                    <option value="09:00">09:00</option>
                                    <option value="10:00">10:00</option>
                                    <option value="11:00">11:00</option>
                                    <option value="13:00">13:00</option>
                                    <option value="14:00">14:00</option>
                                    <option value="15:00">15:00</option>
                                    <option value="16:00">16:00</option>
                                    <option value="17:00">17:00</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Buat Booking</button>
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
<script>
    function updateTherapyDetails() {
        var select = document.getElementById('therapy_id');
        var option = select.options[select.selectedIndex];
        var details = document.getElementById('therapyDetails');
        var description = document.getElementById('description');
        var price = document.getElementById('price');
        var duration = document.getElementById('duration');

        if (option.value) {
            description.textContent = option.getAttribute('data-description');
            price.textContent = parseFloat(option.getAttribute('data-price')).toLocaleString('id-ID');
            duration.textContent = option.getAttribute('data-duration');
            details.style.display = 'block';
        } else {
            details.style.display = 'none';
        }
    }

    // Set menu aktif
    $(document).ready(function() {
        $('.nav-link').removeClass('active');
        $('[href="${pageContext.request.contextPath}/createBooking"]').addClass('active');
    });
</script>
</body>
</html>