<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery for AJAX -->
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2>Welcome, ${sessionScope.email}</h2>

    <!-- User Details -->
    <h4>Your Profile Details</h4>
    <div class="card p-4 mb-4">
        <%
            String email = (String) session.getAttribute("email");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            int userId = -1; // Variable to hold user ID

            try {
                String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
                String dbUsername = "root";
                String dbPassword = "";
                conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                String userQuery = "SELECT id, name, email, phone, address, nic FROM users WHERE email = ?";
                stmt = conn.prepareStatement(userQuery);
                stmt.setString(1, email);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    userId = rs.getInt("id");
        %>
        <p><strong>Name:</strong> <%= rs.getString("name") %></p>
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Phone:</strong> <%= rs.getString("phone") %></p>
        <p><strong>Address:</strong> <%= rs.getString("address") %></p>
        <p><strong>NIC:</strong> <%= rs.getString("nic") %></p>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </div>

    <!-- Booking Button -->
    <a href="booking.jsp" class="btn btn-success">Book Now</a>

    <!-- Booking History Table -->
    <h4>Your Booking History</h4>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>#</th>
            <th>Pickup Location</th>
            <th>Destination</th>
            <th>Booking Time</th>
            <th>Status</th>
            <th>Total Fare</th>
            <th>Driver Name</th>
            <th>Driver Phone</th>
            <th>License No.</th>
            <th>Action</th> <!-- Action column for Complete/Cancel -->
        </tr>
        </thead>
        <tbody>
        <%
            try {
                String bookingQuery = "SELECT b.id, b.pickup_location, b.destination, b.booking_time, b.status, b.total_fare, " +
                        "d.name AS driver_name, d.phone AS driver_phone, d.license_number " +
                        "FROM bookings b " +
                        "LEFT JOIN drivers d ON b.driver_id = d.id " +
                        "WHERE b.customer_id = ? " +
                        "ORDER BY b.booking_time DESC";

                stmt = conn.prepareStatement(bookingQuery);
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String status = rs.getString("status");
                    String driverName = rs.getString("driver_name") != null ? rs.getString("driver_name") : "Not Assigned";
                    String driverPhone = rs.getString("driver_phone") != null ? rs.getString("driver_phone") : "-";
                    String licenseNumber = rs.getString("license_number") != null ? rs.getString("license_number") : "-";
        %>
        <tr id="booking_<%= rs.getInt("id") %>">
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("pickup_location") %></td>
            <td><%= rs.getString("destination") %></td>
            <td><%= rs.getTimestamp("booking_time") %></td>
            <td id="status_<%= rs.getInt("id") %>"><%= status %></td>
            <td><%= rs.getDouble("total_fare") %></td>
            <td><%= driverName %></td>
            <td><%= driverPhone %></td>
            <td><%= licenseNumber %></td>
            <td>
                <!-- Always show the Cancel button -->
                <button class="btn btn-danger" onclick="cancelBooking(<%= rs.getInt("id") %>, '<%= status %>')">Cancel</button>

                <!-- Show Complete button only when status is "assigned" -->
                <button class="btn btn-success" onclick="completeBooking(<%= rs.getInt("id") %>, '<%= status %>')" <%= !status.equals("assigned") ? "disabled" : "" %>>Complete</button>
            </td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        </tbody>
    </table>
</div>

<!-- JS dependencies -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

<!-- JavaScript for AJAX -->
<script>
    function cancelBooking(bookingId, status) {
        if (status !== "completed") {
            $.ajax({
                url: 'update_booking_status.jsp',
                type: 'POST',
                data: {
                    booking_id: bookingId,
                    new_status: 'cancelled'
                },
                success: function(response) {
                    if (response === 'success') {
                        $('#status_' + bookingId).text('Canceled');
                        alert("Booking has been canceled.");
                    } else {
                        alert("Error canceling booking.");
                    }
                }
            });
        }
    }

    function completeBooking(bookingId, status) {
        if (status === "assigned") {
            $.ajax({
                url: 'update_booking_status.jsp',
                type: 'POST',
                data: {
                    booking_id: bookingId,
                    new_status: 'completed'
                },
                success: function(response) {
                    if (response === 'success') {
                        $('#status_' + bookingId).text('Completed');
                        alert("Booking has been completed.");
                    } else {
                        alert("Error completing booking.");
                    }
                }
            });
        }
    }
</script>

</body>
</html>
