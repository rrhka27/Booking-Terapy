<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Booking Jasa Terapi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2D5A3D;
            --secondary-color: #4A7C59;
            --accent-color: #7FB069;
            --light-green: #E8F5E8;
            --soft-green: #F0F8F0;
            --warm-white: #FEFFFE;
            --text-dark: #2C2C2C;
            --text-gray: #666;
            --shadow-light: 0 4px 20px rgba(45, 90, 61, 0.1);
            --shadow-medium: 0 8px 30px rgba(45, 90, 61, 0.15);
            --shadow-heavy: 0 15px 40px rgba(45, 90, 61, 0.2);
            --gradient-primary: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            --gradient-light: linear-gradient(135deg, var(--light-green) 0%, var(--soft-green) 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            line-height: 1.7;
            color: var(--text-dark);
            overflow-x: hidden;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Loading Screen */
        .loading-screen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            transition: opacity 0.5s ease;
        }

        .loading-content {
            text-align: center;
            color: white;
        }

        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Navigation */
        .navbar {
            background: rgba(45, 90, 61, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            transition: all 0.3s ease;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }

        .navbar.scrolled {
            padding: 10px 0;
            box-shadow: var(--shadow-medium);
        }

        .navbar-brand {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.8rem;
            color: white !important;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            margin: 0 10px;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -5px;
            left: 50%;
            background: var(--accent-color);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::after,
        .nav-link.active::after {
            width: 80%;
        }

        .nav-link:hover {
            color: white !important;
        }

        /* Hero Section */
        .hero-section {
            height: 100vh;
            background: linear-gradient(135deg, rgba(45, 90, 61, 0.8) 0%, rgba(74, 124, 89, 0.7) 100%), 
                        url('https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            position: relative;
        }

        .hero-content {
            max-width: 800px;
            padding: 0 20px;
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-section p {
            font-size: 1.3rem;
            margin-bottom: 30px;
            opacity: 0.95;
        }

        .btn-hero {
            background: var(--accent-color);
            border: none;
            padding: 15px 40px;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 50px;
            color: white;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(127, 176, 105, 0.3);
        }

        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(127, 176, 105, 0.4);
            color: white;
        }

        /* Floating elements */
        .floating-shapes {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            pointer-events: none;
        }

        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            width: 60px;
            height: 60px;
            top: 60%;
            right: 15%;
            animation-delay: -2s;
        }

        .shape:nth-child(3) {
            width: 100px;
            height: 100px;
            bottom: 20%;
            left: 20%;
            animation-delay: -4s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        /* Stats Section */
        .stats-section {
            background: var(--gradient-light);
            padding: 80px 0;
            margin-top: -50px;
            position: relative;
            z-index: 2;
        }

        .stat-card {
            text-align: center;
            padding: 30px;
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow-light);
            transition: all 0.3s ease;
            border: 1px solid rgba(127, 176, 105, 0.2);
        }

        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-medium);
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        .stat-label {
            font-size: 1.1rem;
            color: var(--text-gray);
            font-weight: 500;
        }

        /* Services Section */
        .services-section {
            padding: 100px 0;
            background: var(--warm-white);
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 2.8rem;
            margin-bottom: 20px;
            position: relative;
        }

        .section-title h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--accent-color);
            border-radius: 2px;
        }

        .section-subtitle {
            font-size: 1.2rem;
            color: var(--text-gray);
            max-width: 600px;
            margin: 0 auto;
        }

        .service-card {
            background: white;
            border: none;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow-light);
            transition: all 0.4s ease;
            height: 100%;
        }

        .service-card:hover {
            transform: translateY(-15px);
            box-shadow: var(--shadow-heavy);
        }

        .service-card img {
            height: 250px;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .service-card:hover img {
            transform: scale(1.1);
        }

        .service-card .card-body {
            padding: 30px;
        }

        .service-card .card-title {
            font-size: 1.4rem;
            margin-bottom: 15px;
            color: var(--primary-color);
        }

        .service-card .card-text {
            color: var(--text-gray);
            line-height: 1.6;
        }

        .service-icon {
            width: 60px;
            height: 60px;
            background: var(--gradient-primary);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            color: white;
            font-size: 1.5rem;
        }

        /* Gallery Section */
        .gallery-section {
            padding: 100px 0;
            background: var(--soft-green);
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 50px;
        }

        .gallery-item {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow-light);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .gallery-item:hover {
            transform: scale(1.05);
            box-shadow: var(--shadow-medium);
        }

        .gallery-item img {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .gallery-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(45, 90, 61, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .gallery-item:hover .gallery-overlay {
            opacity: 1;
        }

        .gallery-overlay i {
            color: white;
            font-size: 2rem;
        }

        /* FAQ Section */
        .faq-section {
            padding: 100px 0;
            background: var(--light-green);
        }

        .faq-item {
            background: white;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-light);
            overflow: hidden;
        }

        .faq-question {
            padding: 25px 30px;
            cursor: pointer;
            font-weight: 600;
            color: var(--primary-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .faq-question:hover {
            background: var(--soft-green);
        }

        .faq-answer {
            padding: 0 30px;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s ease;
            color: var(--text-gray);
        }

        .faq-answer.active {
            padding: 0 30px 25px 30px;
            max-height: 200px;
        }

        .faq-icon {
            transition: transform 0.3s ease;
        }

        .faq-item.active .faq-icon {
            transform: rotate(45deg);
        }

        /* Contact Section */
        .contact-section {
            padding: 100px 0;
            background: var(--warm-white);
        }

        .contact-info {
            padding: 50px 30px;
            background: white;
            border-radius: 20px;
            box-shadow: var(--shadow-medium);
        }

        .contact-item {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }

        .contact-item:hover {
            transform: translateX(10px);
        }

        .contact-icon {
            width: 50px;
            height: 50px;
            background: var(--gradient-primary);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 20px;
            transition: all 0.3s ease;
        }

        .contact-item:hover .contact-icon {
            background: var(--accent-color);
            transform: scale(1.1);
        }

        .btn-primary-custom {
            background: var(--gradient-primary);
            border: none;
            padding: 15px 40px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .map-container {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow-medium);
            margin-top: 30px;
            transition: all 0.3s ease;
        }

        .map-container:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-heavy);
        }

        .map-container iframe {
            width: 100%;
            height: 300px;
            border: none;
        }

        .map-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(45, 90, 61, 0.1);
            pointer-events: none;
            transition: opacity 0.3s ease;
        }

        .map-container:hover .map-overlay {
            opacity: 0;
        }

        /* Footer */
        footer {
            background: var(--primary-color);
            color: white;
            padding: 60px 0 30px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h5 {
            color: white;
            margin-bottom: 20px;
        }

        .footer-section a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--accent-color);
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            background: var(--secondary-color);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: var(--accent-color);
            transform: translateY(-3px);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 2.5rem;
            }
            
            .hero-section p {
                font-size: 1.1rem;
            }
            
            .section-title h2 {
                font-size: 2.2rem;
            }
            
            .stat-number {
                font-size: 2.5rem;
            }
            
            .gallery-grid {
                grid-template-columns: 1fr;
            }

            .map-container iframe {
                height: 250px;
            }
        }

        @media (max-width: 576px) {
            .hero-section h1 {
                font-size: 2rem;
            }
            
            .btn-hero {
                padding: 12px 30px;
                font-size: 1.1rem;
            }
            
            .service-card .card-body {
                padding: 20px;
            }

            .map-container iframe {
                height: 200px;
            }
        }

        /* Scroll to top button */
        .scroll-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: var(--gradient-primary);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .scroll-top.visible {
            opacity: 1;
            visibility: visible;
        }

        .scroll-top:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-medium);
        }
    </style>
