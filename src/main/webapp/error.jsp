<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            color: #333;
            padding: 30px;
            text-align: center;
        }
        .error-container {
            background-color: #f44336;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin: 20px auto;
            width: 80%;
            max-width: 600px;
        }
        h1 {
            font-size: 2em;
        }
        p {
            font-size: 1.2em;
        }
        .stacktrace {
            background-color: #fff;
            color: #333;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
            overflow-x: auto;
            text-align: left;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
<div class="error-container">
    <h1>Oops! Something went wrong.</h1>
    <p>We are sorry, but an error occurred while processing your request. Please try again later.</p>

    <!-- Display the exception if available -->
    <%
        Throwable exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
        if (exception != null) {
    %>
    <div class="stacktrace">
        <h3>Error Details:</h3>
        <p><strong>Exception:</strong> <%= exception.getClass().getName() %></p>
        <p><strong>Message:</strong> <%= exception.getMessage() %></p>
        <p><strong>Stack Trace:</strong></p>
        <pre><%= exception.getStackTrace() %></pre>
    </div>
    <%
        }
    %>
</div>
</body>
</html>
