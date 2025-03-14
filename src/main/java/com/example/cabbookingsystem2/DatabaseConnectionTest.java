package com.example.cabbookingsystem2;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnectionTest {
    private static final String URL = "jdbc:mysql://localhost:3306/car_booking_system";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static void main(String[] args) {
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD)) {
            if (connection != null) {
                System.out.println("Connection successful!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
