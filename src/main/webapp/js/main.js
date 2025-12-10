document.addEventListener("DOMContentLoaded", () => {
  const carListEl = document.getElementById("car-list");
  const searchInput = document.getElementById("search-box");
  const typeFilter = document.getElementById("type-filter");
  const brandFilter = document.getElementById("brand-filter");

  const suggestionList = document.createElement("ul");
  suggestionList.id = "suggestion-list";
  suggestionList.style.position = "absolute";
  suggestionList.style.background = "#fff";
  suggestionList.style.border = "1px solid #ccc";
  suggestionList.style.zIndex = "10";
  searchInput.parentNode.appendChild(suggestionList);

  let allCars = [];

  fetch("api/cars", { cache: "no-store" })
    .then(res => res.json())
    .then(data => {
      allCars = data;
      renderCars(allCars);
    });

  function renderCarCard(car) {
    const card = document.createElement("div");
    card.className = "car-card";

    card.innerHTML = `
      <img src="${car.image}" class="car-image" alt="${car.carModel}">
      <h3>${car.brand} ${car.carModel}</h3>
      <p>Type: ${car.carType}</p>
      <p>Price: $${car.pricePerDay}/day</p>
      <p class="${car.available ? 'available' : 'unavailable'}">
        ${car.available ? 'Available' : 'Unavailable'}
      </p>
      <button ${!car.available ? 'disabled' : ''} onclick="location.href='reservation.jsp?vin=${car.vin}'">
        ${car.available ? 'Rent' : 'Sold Out'}
      </button>
    `;

    carListEl.appendChild(card);
  }

  function renderCars(cars) {
    carListEl.innerHTML = "";
    cars.forEach(car => renderCarCard(car));
  }

  function applyFiltersAndSearch() {
    const type = typeFilter.value;
    const brand = brandFilter.value;
    const keyword = searchInput.value.toLowerCase();

    let filtered = allCars;

    if (type !== "all") {
      filtered = filtered.filter(car => car.carType === type);
    }
    if (brand !== "all") {
      filtered = filtered.filter(car => car.brand === brand);
    }
    if (keyword) {
      filtered = filtered.filter(car =>
        car.carType.toLowerCase().includes(keyword) ||
        car.brand.toLowerCase().includes(keyword) ||
        car.carModel.toLowerCase().includes(keyword) ||
        car.description.toLowerCase().includes(keyword)
      );
    }
    renderCars(filtered);
  }

  searchInput.addEventListener("input", () => {
    const keyword = searchInput.value.toLowerCase();
    suggestionList.innerHTML = "";

    if (!keyword) {
      applyFiltersAndSearch();
      return;
    }

    const suggestions = allCars.filter(car =>
      car.carType.toLowerCase().includes(keyword) ||
      car.brand.toLowerCase().includes(keyword) ||
      car.carModel.toLowerCase().includes(keyword) ||
      car.description.toLowerCase().includes(keyword)
    );

    suggestions.slice(0, 5).forEach(car => {
      const li = document.createElement("li");
      li.textContent = `${car.brand} ${car.carModel}`;
      li.style.padding = "6px";
      li.style.cursor = "pointer";
      li.addEventListener("click", () => {
        searchInput.value = li.textContent;
        suggestionList.innerHTML = "";
        renderCars([car]);
      });
      suggestionList.appendChild(li);
    });
  });

  document.getElementById("search-btn").addEventListener("click", applyFiltersAndSearch);
  [typeFilter, brandFilter].forEach(filterEl => {
    filterEl.addEventListener("change", applyFiltersAndSearch);
  });
});
