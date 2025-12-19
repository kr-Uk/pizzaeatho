package com.ssafy.pizza.model.dto;

import java.util.Date;

public class OrderListItem {
    private Integer orderId;
    private Date orderTime;
    private String status;
    private Integer totalPrice;

    public OrderListItem() {}

    public OrderListItem(Integer orderId, Date orderTime, String status, Integer totalPrice) {
        this.orderId = orderId;
        this.orderTime = orderTime;
        this.status = status;
        this.totalPrice = totalPrice;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Date getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Date orderTime) {
        this.orderTime = orderTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Integer totalPrice) {
        this.totalPrice = totalPrice;
    }
}

