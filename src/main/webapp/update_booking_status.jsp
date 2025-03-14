<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    String bookingId = request.getParameter("booking_id");
    String newStatus = request.getParameter("new_status");

    Connection conn = null;
    PreparedStatement stmt = null;
    PreparedStatement vehicleStmt = null;
    ResultSet rs = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/car_booking_system";
        String dbUsername = "root";
        String dbPassword = "";
        conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

        // Get the vehicle_id from the bookings table based on booking_id
        String getVehicleQuery = "SELECT vehicle_id FROM bookings WHERE id = ?";
        stmt = conn.prepareStatement(getVehicleQuery);
        stmt.setInt(1, Integer.parseInt(bookingId));

        rs = stmt.executeQuery();

        if (rs.next()) {
            int vehicleId = rs.getInt("vehicle_id");

            // Update booking status
            String updateBookingQuery = "UPDATE bookings SET status = ? WHERE id = ?";
            stmt = conn.prepareStatement(updateBookingQuery);
            stmt.setString(1, newStatus);
            stmt.setInt(2, Integer.parseInt(bookingId));

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0 && "assigned".equals(newStatus)) {
                // Update vehicle status to 'On Trip' when the booking is assigned
                String updateVehicleQuery = "UPDATE vehicles SET status = 'On Trip' WHERE id = ?";
                vehicleStmt = conn.prepareStatement(updateVehicleQuery);
                vehicleStmt.setInt(1, vehicleId);

                int vehicleRowsUpdated = vehicleStmt.executeUpdate();

                if (vehicleRowsUpdated > 0) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("vehicle_update_error");
                }
            } else {
                response.getWriter().write("error");
            }
        } else {
            response.getWriter().write("booking_not_found");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.getWriter().write("error");
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (vehicleStmt != null) vehicleStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
