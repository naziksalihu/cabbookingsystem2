package com.example.cabbookingsystem2.dao;

import com.example.cabbookingsystem2.models.Destination;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DestinationDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/car_booking_system";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    private static Connection connection;

    // Static block to initialize the database connection
    static {
        try {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            if (connection != null) {
                System.out.println("Connection established successfully.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Optionally, log the error here
        }
    }

    // Method to insert a new destination
    public boolean addDestination(Destination destination) {
        String sql = "INSERT INTO destinations (name, price) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, destination.getName());
            stmt.setDouble(2, destination.getPrice());
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method to retrieve all destinations
    public List<Destination> getAllDestinations() {
        List<Destination> destinations = new ArrayList<>();
        String sql = "SELECT * FROM destinations";
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                destinations.add(new Destination(name, price));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return destinations;
    }
}
