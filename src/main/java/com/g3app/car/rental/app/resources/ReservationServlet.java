package com.g3app.car.rental.app.resources;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.g3app.car.rental.app.model.Order;
import com.g3app.car.rental.app.model.Car;


import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.util.*;

@WebServlet("/api/reserve")
public class ReservationServlet extends HttpServlet {

    private static final String ORDER_FILE_PATH = "WEB-INF/data/orders.json";
    private static final String CAR_FILE_PATH = "WEB-INF/data/cars.json";


    private List<Order> loadOrders(ServletContext context) throws IOException {
        InputStream is = context.getResourceAsStream(ORDER_FILE_PATH);
        if (is == null) return new ArrayList<>();
        return new ObjectMapper().readValue(is, new TypeReference<List<Order>>() {});
    }

    private void saveOrders(ServletContext context, List<Order> orders) throws IOException {
        String realPath = context.getRealPath(ORDER_FILE_PATH);
        File file = new File(realPath);
        file.getParentFile().mkdirs();

        try (FileWriter writer = new FileWriter(file)) {
            new ObjectMapper().writerWithDefaultPrettyPrinter().writeValue(writer, orders);
        }
    }

    private List<Car> loadCars(ServletContext context) throws IOException {
        InputStream is = context.getResourceAsStream(CAR_FILE_PATH);
        if (is == null) return new ArrayList<>();
        return new ObjectMapper().readValue(is, new TypeReference<List<Car>>() {});
    }

    private void saveCars(ServletContext context, List<Car> cars) throws IOException {
        String realPath = context.getRealPath(CAR_FILE_PATH);
        File file = new File(realPath);
        file.getParentFile().mkdirs();

        try (FileWriter writer = new FileWriter(file)) {
            new ObjectMapper().writerWithDefaultPrettyPrinter().writeValue(writer, cars);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = getServletContext();
        List<Order> orders = loadOrders(context);
        List<Car> cars = loadCars(context);

        String vin = req.getParameter("vin");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String license = req.getParameter("license");
        String startDate = req.getParameter("startDate");
        int days = Integer.parseInt(req.getParameter("days"));

        Order order = new Order();
        order.setOrderId(UUID.randomUUID().toString());
        order.setVin(vin);
        order.setCustomerName(name);
        order.setPhone(phone);
        order.setEmail(email);
        order.setLicenseNo(license);
        order.setStartDate(startDate);
        order.setDays(days);
        order.setStatus("confirmed");

        orders.add(order);
        saveOrders(context, orders);

        for (Car car : cars) {
            if (car.getVin().equals(vin)) {
                car.setAvailable(false);
                break;
            }
        }
        saveCars(context, cars);

        resp.setContentType("application/json");
        resp.getWriter().write("{\"status\":\"success\"}");
    }
}
