package com.ssafy.pizza.model.dto;

public class Topping {
    private Integer toppingId;
    private String name;
    private Integer price;
    private String image;

    public Topping() {}

    public Topping(Integer toppingId, String name, Integer price, String image) {
        this.toppingId = toppingId;
        this.name = name;
        this.price = price;
        this.image = image;
    }

    public Integer getToppingId() {
        return toppingId;
    }

    public void setToppingId(Integer toppingId) {
        this.toppingId = toppingId;
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

