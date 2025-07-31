package controllers;

import models.DatabaseConnection;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/cancelBooking")
public class CancelBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah user sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil ID user dari session
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // Ambil booking_id dari parameter
        String bookingIdStr = request.getParameter("booking_id");
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID booking tidak valid!");
            request.getRequestDispatcher("/bookingHistory").forward(request, response);
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID booking tidak valid!");
            request.getRequestDispatcher("/bookingHistory").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Verifikasi bahwa booking milik user dan statusnya pending
            String checkSql = "SELECT status, user_id FROM bookings WHERE id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, bookingId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                if (rs.getInt("user_id") != userId) {
                    request.setAttribute("error", "Anda tidak memiliki izin untuk membatalkan booking ini!");
                    request.getRequestDispatcher("/bookingHistory").forward(request, response);
                    return;
                }
                if (!rs.getString("status").equals("pending")) {
                    request.setAttribute("error", "Hanya booking dengan status 'pending' yang dapat dibatalkan!");
                    request.getRequestDispatcher("/bookingHistory").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Booking tidak ditemukan!");
                request.getRequestDispatcher("/bookingHistory").forward(request, response);
                return;
            }

            // Update status booking ke cancelled
            String sql = "UPDATE bookings SET status = 'cancelled' WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("success", "Booking berhasil dibatalkan!");
            } else {
                request.setAttribute("error", "Gagal membatalkan booking!");
            }
            request.getRequestDispatcher("/bookingHistory").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/bookingHistory").forward(request, response);
        }
    }
}