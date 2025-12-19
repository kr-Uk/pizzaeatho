package com.ssafy.pizza.model.dto;

public class OrderDetailTopping {
    private Integer orderDetailId;
    private Integer toppingId;
    private Integer quantity;

    public OrderDetailTopping() {}

    public OrderDetailTopping(Integer orderDetailId, Integer toppingId, Integer quantity) {
        this.orderDetailId = orderDetailId;
        this.toppingId = toppingId;
        this.quantity = quantity;
    }

    public Integer getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(Integer orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

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

