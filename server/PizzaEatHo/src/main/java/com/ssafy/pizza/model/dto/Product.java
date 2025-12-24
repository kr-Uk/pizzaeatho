package com.ssafy.pizza.model.dto;

public class Product {
    private Integer productId;
    private String name;
    private String description;
    private Integer price;
    private String image;
    
    public Product(Integer productId, String name, String description, Integer price, String image) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
    }
    
    public Product(String name, String description, Integer price, String image) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

	@Override
	public String toString() {
		return "Product [productId=" + productId + ", name=" + name + ", description=" + description + ", price="
				+ price + ", image=" + image + "]";
	}
    
    
    
    
}

