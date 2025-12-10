<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@ page import="com.g3app.car.rental.app.model.Car" %>
<%@ page import="java.util.*, java.io.*" %>
<%
  String vin = request.getParameter("vin");
  double pricePerDay = 0.0;
  if (vin != null) {
    ServletContext context = getServletContext();
    ObjectMapper mapper = new ObjectMapper();
    String carPath = context.getRealPath("/WEB-INF/data/cars.json");
    List<Car> cars = mapper.readValue(new File(carPath), new TypeReference<List<Car>>() {});
    for (Car car : cars) {
      if (car.getVin().equals(vin)) {
        pricePerDay = car.getPricePerDay();
        break;
      }
    }
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reservation</title>
  <link rel="stylesheet" href="css/style.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<header class="header">
  <div class="header-content">
    <div class="logo-container">
      <img src="img/logo.jpg" alt="Logo" onclick="location.href='index.jsp'">
    </div>
  </div>
</header>

<div class="confirmation">
  <h2>Complete Your Reservation</h2>
  <form id="reservationForm" class="reservation-form">
    <input type="hidden" name="vin" id="vin" value="<%= vin %>">

    <label for="startDate">Start Date:</label>
    <input type="date" name="startDate" id="startDate" required>

    <label for="endDate">End Date:</label>
    <input type="date" name="endDate" id="endDate" required>

    <label for="name">Full Name:</label>
    <input type="text" name="name" required>

    <label for="phone">Phone:</label>
    <input type="text" name="phone">

    <label for="email">Email:</label>
    <input type="email" name="email">

    <label for="license">Driver's License:</label>
    <input type="text" name="license" id="license" minlength="8" required>

    <input type="hidden" name="pricePerDay" id="pricePerDay" value="<%= pricePerDay %>">
    <div class="total">
      Total Price: <strong>$<span id="totalDisplay">0.00</span></strong>
    </div>

    <div class="buttons">
    <button type="submit" id="submitBtn" disabled>Place Order</button>
      <button type="button" class="cancel" onclick="location.href='index.jsp'">Cancel</button>
    </div>
  </form>
</div>

<script>
  const pricePerDay = parseFloat(document.getElementById('pricePerDay').value);
  const startDateInput = document.getElementById('startDate');
  const endDateInput = document.getElementById('endDate');
  const totalDisplay = document.getElementById('totalDisplay');
  
  function validateForm() {
  const name = document.querySelector('input[name="name"]').value.trim();
  const phone = document.querySelector('input[name="phone"]').value.trim();
  const email = document.querySelector('input[name="email"]').value.trim();
  const license = document.getElementById('license').value.trim();
  const start = startDateInput.value;
  const end = endDateInput.value;

  const isValid =
    name !== "" &&
    phone !== "" &&
    email !== "" &&
    license.length >= 8 &&
    start !== "" &&
    end !== "" &&
    new Date(end) > new Date(start);

  document.getElementById('submitBtn').disabled = !isValid;
  updateTotal();
}

['name', 'phone', 'email', 'license', 'startDate', 'endDate'].forEach(id => {
  document.getElementById(id)?.addEventListener('input', validateForm);
});


  function updateTotal() {
    const start = new Date(startDateInput.value);
    const end = new Date(endDateInput.value);
    if (start && end && end > start) {
      const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
      const total = days * pricePerDay;
      totalDisplay.textContent = total.toFixed(2);
    } else {
      totalDisplay.textContent = '0.00';
    }
  }

  window.addEventListener('DOMContentLoaded', () => {
    const today = new Date().toISOString().split('T')[0];
    startDateInput.min = today;
    endDateInput.min = today;
    startDateInput.addEventListener('change', updateTotal);
    endDateInput.addEventListener('change', updateTotal);
  });

  $('#reservationForm').on('submit', function(e) {
    e.preventDefault();

    $.ajax({
      url: 'reservation-step3.jsp',
      method: 'POST',
      data: $(this).serialize(),
      success: function(response) {
        $('.confirmation').html(response); 
      },
      error: function() {
        alert('Reservation failed. Please try again.');
      }
    });
  });
</script>
</body>
</html>