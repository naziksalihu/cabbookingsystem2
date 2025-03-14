<%@ page import="java.util.List" %>
<%@ page import="com.example.cabbookingsystem2.models.Destination" %>
<%@ page import="com.example.cabbookingsystem2.dao.DestinationDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Destinations</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Manage Destinations</h2>

    <!-- Form to add destination -->
    <form action="addDestination" method="POST" id="addDestinationForm">

        <div class="mb-3">
            <label for="name" class="form-label">Destination Name</label>
            <input type="text" id="name" name="name" required class="form-control" placeholder="Enter destination name">
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">Price</label>
            <input type="number" id="price" name="price" required step="0.01" class="form-control" placeholder="Enter price">
        </div>

        <button type="submit" class="btn btn-primary">Add Destination</button>
    </form>

    <hr>

    <!-- Table to display existing destinations -->
    <h3 class="mt-4">Existing Destinations</h3>
    <table id="destinationTable" class="table table-bordered">
        <thead>
        <tr>
            <th>Destination</th>
            <th>Price</th>
        </tr>
        </thead>
        <tbody>
        <% List<Destination> destinations = (List<Destination>) request.getAttribute("destinations");
            if (destinations != null) {
                for (Destination dest : destinations) { %>
        <tr>
            <td><%= dest.getName() %></td>
            <td><%= dest.getPrice() %></td>
        </tr>
        <% }} %>
        </tbody>
    </table>
</div>
</body>
</html>
