package controllers;

import models.DatabaseConnection;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah user sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("active", "profile");
        request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
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
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Validasi input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email harus diisi!");
            request.setAttribute("active", "profile");
            request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
            return;
        }

        // Validasi format email
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("error", "Format email tidak valid!");
            request.setAttribute("active", "profile");
            request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
            return;
        }

        // Validasi konfirmasi password
        if (password != null && !password.trim().isEmpty()) {
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Password dan konfirmasi password tidak cocok!");
                request.setAttribute("active", "profile");
                request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
                return;
            }
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Cek apakah email sudah digunakan
            String checkEmailSql = "SELECT id FROM users WHERE email = ? AND id != ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql);
            checkStmt.setString(1, email);
            checkStmt.setInt(2, user.getId());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("error", "Email sudah digunakan oleh user lain!");
                request.setAttribute("active", "profile");
                request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
                return;
            }

            // Update profil
            String sql;
            PreparedStatement stmt;
            if (password != null && !password.trim().isEmpty()) {
                sql = "UPDATE users SET email = ?, password = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                stmt.setString(2, password);
                stmt.setInt(3, user.getId());
            } else {
                sql = "UPDATE users SET email = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                stmt.setInt(2, user.getId());
            }

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                // Update session
                user.setEmail(email);
                if (password != null && !password.trim().isEmpty()) {
                    user.setPassword(password);
                }
                session.setAttribute("user", user);
                request.setAttribute("success", "Profil berhasil diperbarui!");
            } else {
                request.setAttribute("error", "Gagal memperbarui profil!");
            }
            request.setAttribute("active", "profile");
            request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.setAttribute("active", "profile");
            request.getRequestDispatcher("views/user/profile.jsp").forward(request, response);
        }
    }
}