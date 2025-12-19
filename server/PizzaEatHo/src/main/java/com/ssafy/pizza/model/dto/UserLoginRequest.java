package com.ssafy.pizza.model.dto;

public class UserLoginRequest {
    private String id;
    private String pw;

    public UserLoginRequest() {}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }
}

