package com.ssafy.pizza.model.dto;

import java.util.List;

public class DefaultToppingResponse {
    private List<Integer> toppingId;

    public DefaultToppingResponse() {}

    public DefaultToppingResponse(List<Integer> toppingId) {
        this.toppingId = toppingId;
    }

    public List<Integer> getToppingId() {
        return toppingId;
    }

    public void setToppingId(List<Integer> toppingId) {
        this.toppingId = toppingId;
    }
}
