package com.ssafy.pizza.model.dto;

public class Order {
    private Integer orderId;
    private Integer userId;
    private String orderTable;
    private java.util.Date orderTime;
    private String status;
    

    public Order(Integer orderId, Integer userId, String orderTable, java.util.Date orderTime, String status) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderTable = orderTable;
        this.orderTime = orderTime;
        this.status = status;
    }

    public Order(Integer userId, String orderTable, java.util.Date orderTime, String status) {
        this.userId = userId;
        this.orderTable = orderTable;
        this.orderTime = orderTime;
        this.status = status;
    }
    
    public Order() {}

        
	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public String getOrderTable() {
		return orderTable;
	}

	public void setOrderTable(String orderTable) {
		this.orderTable = orderTable;
	}

	public java.util.Date getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(java.util.Date orderTime) {
		this.orderTime = orderTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "Order [orderId=" + orderId + ", userId=" + userId + ", orderTable=" + orderTable + ", orderTime="
				+ orderTime + ", status=" + status + "]";
	}
    
    
}

