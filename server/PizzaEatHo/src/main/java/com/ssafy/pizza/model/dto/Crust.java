package com.ssafy.pizza.model.dto;

public class Crust {
    private Integer crustId;
    private String name;
    private Integer price;
    private String image;

    public Crust() {}

    public Crust(Integer crustId, String name, Integer price, String image) {
        this.crustId = crustId;
        this.name = name;
        this.price = price;
        this.image = image;
    }

    public Integer getCrustId() {
        return crustId;
    }

    public void setCrustId(Integer crustId) {
        this.crustId = crustId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}

