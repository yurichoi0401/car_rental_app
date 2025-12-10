<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@ page import="com.g3app.car.rental.app.model.Car" %>
<%@ page import="com.g3app.car.rental.app.model.Order" %>
<%@ page import="java.util.*, java.io.*, java.time.*, java.time.temporal.ChronoUnit" %>
<%
  request.setCharacterEncoding("UTF-8");

  String vin = request.getParameter("vin");
  String name = request.getParameter("name");
  String startDate = request.getParameter("startDate");
  String endDate = request.getParameter("endDate");
  String phone = request.getParameter("phone");
  String email = request.getParameter("email");
  String license = request.getParameter("license");
  double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));

  int days = 0;
  double total = 0.0;

  try {
    java.time.LocalDate start = java.time.LocalDate.parse(startDate);
    java.time.LocalDate end = java.time.LocalDate.parse(endDate);
    days = (int) java.time.temporal.ChronoUnit.DAYS.between(start, end);
    total = days * pricePerDay;

    ServletContext context = getServletContext();
    ObjectMapper mapper = new ObjectMapper();
    String carPath = context.getRealPath("/WEB-INF/data/cars.json");
    List<Car> cars = mapper.readValue(new File(carPath), new TypeReference<List<Car>>() {});
    for (Car car : cars) {
      if (car.getVin().equals(vin)) {
        car.setAvailable(false);
        break;
      }
    }
    mapper.writerWithDefaultPrettyPrinter().writeValue(new File(carPath), cars);

    String orderPath = context.getRealPath("/WEB-INF/data/orders.json");
    List<Order> orders = new ArrayList<>();
    File orderFile = new File(orderPath);
    if (orderFile.exists()) {
      orders = mapper.readValue(orderFile, new TypeReference<List<Order>>() {});
    }

    Order order = new Order();
    order.setOrderId(UUID.randomUUID().toString());
    order.setVin(vin);
    order.setCustomerName(name);
    order.setPhone(phone);
    order.setEmail(email);
    order.setLicenseNo(license);
    order.setStartDate(startDate);
    order.setDays(days);
    order.setStatus("Confirmed");
    orders.add(order);
    mapper.writerWithDefaultPrettyPrinter().writeValue(orderFile, orders);
%>

<div class="confirmation">
  <h2>Reservation Confirmed!</h2>
  <p>Thank you, <strong><%= name %></strong>! Your order has been placed.</p>

  <div class="order-details" style="margin-top: 30px; text-align: left; max-width: 600px; margin: auto; background: #f4f4f4; padding: 20px; border-radius: 10px;">
    <h3>Order Details</h3>
    <p><strong>VIN:</strong> <%= vin %></p>
    <p><strong>Rental Period:</strong> <%= startDate %> to <%= endDate %></p>
    <p><strong>Total Days:</strong> <%= days %> day(s)</p>
    <p><strong>Price per Day:</strong> $<%= String.format("%.2f", pricePerDay) %></p>
    <p><strong>Total Price:</strong> $<%= String.format("%.2f", total) %></p>
    <p><strong>Status:</strong> Confirmed</p>
  </div>

  <br>
  <a href="index.jsp" onclick="localStorage.removeItem('reservationForm')">Back to Home</a>
</div>

<%
  } catch (Exception e) {
    out.println("<p style='color:red;'>Reservation failed: " + e.getMessage() + "</p>");
  }
%>
