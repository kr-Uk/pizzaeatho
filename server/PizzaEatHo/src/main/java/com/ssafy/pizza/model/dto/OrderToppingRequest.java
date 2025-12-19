package com.ssafy.pizza.model.dto;

public class OrderToppingRequest {
    private Integer toppingId;
    private Integer quantity;

    public OrderToppingRequest() {}

    public Integer getToppingId() {
        return toppingId;
    }

    public void setToppingId(Integer toppingId) {
        this.toppingId = toppingId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}

