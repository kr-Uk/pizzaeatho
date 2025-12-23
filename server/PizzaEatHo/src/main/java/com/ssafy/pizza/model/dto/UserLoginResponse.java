package com.ssafy.pizza.model.dto;

public class UserLoginResponse {
    private Integer userId;
    private String name;
    private Integer payment;

    public UserLoginResponse() {}

    public UserLoginResponse(Integer userId, String name, Integer payment) {
        this.userId = userId;
        this.name = name;
        this.payment = payment;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
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

