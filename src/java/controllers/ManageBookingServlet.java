package controllers;

import models.Booking;
import models.DatabaseConnection;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/manageBookings")
public class ManageBookingServlet extends HttpServlet {
    private static final int PAGE_SIZE = 10; // Jumlah booking per halaman

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah admin sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil parameter pencarian, filter, sorting, dan halaman
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String pageStr = request.getParameter("page");
        if (search == null) search = "";
        if (statusFilter == null) statusFilter = "all";
        if (sortBy == null) sortBy = "id";
        int page = pageStr != null && !pageStr.isEmpty() ? Integer.parseInt(pageStr) : 1;
        int offset = (page - 1) * PAGE_SIZE;

        List<Booking> bookings = new ArrayList<>();
        int totalBookings = 0;
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Hitung total booking untuk paginasi
            String countSql = "SELECT COUNT(*) AS total FROM bookings b " +
                             "JOIN users u ON b.user_id = u.id JOIN therapies t ON b.therapy_id = t.id WHERE 1=1";
            List<String> countParams = new ArrayList<>();
            if (!search.trim().isEmpty()) {
                countSql += " AND (u.username LIKE ? OR t.name LIKE ? OR DATE(b.booking_date) LIKE ?)";
                String searchParam = "%" + search.trim() + "%";
                countParams.add(searchParam);
                countParams.add(searchParam);
                countParams.add(searchParam);
            }
            if (!statusFilter.equals("all")) {
                countSql += " AND b.status = ?";
                countParams.add(statusFilter);
            }
            PreparedStatement countStmt = conn.prepareStatement(countSql);
            for (int i = 0; i < countParams.size(); i++) {
                countStmt.setString(i + 1, countParams.get(i));
            }
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                totalBookings = countRs.getInt("total");
            }

            // Ambil data booking dengan limit dan offset
            StringBuilder sql = new StringBuilder(
                "SELECT b.id, b.user_id, b.therapy_id, b.booking_date, b.status, b.created_at, u.username, t.name as therapy_name " +
                "FROM bookings b JOIN users u ON b.user_id = u.id JOIN therapies t ON b.therapy_id = t.id WHERE 1=1"
            );
            List<String> params = new ArrayList<>();
            if (!search.trim().isEmpty()) {
                sql.append(" AND (u.username LIKE ? OR t.name LIKE ? OR DATE(b.booking_date) LIKE ?)");
                String searchParam = "%" + search.trim() + "%";
                params.add(searchParam);
                params.add(searchParam);
                params.add(searchParam);
            }
            if (!statusFilter.equals("all")) {
                sql.append(" AND b.status = ?");
                params.add(statusFilter);
            }
            if (sortBy.equals("booking_date")) {
                sql.append(" ORDER BY b.booking_date DESC");
            } else if (sortBy.equals("created_at")) {
                sql.append(" ORDER BY b.created_at DESC");
            } else {
                sql.append(" ORDER BY b.id DESC");
            }
            sql.append(" LIMIT ? OFFSET ?");

            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            // Set parameter string
            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }
            // Set LIMIT dan OFFSET sebagai integer
            stmt.setInt(params.size() + 1, PAGE_SIZE);
            stmt.setInt(params.size() + 2, offset);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setTherapyId(rs.getInt("therapy_id"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setUsername(rs.getString("username"));
                booking.setTherapyName(rs.getString("therapy_name"));
                bookings.add(booking);
            }

            request.setAttribute("bookings", bookings);
            request.setAttribute("search", search);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalBookings / PAGE_SIZE));
            request.setAttribute("active", "manage_bookings");
            request.getRequestDispatcher("views/admin/manage_bookings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving bookings: " + e.getMessage());
            request.setAttribute("active", "manage_bookings");
            request.getRequestDispatcher("views/admin/manage_bookings.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah admin sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String bookingId = request.getParameter("booking_id");

        if (action == null || bookingId == null) {
            request.setAttribute("error", "Aksi atau ID booking tidak valid!");
            doGet(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Ambil detail booking untuk email
            String bookingSql = "SELECT b.user_id, u.email, u.username, t.name AS therapy_name, b.booking_date " +
                               "FROM bookings b " +
                               "JOIN users u ON b.user_id = u.id " +
                               "JOIN therapies t ON b.therapy_id = t.id " +
                               "WHERE b.id = ?";
            PreparedStatement bookingStmt = conn.prepareStatement(bookingSql);
            bookingStmt.setInt(1, Integer.parseInt(bookingId));
            ResultSet bookingRs = bookingStmt.executeQuery();
            String userEmail = "";
            String username = "";
            String therapyName = "";
            String bookingDate = "";
            if (bookingRs.next()) {
                userEmail = bookingRs.getString("email");
                username = bookingRs.getString("username");
                therapyName = bookingRs.getString("therapy_name");
                bookingDate = bookingRs.getString("booking_date");
            } else {
                request.setAttribute("error", "Booking tidak ditemukan!");
                doGet(request, response);
                return;
            }

            // Update status booking
            String sql = "UPDATE bookings SET status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            if (action.equals("confirm")) {
                stmt.setString(1, "confirmed");
            } else if (action.equals("cancel")) {
                stmt.setString(1, "cancelled");
            } else {
                request.setAttribute("error", "Aksi tidak valid!");
                doGet(request, response);
                return;
            }
            stmt.setInt(2, Integer.parseInt(bookingId));
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                // Kirim email notifikasi
                if (!userEmail.isEmpty()) {
                    String statusDisplay = action.equals("confirm") ? "Dikonfirmasi" : "Dibatalkan";
                    String subject = "Pembaruan Status Booking - Sistem Booking Jasa Terapi";
                    String body = "Halo " + username + ",\n\n" +
                                  "Status booking Anda telah diperbarui dengan detail berikut:\n" +
                                  "ID Booking: " + bookingId + "\n" +
                                  "Terapi: " + therapyName + "\n" +
                                  "Tanggal Booking: " + bookingDate + "\n" +
                                  "Status Baru: " + statusDisplay + "\n\n" +
                                  "Terima kasih telah menggunakan layanan kami!\n" +
                                  "Sistem Booking Jasa Terapi";
                    try {
                        EmailUtil.sendEmail(userEmail, subject, body);
                        request.setAttribute("success", "Status booking berhasil diperbarui dan notifikasi email telah dikirim!");
                    } catch (MessagingException e) {
                        e.printStackTrace();
                        request.setAttribute("warning", "Status booking berhasil diperbarui, tetapi gagal mengirim email notifikasi: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("warning", "Status booking berhasil diperbarui, tetapi email user tidak ditemukan.");
                }
            } else {
                request.setAttribute("error", "Gagal memperbarui status booking!");
            }
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}