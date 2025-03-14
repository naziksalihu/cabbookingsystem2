package com.example.cabbookingsystem2.servlets;

import com.example.cabbookingsystem2.dao.DestinationDAO;
import com.example.cabbookingsystem2.models.Destination;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/addDestination")
public class AddDestinationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));

        Destination destination = new Destination(name, price);
        DestinationDAO destinationDAO = new DestinationDAO();

        if (destinationDAO.addDestination(destination)) {
            response.getWriter().write("Destination added successfully!");
        } else {
            response.getWriter().write("Error adding destination.");
        }
    }
}
