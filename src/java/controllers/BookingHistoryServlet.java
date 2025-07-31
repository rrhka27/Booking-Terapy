package controllers;

import models.DatabaseConnection;
import models.Booking;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/bookingHistory")
public class BookingHistoryServlet extends HttpServlet {
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

        // Ambil daftar booking user
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT b.id, b.user_id, b.therapy_id, t.name AS therapy_name, b.booking_date, b.status, b.created_at, u.username " +
                         "FROM bookings b " +
                         "JOIN therapies t ON b.therapy_id = t.id " +
                         "JOIN users u ON b.user_id = u.id " +
                         "WHERE b.user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getInt("therapy_id"),
                    rs.getTimestamp("booking_date"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at"),
                    rs.getString("username"),
                    rs.getString("therapy_name")
                );
                bookings.add(booking);
            }
            request.setAttribute("bookings", bookings);
            request.setAttribute("active", "booking_history");
            request.getRequestDispatcher("views/user/booking_history.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving booking history: " + e.getMessage());
            request.setAttribute("active", "booking_history");
            request.getRequestDispatcher("views/user/booking_history.jsp").forward(request, response);
        }
    }
}