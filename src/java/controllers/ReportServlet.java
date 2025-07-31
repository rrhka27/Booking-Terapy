package controllers;

import models.Booking;
import models.DatabaseConnection;
import models.User;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private static final int PAGE_SIZE = 10; // Jumlah booking per halaman

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek apakah admin sudah login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !((User) session.getAttribute("user")).getRole().equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil parameter filter dan halaman
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String statusFilter = request.getParameter("status");
        String pageStr = request.getParameter("page");
        if (statusFilter == null) statusFilter = "all";
        if (startDate == null) startDate = "";
        if (endDate == null) endDate = "";
        int page = pageStr != null && !pageStr.isEmpty() ? Integer.parseInt(pageStr) : 1;
        int offset = (page - 1) * PAGE_SIZE;

        List<Booking> bookings = new ArrayList<>();
        int totalBookings = 0;
        int pendingCount = 0;
        int confirmedCount = 0;
        int cancelledCount = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Hitung statistik
            String statsSql = "SELECT COUNT(*) AS total, " +
                             "SUM(CASE WHEN b.status = 'pending' THEN 1 ELSE 0 END) AS pending_count, " +
                             "SUM(CASE WHEN b.status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_count, " +
                             "SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_count " +
                             "FROM bookings b WHERE 1=1";
            List<String> statsParams = new ArrayList<>();
            if (!startDate.isEmpty()) {
                statsSql += " AND b.booking_date >= ?";
                statsParams.add(startDate);
            }
            if (!endDate.isEmpty()) {
                statsSql += " AND b.booking_date <= ?";
                statsParams.add(endDate);
            }
            if (!statusFilter.equals("all")) {
                statsSql += " AND b.status = ?";
                statsParams.add(statusFilter);
            }
            PreparedStatement statsStmt = conn.prepareStatement(statsSql);
            for (int i = 0; i < statsParams.size(); i++) {
                statsStmt.setString(i + 1, statsParams.get(i));
            }
            ResultSet statsRs = statsStmt.executeQuery();
            if (statsRs.next()) {
                totalBookings = statsRs.getInt("total");
                pendingCount = statsRs.getInt("pending_count");
                confirmedCount = statsRs.getInt("confirmed_count");
                cancelledCount = statsRs.getInt("cancelled_count");
            }

            // Ambil data booking untuk tabel atau PDF
            StringBuilder sql = new StringBuilder(
                "SELECT b.id, b.user_id, b.therapy_id, b.booking_date, b.status, b.created_at, u.username, t.name as therapy_name " +
                "FROM bookings b JOIN users u ON b.user_id = u.id JOIN therapies t ON b.therapy_id = t.id WHERE 1=1"
            );
            List<String> params = new ArrayList<>();
            if (!startDate.isEmpty()) {
                sql.append(" AND b.booking_date >= ?");
                params.add(startDate);
            }
            if (!endDate.isEmpty()) {
                sql.append(" AND b.booking_date <= ?");
                params.add(endDate);
            }
            if (!statusFilter.equals("all")) {
                sql.append(" AND b.status = ?");
                params.add(statusFilter);
            }
            sql.append(" ORDER BY b.booking_date DESC");

            // Jika ekspor ke PDF, ambil semua data tanpa LIMIT
            String export = request.getParameter("export");
            if ("pdf".equals(export)) {
                PreparedStatement stmt = conn.prepareStatement(sql.toString());
                for (int i = 0; i < params.size(); i++) {
                    stmt.setString(i + 1, params.get(i));
                }
                ResultSet rs = stmt.executeQuery();
                List<Booking> allBookings = new ArrayList<>();
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
                    allBookings.add(booking);
                }

                // Generate PDF dengan PDFBox
                generatePdfReport(response, allBookings, startDate, endDate, statusFilter, totalBookings);
                return;
            }

            // Tambah LIMIT dan OFFSET untuk tampilan web
            sql.append(" LIMIT ? OFFSET ?");
            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }
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
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("confirmedCount", confirmedCount);
            request.setAttribute("cancelledCount", cancelledCount);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalBookings / PAGE_SIZE));
            request.setAttribute("active", "reports");
            request.getRequestDispatcher("views/admin/reports.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving report: " + e.getMessage());
            request.setAttribute("active", "reports");
            request.getRequestDispatcher("views/admin/reports.jsp").forward(request, response);
        }
    }

    private void generatePdfReport(HttpServletResponse response, List<Booking> bookings, String startDate, String endDate, String statusFilter, int totalBookings) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"laporan_booking.pdf\"");

        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);
            PDPageContentStream contentStream = null;
            try {
                contentStream = new PDPageContentStream(document, page);
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 16);
                contentStream.beginText();
                contentStream.newLineAtOffset(50, 750);
                contentStream.showText("Laporan Booking Jasa Terapi");
                contentStream.endText();

                contentStream.setFont(PDType1Font.HELVETICA, 12);
                contentStream.beginText();
                contentStream.newLineAtOffset(50, 720);
                contentStream.showText("Tanggal Mulai: " + (startDate.isEmpty() ? "Semua" : startDate));
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Tanggal Selesai: " + (endDate.isEmpty() ? "Semua" : endDate));
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Status: " + (statusFilter.equals("all") ? "Semua" : statusFilter));
                contentStream.newLineAtOffset(0, -20);
                contentStream.showText("Total Booking: " + totalBookings);
                contentStream.endText();

                // Tabel header
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 10);
                contentStream.beginText();
                contentStream.newLineAtOffset(50, 650);
                contentStream.showText("ID");
                contentStream.newLineAtOffset(50, 0);
                contentStream.showText("Username");
                contentStream.newLineAtOffset(100, 0);
                contentStream.showText("Terapi");
                contentStream.newLineAtOffset(120, 0);
                contentStream.showText("Tanggal Booking");
                contentStream.newLineAtOffset(120, 0);
                contentStream.showText("Status");
                contentStream.endText();

                // Garis header
                contentStream.moveTo(50, 645);
                contentStream.lineTo(550, 645);
                contentStream.stroke();

                // Tabel data
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm");
                contentStream.setFont(PDType1Font.HELVETICA, 10);
                float y = 630;
                for (Booking booking : bookings) {
                    contentStream.beginText();
                    contentStream.newLineAtOffset(50, y);
                    contentStream.showText(String.valueOf(booking.getId()));
                    contentStream.newLineAtOffset(50, 0);
                    contentStream.showText(booking.getUsername() != null ? booking.getUsername() : "");
                    contentStream.newLineAtOffset(100, 0);
                    contentStream.showText(booking.getTherapyName() != null ? booking.getTherapyName() : "");
                    contentStream.newLineAtOffset(120, 0);
                    contentStream.showText(booking.getBookingDate() != null ? dateFormat.format(booking.getBookingDate()) : "");
                    contentStream.newLineAtOffset(120, 0);
                    contentStream.showText(booking.getStatus() != null ? booking.getStatus() : "");
                    contentStream.endText();
                    y -= 20;

                    // Tambah halaman baru jika diperlukan
                    if (y < 50) {
                        contentStream.close();
                        page = new PDPage();
                        document.addPage(page);
                        contentStream = new PDPageContentStream(document, page);
                        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 10);
                        contentStream.beginText();
                        contentStream.newLineAtOffset(50, 750);
                        contentStream.showText("ID");
                        contentStream.newLineAtOffset(50, 0);
                        contentStream.showText("Username");
                        contentStream.newLineAtOffset(100, 0);
                        contentStream.showText("Terapi");
                        contentStream.newLineAtOffset(120, 0);
                        contentStream.showText("Tanggal Booking");
                        contentStream.newLineAtOffset(120, 0);
                        contentStream.showText("Status");
                        contentStream.endText();
                        contentStream.moveTo(50, 745);
                        contentStream.lineTo(550, 745);
                        contentStream.stroke();
                        contentStream.setFont(PDType1Font.HELVETICA, 10);
                        y = 730;
                    }
                }

                if (contentStream != null) {
                    contentStream.close();
                }
            } catch (IOException e) {
                throw new IOException("Error creating PDF content stream: " + e.getMessage(), e);
            }
            document.save(response.getOutputStream());
        }
    }
}