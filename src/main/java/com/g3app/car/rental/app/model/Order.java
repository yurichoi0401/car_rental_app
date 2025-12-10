package com.g3app.car.rental.app.model;

public class Order {
    private String orderId;
    private String vin;
    private String customerName;
    private String phone;
    private String email;
    private String licenseNo;
    private String startDate;  
    private int days;
    private String status;      

    public Order() {}
    
    public String getOrderId() { return orderId; }
    public void setOrderId (String orderId) { this.orderId = orderId; }
    
    public String getVin() { return vin; }
    public void setVin(String vin) { this.vin = vin; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail (String email) { this.email = email; }
    
    public String getLicenseNo() { return licenseNo; }
    public void setLicenseNo (String licenseNo) { this.licenseNo = licenseNo; }
    
    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    
    public int getDays() { return days; }
    public void setDays (int days) { this.days = days; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
