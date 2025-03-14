<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Destination</title>
</head>
<body>
<h2>Add Destination</h2>
<form action="addDestination" method="POST">
    <label for="name">Destination Name:</label>
    <input type="text" name="name" id="name" required><br>
    <label for="price">Price:</label>
    <input type="number" name="price" id="price" step="0.01" required><br>
    <button type="submit">Add Destination</button>
</form>
</body>
</html>
