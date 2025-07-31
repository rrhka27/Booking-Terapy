package models;

import java.util.Date;

public class Booking {
    private int id;
    private int userId;
    private int therapyId;
    private Date bookingDate;
    private String status;
    private Date createdAt;
    private String username;
    private String therapyName;

    public Booking() {}

    public Booking(int id, int userId, int therapyId, Date bookingDate, String status, Date createdAt, String username, String therapyName) {
        this.id = id;
        this.userId = userId;
        this.therapyId = therapyId;
        this.bookingDate = bookingDate;
        this.status = status;
        this.createdAt = createdAt;
        this.username = username;
        this.therapyName = therapyName;
        
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getTherapyId() { return therapyId; }
    public void setTherapyId(int therapyId) { this.therapyId = therapyId; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getTherapyName() { return therapyName; }
    public void setTherapyName(String therapyName) { this.therapyName = therapyName; }
}