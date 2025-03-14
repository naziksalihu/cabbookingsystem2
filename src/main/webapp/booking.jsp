<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
  // Create or get the current session
  HttpSession sessionObj = request.getSession();
  String email = (String) sessionObj.getAttribute("email");

  if (email == null) {
    response.sendRedirect("login.jsp"); // Redirect to login if session is not set
    return;
  }

  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;
  int userId = -1;

  try {
    String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
    String dbUsername = "root";
    String dbPassword = "";
    conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

    String userQuery = "SELECT id FROM users WHERE email = ?";
    stmt = conn.prepareStatement(userQuery);
    stmt.setString(1, email);
    rs = stmt.executeQuery();

    if (rs.next()) {
      userId = rs.getInt("id");
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Booking - Mega City Cab</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
  <h2>Book Your Ride</h2>

  <form method="post" action="booking.jsp">

    <!-- Default Pickup Location -->
    <div class="mb-3">
      <label class="form-label"><strong>Pickup Location:</strong></label>
      <input type="text" name="pickup_location" class="form-control" value="Colombo" readonly>
    </div>

    <!-- Select Destination -->
    <div class="mb-3">
      <label class="form-label"><strong>Select Destination:</strong></label>
      <select name="destination_id" id="destination" class="form-control" required onchange="updatePrice()">
        <option value="">Select Destination</option>
        <%
          try {
            String destinationQuery = "SELECT id, name, price FROM destinations";
            stmt = conn.prepareStatement(destinationQuery);
            rs = stmt.executeQuery();
            while (rs.next()) {
        %>
        <option value="<%= rs.getInt("id") %>" data-price="<%= rs.getDouble("price") %>">
          <%= rs.getString("name") %> - $<%= rs.getDouble("price") %>
        </option>
        <%
            }
          } catch (SQLException e) {
            e.printStackTrace();
          }
        %>
      </select>
    </div>

    <!-- Total Fare -->
    <div class="mb-3">
      <label class="form-label"><strong>Total Fare:</strong></label>
      <input type="text" id="total_fare" name="total_fare" class="form-control" readonly>
    </div>

    <!-- Vehicle Selection -->
    <div class="mb-3">
      <label class="form-label"><strong>Select Vehicle:</strong></label>
      <select name="vehicle_id" id="vehicle" class="form-control" required>
        <option value="">Select an Available Vehicle</option>
        <%
          try {
            String vehicleQuery = "SELECT id, vehicle_number, type FROM vehicles WHERE status = 'available'";
            stmt = conn.prepareStatement(vehicleQuery);
            rs = stmt.executeQuery();
            while (rs.next()) {
        %>
        <option value="<%= rs.getInt("id") %>"><%= rs.getString("vehicle_number") %> - <%= rs.getString("type") %></option>
        <%
            }
          } catch (SQLException e) {
            e.printStackTrace();
          }
        %>
      </select>
    </div>

    <input type="hidden" name="user_id" value="<%= userId %>">

    <button type="submit" class="btn btn-primary w-100">Confirm Booking</button>
  </form>

  <%
    if (request.getMethod().equals("POST")) {
      String pickupLocation = "Colombo"; // Default value
      String destinationId = request.getParameter("destination_id");
      String totalFare = request.getParameter("total_fare");
      String vehicleId = request.getParameter("vehicle_id");
      int driverId = -1; // Variable to store assigned driver

      if (userId != -1 && destinationId != null && vehicleId != null) {
        try {
          // Check if a driver is available for the selected vehicle
          String driverQuery = "SELECT id FROM drivers WHERE vehicle_id = ? AND availability = 1 LIMIT 1";
          stmt = conn.prepareStatement(driverQuery);
          stmt.setInt(1, Integer.parseInt(vehicleId));
          rs = stmt.executeQuery();

          if (rs.next()) {
            driverId = rs.getInt("id");

            // Retrieve destination name
            String destQuery = "SELECT name FROM destinations WHERE id = ?";
            stmt = conn.prepareStatement(destQuery);
            stmt.setInt(1, Integer.parseInt(destinationId));
            rs = stmt.executeQuery();
            String destinationName = "";
            if (rs.next()) {
              destinationName = rs.getString("name");
            }

            // Insert booking record
            String insertBooking = "INSERT INTO bookings (customer_id, driver_id, vehicle_id, pickup_location, destination, booking_time, status, total_fare) VALUES (?, ?, ?, ?, ?, NOW(), 'Pending', ?)";
            stmt = conn.prepareStatement(insertBooking);
            stmt.setInt(1, userId);
            stmt.setInt(2, driverId);
            stmt.setInt(3, Integer.parseInt(vehicleId));
            stmt.setString(4, pickupLocation);
            stmt.setString(5, destinationName);
            stmt.setDouble(6, Double.parseDouble(totalFare));

            int rows = stmt.executeUpdate();
            if (rows > 0) {
              System.out.println("<div class='alert alert-success mt-3'>Booking successful!</div>");
            } else {
              System.out.println("<div class='alert alert-danger mt-3'>Booking failed. Try again.</div>");
            }
          } else {
            System.out.println("<div class='alert alert-danger mt-3'>No available drivers for this vehicle.</div>");
          }
        } catch (SQLException e) {
          e.printStackTrace();
        }
      } else {
        System.out.println("<div class='alert alert-danger mt-3'>All fields are required!</div>");
      }
    }

    if (conn != null) conn.close();
  %>
</div>

<script>
  function updatePrice() {
    var select = document.getElementById("destination");
    var price = select.options[select.selectedIndex].getAttribute("data-price");
    document.getElementById("total_fare").value = price;
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
