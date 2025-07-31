package models;

public class Therapy {
    private int id;
    private String name;
    private String description;
    private double price;
    private int duration;

    public Therapy() {}

    public Therapy(int id, String name, String description, double price, int duration) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.duration = duration;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
}