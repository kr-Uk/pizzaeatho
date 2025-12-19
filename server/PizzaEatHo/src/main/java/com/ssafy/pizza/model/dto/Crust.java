package com.ssafy.pizza.model.dto;

public class Crust {
    private Integer crustId;
    private String name;
    private Integer extraPrice;

    public Crust() {}

    public Crust(Integer crustId, String name, Integer extraPrice) {
        this.crustId = crustId;
        this.name = name;
        this.extraPrice = extraPrice;
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

    public Integer getExtraPrice() {
        return extraPrice;
    }

    public void setExtraPrice(Integer extraPrice) {
        this.extraPrice = extraPrice;
    }
}

