package com.ssafy.pizza.model.dto;

import java.util.List;

public class OrderDetailResponse {
    private Integer orderId;
    private Integer orderDetailId;
    private Integer productId;
    private String product;
    private String dough;
    private String crust;
    private List<OrderToppingInfo> toppings;
    private Integer unitPrice;
    private String status;

    public OrderDetailResponse() {}

    public OrderDetailResponse(Integer orderId, Integer orderDetailId, Integer productId, String product, String dough, String crust,
            List<OrderToppingInfo> toppings, Integer unitPrice, String status) {
        this.orderId = orderId;
        this.orderDetailId = orderDetailId;
        this.productId = productId;
        this.product = product;
        this.dough = dough;
        this.crust = crust;
        this.toppings = toppings;
        this.unitPrice = unitPrice;
        this.status = status;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(Integer orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public String getDough() {
        return dough;
    }

    public void setDough(String dough) {
        this.dough = dough;
    }

    public String getCrust() {
        return crust;
    }

    public void setCrust(String crust) {
        this.crust = crust;
    }

    public List<OrderToppingInfo> getToppings() {
        return toppings;
    }

    public void setToppings(List<OrderToppingInfo> toppings) {
        this.toppings = toppings;
    }

    public Integer getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Integer unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

