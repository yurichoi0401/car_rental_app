<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Car Rental</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header class="header">
  <div class="header-content">
    <div class="logo-container">
      <img src="img/logo.jpg" alt="Logo" id="logo" onclick="location.href='index.jsp'">
    </div>

    <div class="search-filter-group">
      <select id="type-filter">
        <option value="all">All Types</option>
        <option value="Sedan">Sedan</option>
        <option value="SUV">SUV</option>
        <option value="Wagon">Wagon</option>
        <option value="Electric">Electric</option>
      </select>

      <select id="brand-filter">
        <option value="all">All Brands</option>
        <option value="Toyota">Toyota</option>
        <option value="Honda">Honda</option>
        <option value="Kia">Kia</option>
        <option value="Suzuki">Suzuki</option>
        <option value="Tesla">Tesla</option>
        <option value="Ford">Ford</option>
        <option value="Hyundai">Hyundai</option>
        <option value="Volvo">Volvo</option>


      </select>

      <input type="text" id="search-box" placeholder="Search cars...">
      <button id="search-btn">Search</button>
    </div>
  </div>
</header>

  <main>
    <h1 style="text-align:center;">Available Cars</h1>
    <div id="car-list" class="grid-container">
    </div>
  </main>

  <script src="js/main.js"></script>

</body>
</html>
