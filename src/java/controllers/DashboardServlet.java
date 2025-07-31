package controllers;

import models.DatabaseConnection;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah user sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (user.getRole().equals("user")) {
                // Statistik untuk user: jumlah booking per status
                Map<String, Integer> bookingStats = new HashMap<>();
                bookingStats.put("pending", 0);
                bookingStats.put("confirmed", 0);
                bookingStats.put("cancelled", 0);

                String sql = "SELECT status, COUNT(*) as count FROM bookings WHERE user_id = ? GROUP BY status";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, user.getId());
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    bookingStats.put(rs.getString("status"), rs.getInt("count"));
                }
                request.setAttribute("bookingStats", bookingStats);
            } else if (user.getRole().equals("admin")) {
                // Statistik untuk admin: total user, booking, terapi
                Map<String, Integer> adminStats = new HashMap<>();
                
                // Total user
                String userSql = "SELECT COUNT(*) as count FROM users";
                PreparedStatement userStmt = conn.prepareStatement(userSql);
                ResultSet userRs = userStmt.executeQuery();
                if (userRs.next()) {
                    adminStats.put("totalUsers", userRs.getInt("count"));
                }

                // Total booking
                String bookingSql = "SELECT COUNT(*) as count FROM bookings";
                PreparedStatement bookingStmt = conn.prepareStatement(bookingSql);
                ResultSet bookingRs = bookingStmt.executeQuery();
                if (bookingRs.next()) {
                    adminStats.put("totalBookings", bookingRs.getInt("count"));
                }

                // Total terapi
                String therapySql = "SELECT COUNT(*) as count FROM therapies";
                PreparedStatement therapyStmt = conn.prepareStatement(therapySql);
                ResultSet therapyRs = therapyStmt.executeQuery();
                if (therapyRs.next()) {
                    adminStats.put("totalTherapies", therapyRs.getInt("count"));
                }
                
                request.setAttribute("adminStats", adminStats);
            }

            request.setAttribute("active", "dashboard");
            request.getRequestDispatcher("views/user/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving dashboard data: " + e.getMessage());
            request.setAttribute("active", "dashboard");
            request.getRequestDispatcher("views/user/dashboard.jsp").forward(request, response);
        }
    }
}