<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // Get form parameters
    String vehicleNumber = request.getParameter("vehicle_number");
    String vehicleType = request.getParameter("vehicle_type");
    String status = request.getParameter("status");

    // Database connection variables
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Database connection
        String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
        String dbUsername = "root";
        String dbPassword = "";
        conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

        // Insert query
        String insertQuery = "INSERT INTO vehicles (vehicle_number, type, status) VALUES (?, ?, ?)";
        stmt = conn.prepareStatement(insertQuery);
        stmt.setString(1, vehicleNumber);
        stmt.setString(2, vehicleType);
        stmt.setString(3, status);

        // Execute the update
        int rowsInserted = stmt.executeUpdate();

        if (rowsInserted > 0) {
            // Redirect back to admin dashboard with success message
            response.sendRedirect("admin_dashboard.jsp?success=Vehicle added successfully!");
        } else {
            // Redirect back with an error message
            response.sendRedirect("admin_dashboard.jsp?error=Failed to add vehicle!");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("admin_dashboard.jsp?error=Database error!");
    } finally {
        // Close resources
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
