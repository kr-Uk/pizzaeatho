package com.ssafy.pizza.model.dto;

public class UserLoginResponse {
    private Integer userId;
    private String name;
    private Integer stamp;

    public UserLoginResponse() {}

    public UserLoginResponse(Integer userId, String name, Integer stamp) {
        this.userId = userId;
        this.name = name;
        this.stamp = stamp;
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

    public Integer getStamp() {
        return stamp;
    }

    public void setStamp(Integer stamp) {
        this.stamp = stamp;
    }
}

