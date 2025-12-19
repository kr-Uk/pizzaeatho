package com.ssafy.pizza.model.dto;

public class OrderDetail {
    private Integer orderDetailId;
    private Integer orderId;
    private Integer productId;
    private Integer doughId;
    private Integer crustId;
    private Integer quantity;
    private Integer unitPrice;
    
    public OrderDetail(Integer orderDetailId, Integer orderId, Integer productId, Integer doughId, Integer crustId,
            Integer quantity, Integer unitPrice) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.productId = productId;
        this.doughId = doughId;
        this.crustId = crustId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    public OrderDetail(Integer orderId, Integer productId, Integer doughId, Integer crustId, Integer quantity,
            Integer unitPrice) {
        this.orderId = orderId;
        this.productId = productId;
        this.doughId = doughId;
        this.crustId = crustId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    public OrderDetail() {}

	public Integer getOrderDetailId() {
		return orderDetailId;
	}

	public void setOrderDetailId(Integer orderDetailId) {
		this.orderDetailId = orderDetailId;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

    public Integer getDoughId() {
        return doughId;
    }

    public void setDoughId(Integer doughId) {
        this.doughId = doughId;
    }

    public Integer getCrustId() {
        return crustId;
    }

    public void setCrustId(Integer crustId) {
        this.crustId = crustId;
    }

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

    public Integer getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Integer unitPrice) {
        this.unitPrice = unitPrice;
    }

	@Override
	public String toString() {
		return "OrderDetail [orderDetailId=" + orderDetailId + ", orderId=" + orderId + ", productId=" + productId
				+ ", doughId=" + doughId + ", crustId=" + crustId + ", quantity=" + quantity + ", unitPrice="
				+ unitPrice + "]";
	}
    
    
}

