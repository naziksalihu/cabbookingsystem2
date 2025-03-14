<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>

<%
  // Get form parameters
  String driverName = request.getParameter("driver_name");
  String phone = request.getParameter("phone");
  String licenseNumber = request.getParameter("license_number");
  String vehicleId = request.getParameter("vehicle_id");

  // Database connection variables
  Connection conn = null;
  PreparedStatement stmt = null;

  try {
    // Database connection
    String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
    String dbUsername = "root";
    String dbPassword = "";
    conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

    // Insert query to add driver
    String insertQuery = "INSERT INTO drivers (name, phone, license_number, vehicle_id, availability) " +
            "VALUES (?, ?, ?, ?, ?)";
    stmt = conn.prepareStatement(insertQuery);
    stmt.setString(1, driverName);
    stmt.setString(2, phone);
    stmt.setString(3, licenseNumber);
    stmt.setInt(4, Integer.parseInt(vehicleId)); // Convert vehicleId to integer
    stmt.setBoolean(5, true); // Availability set to true (assuming the driver is available)

    // Execute the update
    int rowsInserted = stmt.executeUpdate();

    if (rowsInserted > 0) {
      // Redirect back to admin dashboard with success message
      response.sendRedirect("admin_dashboard.jsp?success=Driver added successfully!");
    } else {
      // Redirect back with an error message
      response.sendRedirect("admin_dashboard.jsp?error=Failed to add driver!");
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
