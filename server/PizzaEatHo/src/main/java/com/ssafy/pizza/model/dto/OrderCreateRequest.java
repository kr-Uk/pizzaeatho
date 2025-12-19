package com.ssafy.pizza.model.dto;

import java.util.List;

public class OrderCreateRequest {
    private Integer userId;
    private String orderTable;
    private Integer productId;
    private Integer doughId;
    private Integer crustId;
    private List<OrderToppingRequest> toppings;
    private Integer unitPrice;

    public OrderCreateRequest() {}

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getOrderTable() {
        return orderTable;
    }

    public void setOrderTable(String orderTable) {
        this.orderTable = orderTable;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getDoughId() {
        return doughId;
    }

    public void setDoughId(Integer doughId) {
        this.doughId = doughId;
    }

    public Integer getCrustId() {
        return crustId;
    }

    public void setCrustId(Integer crustId) {
        this.crustId = crustId;
    }

    public List<OrderToppingRequest> getToppings() {
        return toppings;
    }

    public void setToppings(List<OrderToppingRequest> toppings) {
        this.toppings = toppings;
    }

    public Integer getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Integer unitPrice) {
        this.unitPrice = unitPrice;
    }
}

