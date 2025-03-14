package com.example.cabbookingsystem2.servlets;

import com.example.cabbookingsystem2.utils.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password); // Note: You should hash the password for better security
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // If the user exists, store user details in the session
                String role = rs.getString("role");

                // Create or get the current session
                HttpSession session = request.getSession();
                session.setAttribute("email", email); // Store email in session
                session.setAttribute("role", role);   // Store role in session
                session.setAttribute("sessionId", session.getId()); // Store sessionId in session

                if ("customer".equals(role)) {
                    response.sendRedirect("customer_dashboard.jsp");
                } else if ("admin".equals(role)) {
                    response.sendRedirect("admin_dashboard.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=1"); // Redirect back to login if invalid credentials
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=1"); // Redirect to login page if there is an error
        }
    }
}
