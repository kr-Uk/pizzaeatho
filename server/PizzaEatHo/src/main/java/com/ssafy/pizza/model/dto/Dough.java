package com.ssafy.pizza.model.dto;

public class Dough {
    private Integer doughId;
    private String name;
    private Integer extraPrice;

    public Dough() {}

    public Dough(Integer doughId, String name, Integer extraPrice) {
        this.doughId = doughId;
        this.name = name;
        this.extraPrice = extraPrice;
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

    public Integer getExtraPrice() {
        return extraPrice;
    }

    public void setExtraPrice(Integer extraPrice) {
        this.extraPrice = extraPrice;
    }
}

