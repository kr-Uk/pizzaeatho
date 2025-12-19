package com.ssafy.pizza.model.dto;

public class OrderDetailInfo {
    private Integer id;
    private Integer orderId;
    private Integer productId;
    private Integer quantity;
    
    private String img; // ?í’ˆ?´ë?ì§€
	private String name;// ?í’ˆëª?
    private String type; // ?í’ˆ ì¢…ë¥˜
    private String unitPrice; //?í’ˆê°€ê²?
    private int sumPrice; // quantity * ?í’ˆê°€ê²?
    
    public OrderDetailInfo(Integer id, Integer orderId, Integer productId, Integer quantity) {
        super();
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
    }
    
    public OrderDetailInfo(Integer productId, Integer quantity) {
        this.productId = productId;
        this.quantity = quantity;
    }
    
    public OrderDetailInfo(Integer orderId, Integer productId, Integer quantity) {
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
    }
    
    public OrderDetailInfo() {}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
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

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	
    public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(String unitPrice) {
		this.unitPrice = unitPrice;
	}

	public int getSumPrice() {
		return sumPrice;
	}

	public void setSumPrice(int sumPrice) {
		this.sumPrice = sumPrice;
	}

    
}