</head>
<body>
    <!-- Loading Screen -->
    <div class="loading-screen" id="loadingScreen">
        <div class="loading-content">
            <div class="loading-spinner"></div>
            <h3>Jasa Terapi MI</h3>
            <p>Memuat pengalaman terbaik untuk Anda...</p>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg" id="navbar">
        <div class="container">
            <a class="navbar-brand" href="#home">
                <i class="fas fa-spa me-2"></i>Jasa Terapi MI
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#services">Layanan</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#gallery">Galeri</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#faq">FAQ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Kontak</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Login</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div class="floating-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>
        <div class="hero-content" data-aos="fade-up" data-aos-duration="1000">
            <h1>Selamat Datang di Jasa Terapi MI</h1>
            <p>Pusat layanan kesehatan tradisional terpercaya untuk keseimbangan tubuh dan jiwa Anda dengan teknologi modern dan terapis berpengalaman.</p>
            <a href="login.jsp" class="btn-hero">
                <i class="fas fa-calendar-check me-2"></i>Book Sekarang
            </a>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-number" data-count="5">0</div>
                        <div class="stat-label">Jenis Terapi</div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-card">
                        <div class="stat-number" data-count="10">0</div>
                        <div class="stat-label">Tahun Pengalaman</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="services-section">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Layanan Terapi Kami</h2>
                <p class="section-subtitle">Kami menyediakan berbagai jenis terapi tradisional yang telah terbukti efektif untuk kesehatan dan kesejahteraan Anda</p>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-card card">
                        <img src="asset/bekam.jpg" class="card-img-top" alt="Terapi Bekam">
                        <div class="card-body">
                            <div class="service-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <h5 class="card-title">Terapi Bekam</h5>
                            <p class="card-text">Teknik pengobatan tradisional dengan menempatkan cawan khusus pada permukaan kulit untuk meningkatkan sirkulasi darah dan mengeluarkan racun dari tubuh.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-card card">
                        <img src="asset/leuhang.png" class="card-img-top" alt="Terapi Leuhang">
                        <div class="card-body">
                            <div class="service-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <h5 class="card-title">Terapi Leuhang</h5>
                            <p class="card-text">Metode pijat tradisional Sunda yang fokus pada titik-titik energi untuk mengembalikan keseimbangan tubuh dan mengatasi ketegangan otot.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="service-card card">
                        <img src="asset/akupuntur.jpg" class="card-img-top" alt="Akupuntur">
                        <div class="card-body">
                            <div class="service-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <h5 class="card-title">Akupuntur</h5>
                            <p class="card-text">Pengobatan dengan menusukkan jarum halus steril pada titik-titik tertentu untuk merangsang penyembuhan alami tubuh dan mengatasi berbagai keluhan.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="400">
                    <div class="service-card card">
                        <img src="https://images.unsplash.com/photo-1515377905703-c4788e51af15?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" class="card-img-top" alt="Refleksi">
                        <div class="card-body">
                            <div class="service-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <h5 class="card-title">Terapi Refleksi</h5>
                            <p class="card-text">Teknik pijat pada titik refleks kaki yang berkaitan dengan organ-organ tubuh untuk meningkatkan fungsi organ dan melancarkan peredaran darah.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="500">
                    <div class="service-card card">
                        <img src="asset/relaksasi.jpg" class="card-img-top" alt="Relaksasi">
                        <div class="card-body">
                            <div class="service-icon">
                                <i class="fas fa-spa"></i>
                            </div>
                            <h5 class="card-title">Terapi Relaksasi</h5>
                            <p class="card-text">Perawatan khusus untuk mengurangi stres dan ketegangan melalui teknik pijat relaksasi, aromaterapi, dan meditasi untuk ketenangan pikiran.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Gallery Section -->
    <section id="gallery" class="gallery-section">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Galeri Fasilitas</h2>
                <p class="section-subtitle">Lihat fasilitas modern dan nyaman yang kami sediakan untuk kenyamanan terapi Anda</p>
            </div>
            <div class="gallery-grid">
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="100">
                    <img src="https://images.unsplash.com/photo-1648775507324-b48dd3791fa5?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Ruang Terapi 1">
                    <div class="gallery-overlay">
                        <i class="fas fa-expand"></i>
                    </div>
                </div>
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="200">
                    <img src="asset/alat-bekam.jpg" alt="Alat bekam">
                    <div class="gallery-overlay">
                        <i class="fas fa-expand"></i>
                    </div>
                </div>
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="300">
                    <img src="https://tse4.mm.bing.net/th/id/OIP.mDW15xq_loFvLDcxROVT7wAAAA?pid=Api&P=0&h=180" alt="Ruang Tunggu">
                    <div class="gallery-overlay">
                        <i class="fas fa-expand"></i>
                    </div>
                </div>
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="400">
                    <img src="http://www.bethesda.kyriakon.or.id/assets/img/gallery/ruang_fisioterapi.png" alt="Peralatan Terapi">
                    <div class="gallery-overlay">
                        <i class="fas fa-expand"></i>
                    </div>
                </div>
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="500">
                    <img src="https://images.unsplash.com/photo-1600334129128-685c5582fd35?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" alt="Ruang Konsultasi">
                    <div class="gallery-overlay">
                        <i class="fas fa-expand"></i>
                    </div>
                </div>
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="600">
                    <img src="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" alt="Area Relaksasi">
                    <div class="gallery-overlay">
                        <i class="fas fa-expand"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section id="faq" class="faq-section">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Pertanyaan Yang Sering Ditanyakan</h2>
                <p class="section-subtitle">Temukan jawaban atas pertanyaan umum tentang layanan terapi kami</p>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="faq-item" data-aos="fade-up" data-aos-delay="100">
                        <div class="faq-question">
                            <span>Apakah terapi yang Anda tawarkan aman?</span>
                            <i class="fas fa-plus faq-icon"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Ya, semua terapi yang kami tawarkan sangat aman. Kami menggunakan peralatan steril dan terapist bersertifikat dengan pengalaman lebih dari 10 tahun. Semua prosedur mengikuti standar kesehatan yang ketat.</p>
                        </div>
                    </div>
                    <div class="faq-item" data-aos="fade-up" data-aos-delay="200">
                        <div class="faq-question">
                            <span>Berapa lama durasi setiap sesi terapi?</span>
                            <i class="fas fa-plus faq-icon"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Durasi bervariasi tergantung jenis terapi: Bekam (45-60 menit), Akupuntur (30-45 menit), Refleksi (60 menit), Leuhang (45 menit), dan Relaksasi (60-90 menit).</p>
                        </div>
                    </div>
                    <div class="faq-item" data-aos="fade-up" data-aos-delay="300">
                        <div class="faq-question">
                            <span>Apakah ada efek samping dari terapi?</span>
                            <i class="fas fa-plus faq-icon"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Efek samping minimal dan bersifat sementara seperti sedikit merah atau bengkak di area terapi. Ini normal dan akan hilang dalam 1-2 hari. Terapis akan menjelaskan semua kemungkinan efek sebelum terapi.</p>
                        </div>
                    </div>
                    <div class="faq-item" data-aos="fade-up" data-aos-delay="400">
                        <div class="faq-question">
                            <span>Berapa kali saya perlu melakukan terapi?</span>
                            <i class="fas fa-plus faq-icon"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Jumlah sesi tergantung kondisi dan jenis keluhan. Untuk maintenance, umumnya 1-2 kali per bulan. Untuk kondisi khusus, terapis akan memberikan rekomendasi program terapi yang sesuai.</p>
                        </div>
                    </div>
                    <div class="faq-item" data-aos="fade-up" data-aos-delay="500">
                        <div class="faq-question">
                            <span>Bagaimana cara booking appointment?</span>
                            <i class="fas fa-plus faq-icon"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Anda bisa booking melalui website dengan klik tombol "Book Sekarang", WhatsApp di +62 812-3456-7890, atau telepon langsung ke (021) 123-4567. Kami juga menerima walk-in appointment.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="contact-section">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Hubungi Kami</h2>
                <p class="section-subtitle">Siap membantu Anda dengan informasi lebih lanjut tentang layanan terapi kami</p>
            </div>
            <div class="row">
                <div class="col-lg-6 mb-5" data-aos="fade-right" data-aos-delay="100">
                    <div class="contact-info">
                        <h4 class="mb-4">Informasi Kontak</h4>
                        <div class="contact-item" data-aos="fade-right" data-aos-delay="200">
                            <div class="contact-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div>
                                <h6>Alamat</h6>
                                <p>Jl. Jend. Sudirman No. 5, Bandung<br>Jawa Barat 40111</p>
                            </div>
                        </div>
                        <div class="contact-item" data-aos="fade-right" data-aos-delay="300">
                            <div class="contact-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div>
                                <h6>Telepon</h6>
                                <p>(021) 123-4567<br>+62 812-3456-7890</p>
                            </div>
                        </div>
                        <div class="contact-item" data-aos="fade-right" data-aos-delay="400">
                            <div class="contact-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div>
                                <h6>Email</h6>
                                <p>info@jasaterapimi.com<br>booking@jasaterapimi.com</p>
                            </div>
                        </div>
                        <div class="contact-item" data-aos="fade-right" data-aos-delay="500">
                            <div class="contact-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div>
                                <h6>Jam Operasional</h6>
                                <p>Senin - Sabtu: 08:00 - 20:00<br>Minggu: 09:00 - 17:00</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6" data-aos="fade-left" data-aos-delay="100">
                    <div class="map-container">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3966.365427093111!2d107.5912479!3d-6.9467364!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e68e8bee3bd350f%3A0x198c9de6ba46e374!2sSTMIK%20Mardira%20Indonesia!5e0!3m2!1sid!2sid!4v1698765432100!5m2!1sid!2sid" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                        <div class="map-overlay"></div>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="https://www.google.com/maps/place/STMIK+Mardira+Indonesia/@-6.9467311,107.5912479,17z/data=!3m1!4b1!4m6!3m5!1s0x2e68e8bee3bd350f:0x198c9de6ba46e374!8m2!3d-6.9467364!4d107.5938228!16s%2Fg%2F1tcynz6d?entry=tts&g_ep=EgoyMDI1MDcyNy4wIPu8ASoASAFQAw%3D%3D&skid=c04dfbc6-50f2-457c-9468-9891dbd11f20" target="_blank" class="btn btn-primary-custom">
                            <i class="fas fa-map-marked-alt me-2"></i>Buka di Google Maps
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h5><i class="fas fa-leaf me-2"></i>Jasa Terapi MI</h5>
                    <p>Pusat layanan kesehatan tradisional terpercaya untuk keseimbangan tubuh dan jiwa Anda.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-whatsapp"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="footer-section">
                    <h5>Layanan</h5>
                    <ul class="list-unstyled">
                        <li><a href="#services">Terapi Bekam</a></li>
                        <li><a href="#services">Terapi Leuhang</a></li>
                        <li><a href="#services">Akupuntur</a></li>
                        <li><a href="#services">Terapi Refleksi</a></li>
                        <li><a href="#services">Terapi Relaksasi</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h5>Informasi</h5>
                    <ul class="list-unstyled">
                        <li><a href="#home">Tentang Kami</a></li>
                        <li><a href="#faq">FAQ</a></li>
                        <li><a href="#contact">Kontak</a></li>
                        <li><a href="login.jsp">Login</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h5>Kontak Info</h5>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-map-marker-alt me-2"></i>Bandung, Jawa Barat</li>
                        <li><i class="fas fa-phone me-2"></i>(021) 123-4567</li>
                        <li><i class="fas fa-envelope me-2"></i>info@jasaterapimi.com</li>
                        <li><i class="fas fa-clock me-2"></i>08:00 - 20:00</li>
                    </ul>
                </div>
            </div>
            <hr style="border-color: rgba(255,255,255,0.2);">
            <div class="text-center">
                <p>&copy; 2025 Jasa Terapi MI. Semua hak dilindungi. | Dibuat dengan ❤️ untuk kesehatan Anda</p>
            </div>
        </div>
    </footer>

    <!-- Scroll to Top Button -->
    <button class="scroll-top" id="scrollTop">
        <i class="fas fa-arrow-up"></i>
    </button>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // Initialize AOS
        AOS.init({
            duration: 1000,
            once: true,
            offset: 100
        });

        // Loading Screen
        window.addEventListener('load', function() {
            const loadingScreen = document.getElementById('loadingScreen');
            setTimeout(() => {
                loadingScreen.style.opacity = '0';
                setTimeout(() => {
                    loadingScreen.style.display = 'none';
                }, 500);
            }, 1500);
        });

        // Navbar Scroll Effect
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            const scrollTop = document.getElementById('scrollTop');
            
            if (window.scrollY > 100) {
                navbar.classList.add('scrolled');
                scrollTop.classList.add('visible');
            } else {
                navbar.classList.remove('scrolled');
                scrollTop.classList.remove('visible');
            }
        });

        // Smooth Scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Scroll to Top
        document.getElementById('scrollTop').addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        // Counter Animation
        function animateCounters() {
            const counters = document.querySelectorAll('[data-count]');
            const speed = 200;

            counters.forEach(counter => {
                const target = +counter.getAttribute('data-count');
                const count = +counter.innerText;
                const inc = target / speed;

                if (count < target) {
                    counter.innerText = Math.ceil(count + inc);
                    setTimeout(() => animateCounters(), 1);
                } else {
                    counter.innerText = target;
                }
            });
        }

        // Trigger counter animation when in view
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounters();
                    observer.unobserve(entry.target);
                }
            });
        });

        document.querySelector('.stats-section').addEventListener('DOMContentLoaded', () => {
            observer.observe(document.querySelector('.stats-section'));
        });

        // FAQ Toggle
        document.querySelectorAll('.faq-question').forEach(question => {
            question.addEventListener('click', function() {
                const faqItem = this.parentElement;
                const answer = faqItem.querySelector('.faq-answer');
                const icon = this.querySelector('.faq-icon');

                // Close all other FAQ items
                document.querySelectorAll('.faq-item').forEach(item => {
                    if (item !== faqItem) {
                        item.classList.remove('active');
                        item.querySelector('.faq-answer').classList.remove('active');
                    }
                });

                // Toggle current FAQ item
                faqItem.classList.toggle('active');
                answer.classList.toggle('active');
            });
        });

        // Gallery Lightbox Effect
        document.querySelectorAll('.gallery-item').forEach(item => {
            item.addEventListener('click', function() {
                const img = this.querySelector('img');
                const modal = document.createElement('div');
                modal.innerHTML = `
                    <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); display: flex; align-items: center; justify-content: center; z-index: 10000; cursor: pointer;">
                        <img src="${img.src}" style="max-width: 90%; max-height: 90%; object-fit: contain;">
                        <button style="position: absolute; top: 20px; right: 20px; background: white; border: none; border-radius: 50%; width: 40px; height: 40px; cursor: pointer; font-size: 20px;">&times;</button>
                    </div>
                `;
                document.body.appendChild(modal);
                
                modal.addEventListener('click', function() {
                    document.body.removeChild(modal);
                });
            });
        });

        // Navbar Active Link
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('section[id]');
            const navLinks = document.querySelectorAll('.nav-link[href^="#"]');
            
            let current = '';
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                if (scrollY >= (sectionTop - 200)) {
                    current = section.getAttribute('id');
                }
            });
            
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === `#${current}`) {
                    link.classList.add('active');
                }
            });
        });

        // Trigger counter animation on scroll
        setTimeout(() => {
            observer.observe(document.querySelector('.stats-section'));
        }, 2000);
    </script>
</body>
</html>