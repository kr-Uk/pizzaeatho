package com.ssafy.pizza.model.dto;

public class Dough {
    private Integer doughId;
    private String name;
    private Integer price;
    private String image;

    public Dough() {}

    public Dough(Integer doughId, String name, Integer price, String image) {
        this.doughId = doughId;
        this.name = name;
        this.price = price;
        this.image = image;
    }

    public Integer getDoughId() {
        return doughId;
    }

    public void setDoughId(Integer doughId) {
        this.doughId = doughId;
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

