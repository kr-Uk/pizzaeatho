package com.ssafy.pizza.model.dto;

public class Product {
    private Integer productId;
    private String name;
    private Integer basePrice;
    
    public Product(Integer productId, String name, Integer basePrice) {
        this.productId = productId;
        this.name = name;
        this.basePrice = basePrice;
    }
    
    public Product(String name, Integer basePrice) {
        this.name = name;
        this.basePrice = basePrice;
    }
    public Product() {}
    
	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

    public Integer getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(Integer basePrice) {
        this.basePrice = basePrice;
    }

	@Override
	public String toString() {
		return "Product [productId=" + productId + ", name=" + name + ", basePrice=" + basePrice + "]";
	}
    
    
    
    
}

