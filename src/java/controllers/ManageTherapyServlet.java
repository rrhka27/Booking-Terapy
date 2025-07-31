package controllers;

import models.DatabaseConnection;
import models.Therapy;
import models.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/manageTherapies")
public class ManageTherapyServlet extends HttpServlet {
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
        String priceFilter = request.getParameter("priceFilter");
        String sortBy = request.getParameter("sortBy");
        if (search == null) search = "";
        if (priceFilter == null) priceFilter = "all";
        if (sortBy == null) sortBy = "id";

        List<Therapy> therapies = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Bangun query dinamis
            StringBuilder sql = new StringBuilder(
                "SELECT id, name, description, price, duration FROM therapies WHERE 1=1"
            );

            // Tambahkan pencarian
            List<String> params = new ArrayList<>();
            if (!search.trim().isEmpty()) {
                sql.append(" AND (name LIKE ? OR description LIKE ?)");
                String searchParam = "%" + search.trim() + "%";
                params.add(searchParam);
                params.add(searchParam);
            }

            // Tambahkan filter harga
            if (!priceFilter.equals("all")) {
                if (priceFilter.equals("low")) {
                    sql.append(" AND price <= 100000");
                } else if (priceFilter.equals("medium")) {
                    sql.append(" AND price > 100000 AND price <= 300000");
                } else if (priceFilter.equals("high")) {
                    sql.append(" AND price > 300000");
                }
            }

            // Tambahkan sorting
            if (sortBy.equals("name")) {
                sql.append(" ORDER BY name ASC");
            } else if (sortBy.equals("price")) {
                sql.append(" ORDER BY price ASC");
            } else if (sortBy.equals("duration")) {
                sql.append(" ORDER BY duration ASC");
            } else {
                sql.append(" ORDER BY id DESC");
            }

            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }

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
            request.setAttribute("search", search);
            request.setAttribute("priceFilter", priceFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("active", "manage_therapies");
            request.getRequestDispatcher("views/admin/manage_therapies.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving therapies: " + e.getMessage());
            request.setAttribute("active", "manage_therapies");
            request.getRequestDispatcher("views/admin/manage_therapies.jsp").forward(request, response);
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
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String priceStr = request.getParameter("price");
                String durationStr = request.getParameter("duration");

                // Validasi input
                if (name == null || name.trim().isEmpty()) {
                    request.setAttribute("error", "Nama terapi harus diisi!");
                    doGet(request, response);
                    return;
                }
                double price;
                int duration;
                try {
                    price = Double.parseDouble(priceStr);
                    duration = Integer.parseInt(durationStr);
                    if (price <= 0 || duration <= 0) {
                        request.setAttribute("error", "Harga dan durasi harus positif!");
                        doGet(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Harga atau durasi tidak valid!");
                    doGet(request, response);
                    return;
                }

                // Cek nama terapi unik
                String checkSql = "SELECT id FROM therapies WHERE name = ? AND id != ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, name);
                checkStmt.setInt(2, action.equals("edit") ? Integer.parseInt(request.getParameter("id")) : 0);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("error", "Nama terapi sudah digunakan!");
                    doGet(request, response);
                    return;
                }

                if (action.equals("add")) {
                    String sql = "INSERT INTO therapies (name, description, price, duration) VALUES (?, ?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, name);
                    stmt.setString(2, description);
                    stmt.setDouble(3, price);
                    stmt.setInt(4, duration);
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        request.setAttribute("success", "Terapi berhasil ditambahkan!");
                    } else {
                        request.setAttribute("error", "Gagal menambahkan terapi!");
                    }
                } else if (action.equals("edit")) {
                    String id = request.getParameter("id");
                    String sql = "UPDATE therapies SET name = ?, description = ?, price = ?, duration = ? WHERE id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, name);
                    stmt.setString(2, description);
                    stmt.setDouble(3, price);
                    stmt.setInt(4, duration);
                    stmt.setInt(5, Integer.parseInt(id));
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        request.setAttribute("success", "Terapi berhasil diperbarui!");
                    } else {
                        request.setAttribute("error", "Gagal memperbarui terapi!");
                    }
                }
            } else if (action.equals("delete")) {
                String id = request.getParameter("id");
                // Cek apakah terapi digunakan di booking aktif
                String checkSql = "SELECT id FROM bookings WHERE therapy_id = ? AND status != 'cancelled'";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, Integer.parseInt(id));
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("error", "Terapi tidak dapat dihapus karena digunakan di booking aktif!");
                    doGet(request, response);
                    return;
                }

                String sql = "DELETE FROM therapies WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(id));
                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    request.setAttribute("success", "Terapi berhasil dihapus!");
                } else {
                    request.setAttribute("error", "Gagal menghapus terapi!");
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