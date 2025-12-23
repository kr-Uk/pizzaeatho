package com.ssafy.pizza.model.dto;

public class UserResponse {
    private Integer userId;
    private String id;
    private String name;
    private Integer payment;

    public UserResponse() {}

    public UserResponse(Integer userId, String id, String name, Integer payment) {
        this.userId = userId;
        this.id = id;
        this.name = name;
        this.payment = payment;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getPayment() {
        return payment;
    }

    public void setPayment(Integer payment) {
        this.payment = payment;
    }
}

