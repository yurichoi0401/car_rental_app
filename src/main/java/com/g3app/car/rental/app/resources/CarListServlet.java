package com.g3app.car.rental.app.resources;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.g3app.car.rental.app.model.Car;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletContext;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@WebServlet("/api/cars")
public class CarListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ServletContext context = getServletContext();
        InputStream is = context.getResourceAsStream("/WEB-INF/data/cars.json");

        if (is == null) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"Could not load cars.json\"}");
            return;
        }

        List<Car> cars = new ObjectMapper().readValue(is, new TypeReference<List<Car>>() {});
        resp.setContentType("application/json;charset=UTF-8");
        new ObjectMapper().writeValue(resp.getWriter(), cars);
    }
}
