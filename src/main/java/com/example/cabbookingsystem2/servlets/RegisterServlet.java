package com.example.cabbookingsystem2.servlets;

import com.example.cabbookingsystem2.utils.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String nic = request.getParameter("nic");
        String address = request.getParameter("address");  // Capture address
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO users (name, email, phone, nic, address, password, role) VALUES (?, ?, ?, ?, ?, ?, 'customer')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, nic);
            stmt.setString(5, address);  // Insert address
            stmt.setString(6, password); // Note: In a real app, you should hash the password
            stmt.executeUpdate();
            response.sendRedirect("login.html?success=1"); // Redirect to login page after success
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.html?error=1"); // Redirect back to registration page on error
        }
    }
}
