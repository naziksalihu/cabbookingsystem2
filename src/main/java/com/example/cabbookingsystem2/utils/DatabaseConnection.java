package com.example.cabbookingsystem2.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/car_booking_system?useSSL=false";
    private static final String USER = "root";  // Change to your MySQL username
    private static final String PASSWORD = "";  // Change to your MySQL password

    public static Connection getConnection() {
        try {
            // Ensure JDBC driver is loaded
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish the connection
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("JDBC Driver not found. Ensure MySQL JDBC driver is included in the project.");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database connection error! Please check your database settings and connection details.");
        }
    }
}
