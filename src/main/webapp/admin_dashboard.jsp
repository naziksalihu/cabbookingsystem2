<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery for AJAX -->
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2>Admin Dashboard</h2>

    <!-- View and Edit Booking Status -->
    <h4>Manage Bookings</h4>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>#</th>
            <th>Customer ID</th>
            <th>Pickup</th>
            <th>Destination</th>
            <th>Booking Time</th>
            <th>Status</th>
            <th>Total Fare</th>
            <th>Change Status</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
                String dbUsername = "root";
                String dbPassword = "";
                conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                String bookingQuery = "SELECT id, customer_id, pickup_location, destination, booking_time, status, total_fare FROM bookings";
                stmt = conn.prepareStatement(bookingQuery);
                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getInt("customer_id") %></td>
            <td><%= rs.getString("pickup_location") %></td>
            <td><%= rs.getString("destination") %></td>
            <td><%= rs.getTimestamp("booking_time") %></td>
            <td id="status_<%= rs.getInt("id") %>"><%= rs.getString("status") %></td>
            <td><%= rs.getDouble("total_fare") %></td>
            <td>
                <select class="form-select status-dropdown" data-booking-id="<%= rs.getInt("id") %>">
                    <option value="pending" <%= rs.getString("status").equals("pending") ? "selected" : "" %>>Pending</option>
                    <option value="assigned" <%= rs.getString("status").equals("assigned") ? "selected" : "" %>>Assigned</option>
                </select>
            </td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
        </tbody>
    </table>

    <!-- Add Destination -->
    <h4>Add Destination</h4>
    <form action="add_destination.jsp" method="post">
        <input type="text" name="destination_name" class="form-control mb-2" placeholder="Destination Name" required>
        <input type="number" name="destination_price" class="form-control mb-2" placeholder="Price" required>
        <button type="submit" class="btn btn-primary">Add Destination</button>
    </form>

    <!-- Add Vehicle (Before Adding Driver) -->
    <h4>Add Vehicle</h4>
    <form action="add_vehicle.jsp" method="post">
        <input type="text" name="vehicle_number" class="form-control mb-2" placeholder="Vehicle Number" required>

        <select name="vehicle_type" class="form-control mb-2" required>
            <option value="">Select Vehicle Type</option>
            <option value="Car">Car</option>
            <option value="Van">Van</option>
            <option value="Bike">Bike</option>
            <option value="SUV">SUV</option>
        </select>

        <select name="status" class="form-control mb-2" required>
            <option value="Available" selected>Available</option>
        </select>

        <button type="submit" class="btn btn-primary">Add Vehicle</button>
    </form>


    <!-- Add Driver (Requires Existing Vehicle) -->
    <h4>Add Driver</h4>
    <form action="add_driver.jsp" method="post">
        <input type="text" name="driver_name" class="form-control mb-2" placeholder="Driver Name" required>
        <input type="text" name="phone" class="form-control mb-2" placeholder="Phone" required>
        <input type="text" name="license_number" class="form-control mb-2" placeholder="License Number" required>

        <select name="vehicle_id" class="form-control mb-2" required>
            <option value="">Select Vehicle</option>
            <%
                String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
                String dbUsername = "root";
                String dbPassword = "";
                conn = null;
                stmt = null;
                rs = null;

                try {
                    // Database connection
                    conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

                    // Query to get vehicles that are not assigned to any driver
                    String vehicleQuery = "SELECT v.id, v.vehicle_number " +
                            "FROM vehicles v " +
                            "LEFT JOIN drivers d ON v.id = d.vehicle_id " +
                            "WHERE d.vehicle_id IS NULL";
                    stmt = conn.prepareStatement(vehicleQuery);
                    rs = stmt.executeQuery();

                    // Display vehicles not assigned to any driver
                    while (rs.next()) {
            %>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("vehicle_number") %></option>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    // Close resources
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </select>
        <button type="submit" class="btn btn-primary">Add Driver</button>
    </form>


    <!-- View Users -->
    <h4>Registered Users</h4>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>#</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>NIC</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);
                String userQuery = "SELECT id, name, email, phone, address, nic FROM users";
                stmt = conn.prepareStatement(userQuery);
                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("nic") %></td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
        </tbody>
    </table>
</div>

<script>
    $(".status-dropdown").change(function () {
        let bookingId = $(this).data("booking-id");
        let newStatus = $(this).val();

        $.post("update_booking_status.jsp", { booking_id: bookingId, new_status: newStatus }, function (response) {
            if (response === "success") {
                alert("Booking status updated!");
            } else {
                alert("Error updating booking status.");
            }
        });
    });
</script>

</body>
</html>
