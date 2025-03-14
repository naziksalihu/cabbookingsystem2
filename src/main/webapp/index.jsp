<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            background: url('https://source.unsplash.com/1600x900/?taxi,city') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.7);
        }
        .overlay {
            background: rgba(0, 0, 0, 0.6);
            padding: 50px;
            border-radius: 10px;
            text-align: center;
        }
        .btn-custom {
            font-size: 20px;
            padding: 10px 30px;
        }
    </style>
</head>
<body>

<div class="overlay">
    <h1 class="mb-4">Welcome to Mega City Cab</h1>
    <p class="lead mb-4">Book a ride with ease and comfort.</p>
    <a href="login.jsp" class="btn btn-primary btn-lg btn-custom">Get Started</a>
</div>

</body>
</html>
