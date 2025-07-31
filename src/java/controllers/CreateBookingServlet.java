package controllers;

import models.DatabaseConnection;
import models.Therapy;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.EmailUtil;

@WebServlet("/createBooking")
public class CreateBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah user sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Ambil daftar terapi
            List<Therapy> therapies = new ArrayList<>();
            String sql = "SELECT id, name, description, price, duration FROM therapies";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Therapy therapy = new Therapy();
                therapy.setId(rs.getInt("id"));
                therapy.setName(rs.getString("name"));
                therapy.setDescription(rs.getString("description"));
                therapy.setPrice(rs.getDouble("price"));
                therapy.setDuration(rs.getInt("duration"));
                therapies.add(therapy);
            }
            request.setAttribute("therapies", therapies);
            request.setAttribute("active", "create_booking");
            request.getRequestDispatcher("views/user/create_booking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving therapies: " + e.getMessage());
            request.setAttribute("active", "create_booking");
            request.getRequestDispatcher("views/user/create_booking.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah user sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String therapyId = request.getParameter("therapy_id");
        String bookingDate = request.getParameter("booking_date");
        String bookingTime = request.getParameter("booking_time");

        // Validasi input
        if (therapyId == null || therapyId.trim().isEmpty() || bookingDate == null || bookingDate.trim().isEmpty() || bookingTime == null || bookingTime.trim().isEmpty()) {
            request.setAttribute("error", "Semua field harus diisi!");
            doGet(request, response); // Reload form dengan daftar terapi
            return;
        }

        // Validasi tanggal di masa depan
        LocalDateTime bookingDateTime;
        try {
            bookingDateTime = LocalDateTime.parse(bookingDate + "T" + bookingTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            if (bookingDateTime.isBefore(LocalDateTime.now())) {
                request.setAttribute("error", "Tanggal booking harus di masa depan!");
                doGet(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("error", "Format tanggal atau waktu tidak valid!");
            doGet(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Cek booking ganda
            String checkSql = "SELECT id FROM bookings WHERE user_id = ? AND booking_date = ? AND status != 'cancelled'";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, user.getId());
            checkStmt.setTimestamp(2, Timestamp.valueOf(bookingDateTime));
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("error", "Anda sudah memiliki booking pada tanggal dan waktu tersebut!");
                doGet(request, response);
                return;
            }

            // Simpan booking
            String sql = "INSERT INTO bookings (user_id, therapy_id, booking_date, status, created_at) VALUES (?, ?, ?, 'pending', NOW())";
            PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, user.getId());
            stmt.setInt(2, Integer.parseInt(therapyId));
            stmt.setTimestamp(3, Timestamp.valueOf(bookingDateTime));
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // Dapatkan ID booking yang baru dibuat
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                int bookingId = 0;
                if (generatedKeys.next()) {
                    bookingId = generatedKeys.getInt(1);
                }

                // Dapatkan nama terapi
                String therapyName = "";
                String therapySql = "SELECT name FROM therapies WHERE id = ?";
                PreparedStatement therapyStmt = conn.prepareStatement(therapySql);
                therapyStmt.setInt(1, Integer.parseInt(therapyId));
                ResultSet therapyRs = therapyStmt.executeQuery();
                if (therapyRs.next()) {
                    therapyName = therapyRs.getString("name");
                }

                // Dapatkan email user
                String userEmail = "";
                String userSql = "SELECT email FROM users WHERE id = ?";
                PreparedStatement userStmt = conn.prepareStatement(userSql);
                userStmt.setInt(1, user.getId());
                ResultSet userRs = userStmt.executeQuery();
                if (userRs.next()) {
                    userEmail = userRs.getString("email");
                }

                // Kirim email notifikasi
                if (!userEmail.isEmpty()) {
                    String subject = "Konfirmasi Booking Terapi - Sistem Booking Jasa Terapi";
                    String body = "Halo " + user.getUsername() + ",\n\n" +
                                  "Booking Anda telah berhasil dibuat dengan detail berikut:\n" +
                                  "ID Booking: " + bookingId + "\n" +
                                  "Terapi: " + therapyName + "\n" +
                                  "Tanggal Booking: " + bookingDate + " " + bookingTime + "\n" +
                                  "Status: Pending\n\n" +
                                  "Terima kasih telah menggunakan layanan kami!\n" +
                                  "Sistem Booking Jasa Terapi";
                    try {
                        EmailUtil.sendEmail(userEmail, subject, body);
                        request.setAttribute("success", "Booking berhasil dibuat dan notifikasi email telah dikirim!");
                    } catch (MessagingException e) {
                        e.printStackTrace();
                        request.setAttribute("warning", "Booking berhasil, tetapi gagal mengirim email notifikasi: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("warning", "Booking berhasil, tetapi email user tidak ditemukan.");
                }

                // Reload form dengan pesan sukses
                doGet(request, response);
            } else {
                request.setAttribute("error", "Gagal membuat booking!");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}