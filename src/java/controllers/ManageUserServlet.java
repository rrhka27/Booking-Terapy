package controllers;

import models.DatabaseConnection;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/manageUsers")
public class ManageUserServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah admin sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil parameter pencarian, filter, dan sorting
        String search = request.getParameter("search");
        String roleFilter = request.getParameter("roleFilter");
        String sortBy = request.getParameter("sortBy");
        if (search == null) search = "";
        if (roleFilter == null) roleFilter = "all";
        if (sortBy == null) sortBy = "id";

        List<User> users = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Bangun query dinamis
            StringBuilder sql = new StringBuilder(
                "SELECT id, username, email, role FROM users WHERE 1=1"
            );

            // Tambahkan pencarian
            List<String> params = new ArrayList<>();
            if (!search.trim().isEmpty()) {
                sql.append(" AND (username LIKE ? OR email LIKE ?)");
                String searchParam = "%" + search.trim() + "%";
                params.add(searchParam);
                params.add(searchParam);
            }

            // Tambahkan filter role
            if (!roleFilter.equals("all")) {
                sql.append(" AND role = ?");
                params.add(roleFilter);
            }

            // Tambahkan sorting
            if (sortBy.equals("username")) {
                sql.append(" ORDER BY username ASC");
            } else if (sortBy.equals("email")) {
                sql.append(" ORDER BY email ASC");
            } else {
                sql.append(" ORDER BY id DESC");
            }

            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }

            request.setAttribute("users", users);
            request.setAttribute("search", search);
            request.setAttribute("roleFilter", roleFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("active", "manage_users");
            request.getRequestDispatcher("views/admin/manage_users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving users: " + e.getMessage());
            request.setAttribute("active", "manage_users");
            request.getRequestDispatcher("views/admin/manage_users.jsp").forward(request, response);
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
        if (action == null) {
            request.setAttribute("error", "Aksi tidak valid!");
            doGet(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (action.equals("add") || action.equals("edit")) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                // Validasi input
                if (username == null || username.trim().isEmpty()) {
                    request.setAttribute("error", "Username harus diisi!");
                    doGet(request, response);
                    return;
                }
                if (email == null || email.trim().isEmpty()) {
                    request.setAttribute("error", "Email harus diisi!");
                    doGet(request, response);
                    return;
                }
                if (!EMAIL_PATTERN.matcher(email).matches()) {
                    request.setAttribute("error", "Format email tidak valid!");
                    doGet(request, response);
                    return;
                }
                if (action.equals("add") && (password == null || password.trim().isEmpty())) {
                    request.setAttribute("error", "Password harus diisi untuk user baru!");
                    doGet(request, response);
                    return;
                }
                if (role == null || (!role.equals("admin") && !role.equals("user"))) {
                    request.setAttribute("error", "Role tidak valid!");
                    doGet(request, response);
                    return;
                }

                // Cek username dan email unik
                String checkSql = "SELECT id FROM users WHERE (username = ? OR email = ?) AND id != ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, username);
                checkStmt.setString(2, email);
                checkStmt.setInt(3, action.equals("edit") ? Integer.parseInt(request.getParameter("id")) : 0);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("error", "Username atau email sudah digunakan!");
                    doGet(request, response);
                    return;
                }

                if (action.equals("add")) {
                    String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, username);
                    stmt.setString(2, email);
                    stmt.setString(3, password);
                    stmt.setString(4, role);
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        request.setAttribute("success", "User berhasil ditambahkan!");
                    } else {
                        request.setAttribute("error", "Gagal menambahkan user!");
                    }
                } else if (action.equals("edit")) {
                    String id = request.getParameter("id");
                    String sql = password.trim().isEmpty() ?
                        "UPDATE users SET username = ?, email = ?, role = ? WHERE id = ?" :
                        "UPDATE users SET username = ?, email = ?, password = ?, role = ? WHERE id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, username);
                    stmt.setString(2, email);
                    if (password.trim().isEmpty()) {
                        stmt.setString(3, role);
                        stmt.setInt(4, Integer.parseInt(id));
                    } else {
                        stmt.setString(3, password);
                        stmt.setString(4, role);
                        stmt.setInt(5, Integer.parseInt(id));
                    }
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        request.setAttribute("success", "User berhasil diperbarui!");
                    } else {
                        request.setAttribute("error", "Gagal memperbarui user!");
                    }
                }
            } else if (action.equals("delete")) {
                String id = request.getParameter("id");
                // Cek apakah user memiliki booking aktif
                String checkSql = "SELECT id FROM bookings WHERE user_id = ? AND status != 'cancelled'";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, Integer.parseInt(id));
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("error", "User tidak dapat dihapus karena memiliki booking aktif!");
                    doGet(request, response);
                    return;
                }

                String sql = "DELETE FROM users WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(id));
                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    request.setAttribute("success", "User berhasil dihapus!");
                } else {
                    request.setAttribute("error", "Gagal menghapus user!");
                }
            } else {
                request.setAttribute("error", "Aksi tidak valid!");
            }
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}